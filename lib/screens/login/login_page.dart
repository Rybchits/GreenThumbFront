import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/app_theme.dart';

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
    _passwordFocusNode.addListener(_onOnFocusNodeEvent);
    _emailFocusNode.addListener(_onOnFocusNodeEvent);
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
            borderSide: BorderSide(color: Theme.of(context).primaryColorDark, width: 2)
        ),
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
            borderSide: BorderSide(color: Theme.of(context).primaryColorDark, width: 2)
        ),
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
        onPressed: () {
          print(_passwordController.text);
        },
        child: const Text("ВОЙТИ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white)),
      ),
    );

    final signUpLink = InkWell(
      child: Text('Нет аккаунта? Зарегистрируйтесь!',
          style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColorDark)),
      onTap: () => { Navigator.pushNamed(context, '/registration') },
    );

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 0),
          decoration:
              const BoxDecoration(
                  gradient: AppTheme.backgroundGradient
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
    );
  }
}
