import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/components/title.dart';
import '../../app_theme.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();
  final _fullNameController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _passwordRepeatFocusNode = FocusNode();
  final _fullNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _passwordRepeatFocusNode.addListener(_onFocusNodeEvent);
    _emailFocusNode.addListener(_onFocusNodeEvent);
    _passwordFocusNode.addListener(_onFocusNodeEvent);
    _fullNameFocusNode.addListener(_onFocusNodeEvent);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordRepeatController.dispose();
    _emailFocusNode.dispose();
    _passwordRepeatFocusNode.dispose();
    _fullNameController.dispose();
    _passwordFocusNode.dispose();
    _fullNameFocusNode.dispose();
    super.dispose();
  }

  _onFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  @override
  Widget build(BuildContext context) {
    // Function for create input field
    TextFormField inputField(String label, TextEditingController controller,
        FocusNode focus, bool isVisible) {
      return TextFormField(
        obscureText: !isVisible,
        focusNode: focus,
        style: const TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: focus.hasFocus
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
        controller: controller,
      );
    }

    final registrationButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(4.0),
      color: Theme.of(context).primaryColorLight,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        onPressed: () {
          print(_passwordRepeatController.text);
        },
        child: const Text("РЕГИСТРАЦИЯ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white)),
      ),
    );

    final signInLink = InkWell(
      child: Text('Уже есть аккаунт? Войдите в него!',
          style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColorDark)),
      onTap: () => { Navigator.pushNamed(context, '/login') },
    );

    return Scaffold(
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
                  margin: const EdgeInsets.only(bottom: 38)),
              Container(
                  child: inputField("ФИО", _fullNameController,
                      _fullNameFocusNode, true),
                  height: 56,
                  margin: const EdgeInsets.only(bottom: 18)),
              Container(
                  child: inputField('Электронная почта', _emailController,
                      _emailFocusNode, true),
                  height: 56,
                  margin: const EdgeInsets.only(bottom: 18)),
              Container(
                  child: inputField("Пароль", _passwordController,
                      _passwordFocusNode, false),
                  height: 56,
                  margin: const EdgeInsets.only(bottom: 18)),
              Container(
                  child: inputField( "Повторите пароль", _passwordRepeatController,
                      _passwordRepeatFocusNode, false),
                  height: 56,
                  margin: const EdgeInsets.only(bottom: 25)),
              Container(
                child: registrationButton,
                height: 36,
                margin: const EdgeInsets.only(bottom: 28),
              ),
              Container(
                child: signInLink,
              )
            ],
          ),
        ),
      ),
    );
  }
}
