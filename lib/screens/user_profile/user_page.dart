import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/components/avatar.dart';
import 'package:green_thumb_mobile/models/user_class.dart';
import 'package:image_picker/image_picker.dart';


import '../../app_theme.dart';

class UserPage extends StatelessWidget {
  final User currentUser;

  const UserPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final emailForm = TextFormField(
      enabled: false,
      initialValue: currentUser.email,
      style: const TextStyle(
        color: Color(0xff232536),
        fontSize: 18,
      ),
      decoration: const InputDecoration(
        labelText: "Электронная почта",
        labelStyle: TextStyle(
          color: Color(0xffA9B2AA),
          fontSize: 18,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        contentPadding: EdgeInsets.fromLTRB(5.0, 0, 10.0, 10.0),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff7f7f7),
        elevation: 1,
        iconTheme: const IconThemeData(
          color: Colors.black,
          size: 16
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login',
                    (Route<dynamic> route) => false),
          ),
        ],
      ),
        resizeToAvoidBottomInset: false,
        body: Align(
            alignment: Alignment.topCenter,
            child: Container(
                decoration:
                    const BoxDecoration(gradient: AppTheme.backgroundGradient),
                child: Column(children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
                          child: UserAvatar(currentUser.urlAvatar, 'large')),
                  flex: 8,
                  ),
                  Expanded(
                    child: Text(currentUser.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 22)),
                    flex: 2,
                  ),
                  Expanded(

                    child: Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: emailForm
                    ),
                    flex: 2,
                  ),
                  const Expanded(
                    flex: 4,
                    child: SizedBox()
                  )
                ])
            )
        )
    );
  }
}
