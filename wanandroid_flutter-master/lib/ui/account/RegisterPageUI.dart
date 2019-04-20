import 'package:flutter/material.dart';
import '../../api/common_service.dart';
import '../../model/UserModel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPageUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageUIState();
  }
}

class RegisterPageUIState extends State<RegisterPageUI> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _psdController = TextEditingController();
  TextEditingController _psdAgainController = TextEditingController();

  Future<Null> _register() async {
    String username = _userNameController.text;
    String password = _psdController.text;
    String passwordAgain = _psdAgainController.text;
    if (password != passwordAgain) {
      Fluttertoast.showToast(msg: "两次密码输入不一致！");
    } else {
      CommonService().register((UserModel _userModel) {
        if (_userModel != null) {
          if (_userModel.errorCode == 0) {
            Fluttertoast.showToast(msg: "注册成功！");
            Navigator.of(context).pop();
          } else {
            Fluttertoast.showToast(msg: _userModel.errorMsg);
          }
        }
      }, username, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.4,
          title: Text("注册"),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "注册用户",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "用户注册后可使用收藏文章等众多功能！",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                TextField(
                  autofocus: true,
                  controller: _userNameController,
                  decoration: InputDecoration(
                    labelText: "用户名",
                    hintText: "请输入用户名或邮箱",
                    labelStyle: TextStyle(color: Colors.blue),
                    prefixIcon: Icon(Icons.person),
                  ),
                  maxLines: 1,
                ),
                TextField(
                  controller: _psdController,
                  decoration: InputDecoration(
                      labelText: "密码",
                      labelStyle: TextStyle(color: Colors.blue),
                      hintText: "请输入密码",
                      prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  maxLines: 1,
                ),
                TextField(
                  controller: _psdAgainController,
                  decoration: InputDecoration(
                      labelText: "再次输入密码",
                      labelStyle: TextStyle(color: Colors.blue),
                      hintText: "请再次输入密码",
                      prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  maxLines: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.all(16.0),
                          elevation: 0.5,
                          child: Text("注册"),
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () {
                            _register();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
