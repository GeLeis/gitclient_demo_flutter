import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';


//Locale资源类
class GmLocalizations {
  GmLocalizations(this.isZh);
  //是否为中文
  bool isZh = false;
  //为了使用方便，我们定义一个静态方法
  static GmLocalizations of(BuildContext context) {
    return Localizations.of<GmLocalizations>(context, GmLocalizations);
  }
  //Locale相关值，title为应用标题
  String get title {
    return isZh ? "Flutter应用" : "Flutter APP";
  }

  String get home {
    return isZh ? "Github客户端" : "Github Client";
  }

  String get login {
    return isZh ? "登录" : "login";
  }

  String get theme {
    return isZh ? "主题" : "theme";
  }

  String get language {
    return isZh ? "语言" : "language";
  }

  String get logout {
    return isZh ? "退出登录" : "logout";
  }

  String get logoutTip {
    return isZh ? "确定退出" : "confirm to logout";
  }

  String get cancel {
    return isZh ? "取消" : "cancel";
  }

  String get yes {
    return isZh ? "确定" : "YES";
  }

  String get noDescription {
    return isZh ? "无任何描述" : "noDescription";
  }

  String get userName {
    return isZh ? "用户名" : "userName";
  }

  String get userNameOrEmail {
    return isZh ? "用户名或邮箱" : "userNameOrEmail";
  }

  String get userNameRequired {
    return isZh ? "用户名必填" : "userNameRequired";
  }

  String get password {
    return isZh ? "密码" : "password";
  }

  String get passwordRequired {
    return isZh ? "密码不能为空" : "passwordRequired";
  }

  String get userNameOrPasswordWrong {
    return isZh ? "用户名或者密码错误" : "userNameOrPasswordWrong";
  }

  String get auto {
    return isZh ? "跟随系统" : "auto";
  }


}

//Locale代理类
class GmLocalizationsDelegate extends LocalizationsDelegate<GmLocalizations> {
  const GmLocalizationsDelegate();

  //是否支持某个Local
  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  // Flutter会调用此类加载相应的Locale资源类
  @override
  Future<GmLocalizations> load(Locale locale) {
    print("xxxx$locale");
    return SynchronousFuture<GmLocalizations>(
        GmLocalizations(locale.languageCode == "zh")
    );
  }

  @override
  bool shouldReload(GmLocalizationsDelegate old) => false;
}