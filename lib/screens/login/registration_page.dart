import 'package:flutter/material.dart';

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

    TextFormField InputField(String label, TextEditingController controller, FocusNode focus){
      return TextFormField(
        obscureText: false,
        focusNode: focus,
        style: const TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: focus.hasFocus
                  ? const Color(0xff427664)
                  : const Color.fromRGBO(0, 0, 0, 60)),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(color: Color(0xff979797)),
          ),

          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff427664), width: 2)
          ),
        ),
        controller: controller,
      );
    }

    final signInLink = InkWell(
      child: const Text('Уже есть аккаунт? Войдите в него!',
          style: TextStyle(fontSize: 14, color: Color(0xff427664))),
      onTap: () => { Navigator.pushNamed(context, '/login') },
    );

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: InputField("ФИО", _fullNameController, _fullNameFocusNode),
                  height: 56,
                  margin: const EdgeInsets.only(bottom: 18)),
              Container(
                  child: InputField('Электронная почта', _emailController, _emailFocusNode),
                  height: 56,
                  margin: const EdgeInsets.only(bottom: 18)),
              Container(
                  child: InputField("Пароль", _passwordController, _passwordFocusNode),
                  height: 56,
                  margin: const EdgeInsets.only(bottom: 18)),
              Container(
                  child: InputField("Повторите пароль", _passwordRepeatController, _passwordRepeatFocusNode),
                  height: 56,
                  margin: const EdgeInsets.only(bottom: 18)),
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
