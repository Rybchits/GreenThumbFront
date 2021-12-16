import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/app_theme.dart';
import 'package:green_thumb_mobile/ui_components/title.dart';
import 'package:green_thumb_mobile/business_logic/stores/user_store.dart';
import 'package:provider/provider.dart';
import 'package:green_thumb_mobile/services/secure_storage.dart';

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

  // Авторизация пользователя данные о котором записаны в секретном хранилище
  Future<void> auth() async {
    late String email;
    late String password;

    await Future.wait([
      UserIdentifyingData.getEmail().then((value) => email = value ?? ''),
      UserIdentifyingData.getPassword().then((value) => password = value ?? '')
    ]);

    var res = await Session.post(Uri.http(Session.SERVER_IP, '/auth'),
        jsonEncode(<String, String>{'email': email, 'password': password}));


    if(res.statusCode == 200){
      print('User authorized');

      await Provider.of<UserStore>(context, listen: false).fetchUser(email)
          .then((_) => Navigator.pushNamed(context, '/spaces'))
          .catchError((e) => print(e));
    }
    else {
      print("not authorized. Code: ${res.statusCode} Headers: ${res.request?.headers}");
    }
  }


  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(_onFocusNodeEvent);
    _emailFocusNode.addListener(_onFocusNodeEvent);
    auth();
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
    var email = _emailController.text;
    var password = _passwordController.text;
    await UserIdentifyingData.setUserIdentifyingData(email, password);
    auth();
  }

  // Обработчик нажатия на ссылку регистрации
  Future<void> onSignUpLinkClick() async {
    Navigator.popAndPushNamed(context, '/registration');
  }

  // Переключить значение видимости пароля
  void switchPasswordVisible(){
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
            style: TextStyle(fontSize: 14, color: Colors.white)),
      ),
    );

    final signUpLink = InkWell(
      child: Text('Нет аккаунта? Зарегистрируйтесь!',
          style: TextStyle(
              fontSize: 14, color: Theme.of(context).primaryColorDark)),
      onTap: () => onSignUpLinkClick,
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
        )
    );
  }
}
