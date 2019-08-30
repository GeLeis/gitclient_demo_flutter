import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/index.dart';
import 'CacheObject.dart';
import 'Network.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red
];

class Global {
  //类变量 ----------
  //本地存储，小数据
  static SharedPreferences _prefs;
  //用户登录等信息
  static Profile profile = Profile();
  //缓存
  static NetCache netcache = NetCache();
  //可选主题
  static List<MaterialColor> get themes => _themes;
  //是否为release版
  static bool get isRelease => bool.fromEnvironment('dart.vm.product');

  static Future init() async{
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString('profile');
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print('getProfile error = $e');
      }
    }

    //如果没有缓存策略，设置默认缓存策略
    profile.cache = profile.cache ?? CacheConfig()
      ..enable = true
      ..maxAge = 3600
      ..maxCount = 100;

    //初始化网络请求配置

    Network.init();
  }

  //持久化profile信息
  static saveProfile() => _prefs.setString('profile', json.encode(profile));
}