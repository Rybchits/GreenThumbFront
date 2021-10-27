import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/app_theme.dart';
import 'package:green_thumb_mobile/components/title.dart';
import 'package:green_thumb_mobile/lib/session.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _passwordVisible = false;

  Future<void> checkAuth() async {
    var res = await Session.post(Uri.parse('${Session.SERVER_IP}/testAuth'), null);
    if(res.statusCode == 200){
      print('authorized');
      Navigator.pushNamed(context, '/spaces');
    }
    else{
      print("not authorized. Code: ${res.statusCode} Headers: ${res.request?.headers}");
    }
  }

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(_onOnFocusNodeEvent);
    _emailFocusNode.addListener(_onOnFocusNodeEvent);
    checkAuth();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }



  @override
  Widget build(BuildContext context) {

    Future<int> attemptSignIn(String email, String password) async {
      var res =
      await Session.post(Uri.parse('${Session.SERVER_IP}/auth'),
          jsonEncode(<String, String>{'email': email, 'password': password}));
      return res.statusCode;
    }

    final emailField = TextFormField(
      obscureText: false,
      focusNode: _emailFocusNode,
      style: const TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
      decoration: InputDecoration(
        labelText: 'Электронная почта',
        labelStyle: TextStyle(
            color: _emailFocusNode.hasFocus
                ? Theme.of(context).primaryColorDark
                : const Color.fromRGBO(0, 0, 0, 60)),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: Color(0xff979797)),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).primaryColorDark, width: 2)),
      ),
      controller: _emailController,
    );

    final passwordField = TextFormField(
      obscureText: !_passwordVisible,
      focusNode: _passwordFocusNode,
      style: const TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
      decoration: InputDecoration(
        labelText: 'Пароль',
        labelStyle: TextStyle(
            color: _passwordFocusNode.hasFocus
                ? Theme.of(context).primaryColorDark
                : const Color.fromRGBO(0, 0, 0, 60)),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: Color(0xff979797)),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).primaryColorDark, width: 2)),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color.fromRGBO(0, 0, 0, 60),
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
      controller: _passwordController,
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(4.0),
      color: Theme.of(context).primaryColorLight,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        onPressed: () async {
          var email = _emailController.text;
          var password = _passwordController.text;

          var res = await attemptSignIn(email, password);

          if (res == 200) {
            print('authorized');
            Navigator.popAndPushNamed(context, '/spaces');
          } else {
            print('not authorized. Code: $res');
          }
        },
        child: const Text("ВОЙТИ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white)),
      ),
    );

    final signUpLink = InkWell(
      child: Text('Нет аккаунта? Зарегистрируйтесь!',
          style: TextStyle(
              fontSize: 14, color: Theme.of(context).primaryColorDark)),
      onTap: () => Navigator.popAndPushNamed(context, '/registration'),
    );

    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 0),
              decoration:
                  const BoxDecoration(gradient: AppTheme.backgroundGradient),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: TitleLogo("medium"),
                      margin: const EdgeInsets.only(bottom: 28)),
                  Container(
                      child: emailField,
                      height: 56,
                      margin: const EdgeInsets.only(bottom: 16)),
                  Container(
                      child: passwordField,
                      height: 56,
                      margin: const EdgeInsets.only(bottom: 35)),
                  Container(
                      child: loginButton,
                      height: 36,
                      margin: const EdgeInsets.only(bottom: 28)),
                  Container(
                    child: signUpLink,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
