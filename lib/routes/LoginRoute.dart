import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/index.dart';
import '../common/global.dart';
import '../i10n/GmLocalizations.dart';
import 'package:flukit/flukit.dart';
import '../common/Network.dart';
import 'package:provider/provider.dart';
import '../states/ProfileChangeNotifier.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  bool pwdShow = false; //密码是否显示明文
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  @override
  void initState() {
    // 自动填充上次登录的用户名，填充后将焦点定位到密码输入框
    _unameController.text = Global.profile.lastLogin;
    if (_unameController.text.length > 0) {
      _nameAutoFocus = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("22__$_nameAutoFocus");
    var gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(gm.login)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: <Widget>[
            Form(
              key: _formKey,
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  TextFormField(
                      autofocus: _nameAutoFocus,
                      controller: _unameController,
                      decoration: InputDecoration(
                        labelText: gm.userName,
                        hintText: gm.userNameOrEmail,
                        prefixIcon: Icon(Icons.person),
                      ),
                      // 校验用户名（不能为空）
                      validator: (v) {
                        return v.trim().isNotEmpty ? null : gm.userNameRequired;
                      }),
                  TextFormField(
                    controller: _pwdController,
                    autofocus: !_nameAutoFocus,
                    decoration: InputDecoration(
                        labelText: gm.password,
                        hintText: gm.password,
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                              pwdShow ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              pwdShow = !pwdShow;
                            });
                          },
                        )),
                    obscureText: !pwdShow,
                    //校验密码（不能为空）
                    validator: (v) {
                      return v.trim().isNotEmpty ? null : gm.passwordRequired;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: ConstrainedBox(
                      constraints: BoxConstraints.expand(height: 55.0),
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: _onLogin,
                        textColor: Colors.white,
                        child: Text(gm.login),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GradientCircularProgressIndicator(
              radius: 10,
              colors: [Colors.red,Colors.green,Colors.yellow],
            )
          ],
        ),
      ),
    );
  }

  void _onLogin() async {
    // 提交前，先验证各个表单字段是否合法
    if ((_formKey.currentState as FormState).validate()) {
      _showLoadingDialog();
      User user;
      try {
        user = await Network(context).login(_unameController.text, _pwdController.text);
        // 因为登录页返回后，首页会build，所以我们传false，更新user后不触发更新
        Provider.of<UserModel>(context, listen: false).user = user;
      } catch (e) {
        print('error = ${e.runtimeType}');
        //登录失败则提示
        if (e.response?.statusCode == 401) {
          print('11111111111');
          print('response = ${e.response}');
          Fluttertoast.showToast(msg: GmLocalizations.of(context).userNameOrPasswordWrong,timeInSecForIos: 2,gravity: ToastGravity.CENTER);
        } else {
          print('222222222222');
          print('error ${e.toString()}');
          Fluttertoast.showToast(msg: e.toString(),timeInSecForIos: 2);
        }
      } finally {
        print('3333333333');
        // 隐藏loading框
        Navigator.of(context).pop();
      }
      if (user != null) {
        // 返回
        Navigator.of(context).pop();
      }
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, //点击遮罩不关闭对话框
      builder: (context) {
        return UnconstrainedBox(
          constrainedAxis: Axis.vertical,
          child: SizedBox(
            width: 280,
            child: AlertDialog(
              backgroundColor: Color.fromARGB(0, 0, 0, 0),
              elevation:0,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AnimatedRotationBox(
                    duration: Duration(milliseconds: 800),
                    child: GradientCircularProgressIndicator(
                      radius: 15.0,
                      colors: [Colors.blue, Colors.lightBlue[50]],
                      value: .8,
                      backgroundColor: Colors.transparent,
                      strokeCapRound: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}