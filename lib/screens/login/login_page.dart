import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/app_theme.dart';
import 'package:green_thumb_mobile/ui_components/title.dart';
import 'package:green_thumb_mobile/domain/repositories/user_store.dart';
import 'package:provider/provider.dart';


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

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(_onFocusNodeEvent);
    _emailFocusNode.addListener(_onFocusNodeEvent);

    Provider.of<UserStore>(context, listen: false).fetchUser(null)
        .then((_) => Navigator.pushNamed(context, '/spaces'))
        .onError((error, stackTrace) { log(error.toString()); });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  _onFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  // Обработчик нажатия на кнопку авторизации
  Future<void> onLoginButtonClick() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    Provider.of<UserStore>(context, listen: false).login(email, password)
        .then((_) => Navigator.pushNamed(context, '/spaces'))
        .onError((error, stackTrace) { log(error.toString()); });
  }

  // Обработчик нажатия на ссылку регистрации
  void onSignUpLinkClick() {
    Navigator.popAndPushNamed(context, '/registration');
  }

  // Переключить значение видимости пароля
  void switchPasswordVisible() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            color: _passwordFocusNode.hasFocus? Theme.of(context).primaryColorDark : const Color.fromRGBO(0, 0, 0, 60)),
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
            onPressed: switchPasswordVisible
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
        onPressed: onLoginButtonClick,
        child: const Text("ВОЙТИ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );

    final signUpLink = InkWell(
      child: Text('Нет аккаунта? Зарегистрируйтесь!',
          style: TextStyle(
              fontSize: 14, color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.w600)),
      onTap: onSignUpLinkClick,
    );

    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 0),
              decoration:
              const BoxDecoration(image: AppTheme.backgroundImage),
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
        )
    );
  }
}
