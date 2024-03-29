import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:glgitclient/common/global.dart';
import '../models/index.dart';

class Network {
  Network([this.context]) {
    _options = Options(extra: {'context':context});
  }
  BuildContext context;
  Options _options;

  static Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.github.com',
      headers: {
        HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
            "application/vnd.github.symmetra-preview+json",
      }
    )
  );

  static void init() {
    //添加缓存插件
    dio.interceptors.add(Global.netcache);
    //设置授权token
    dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;
    //在调试模式下需要抓包调试
    if (!Global.isRelease){
//      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client){
//        client.findProxy = (uri){
//          return 'PROXY 10.0.3.224:8888';
//        };
//        //代理工具会提供一个抓包的自签名证书，会通不过证书娇艳，所以我们禁用证书校验
//        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//      };
    }
  }

  // 登录接口，登录成功后返回用户信息
  Future<User> login(String login, String pwd) async {
    String basic = 'Basic ' + base64.encode(utf8.encode('$login:$pwd'));
    print('logining-------------start');
    var r = await dio.get(
      "/users/$login",
      options: _options.merge(headers: {
        HttpHeaders.authorizationHeader: basic
      }, extra: {
        "noCache": true, //本接口禁用缓存
      }),
    );
    print('logining-------------');
    //登录成功后更新公共头（authorization），此后的所有请求都会带上用户身份信息
    dio.options.headers[HttpHeaders.authorizationHeader] = basic;
    //清空所有缓存
    Global.netcache.cache.clear();
    //更新profile中的token信息
    Global.profile.token = basic;
    return User.fromJson(r.data);
  }

  //获取用户项目列表
  Future<List<Repo>> getRepos(
      {Map<String, dynamic> queryParameters, //query参数，用于接收分页信息
        refresh = false}) async {
    if (refresh) {
      // 列表下拉刷新，需要删除缓存（拦截器中会读取这些信息）
      _options.extra.addAll({"refresh": true, "list": true});
    }
    print('---------fetching------start-------');
    var r = await dio.get<List>(
      "/user/repos",
      queryParameters: queryParameters,
      options: _options,
    );
    print('resut = $r');
    return r.data.map((e) {
      print('subItem $e');
      return Repo.fromJson(e);
    }).toList();
  }
}