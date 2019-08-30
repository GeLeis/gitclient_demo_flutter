import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glgitclient/common/global.dart';
import '../models/index.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  //带下划线的为私有属性，对子类不可见
  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    //保存profile变更
    Global.saveProfile();//保存profile
    super.notifyListeners();//通知依赖的widget更新
  }
}
//用户信息
class UserModel extends ProfileChangeNotifier {
  User get user => _profile.user;
  bool get isLogin => user != null;
  set user(User user) {
    //用户登录名不相等,?.运算符在user为空的时候跳过，避免出错。
    if (user?.login != _profile.user?.login) {
      //设置上一次登录的用户名
      _profile.lastLogin = _profile.user?.login;
      //当前登录
      _profile.user = user;
      notifyListeners();
    }
  }
}

//app主题状态
class ThemeModel extends ProfileChangeNotifier {
  //获取当前主题,firstWhere首先从列表中查找有没有满足条件的item,没有找到，会判断有没有传入第二个参数，有的华，执行第二个参数
  ColorSwatch get theme => Global.themes.firstWhere((e){
    print('e.value = ${e.value}');
    return e.value == _profile.theme;
  }, orElse: (){
    return Colors.blue;
  });

  set theme(ColorSwatch color) {
    if(color != theme) {
      //500是MaterialColor的默认索引，50,100,200...900,数值越大颜色越深
      _profile.theme = color[500].value;
      notifyListeners();
    }
  }
}
//app 语言状态,
class LocaleModel extends ProfileChangeNotifier {
  // 获取当前用户的APP语言配置Locale类，如果为null，则语言跟随系统语言
  Locale getLocale() {
    if (_profile.locale == null) return null;
    var t = _profile.locale.split("_");
    return Locale(t[0], t[1]);
  }

  // 获取当前Locale的字符串表示
  String get locale => _profile.locale;

  // 用户改变APP语言后，通知依赖项更新，新语言会立即生效
  set locale(String locale) {
    if (locale != _profile.locale) {
      _profile.locale = locale;
      notifyListeners();
    }
  }
}



