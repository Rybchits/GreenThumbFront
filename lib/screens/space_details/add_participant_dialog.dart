import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/lib/session.dart';

Future<void> displayTextInputDialog(BuildContext context, int spaceId) async {

  var _textFieldController = TextEditingController();

  Future<int> _requestForInviteUser(String email, int spaceId) async{

    final response = await Session.post(Uri.http(Session.SERVER_IP, '/inviteInSpaceByEmail'),
        json.encode({'spaceId': spaceId, 'email': email}));

    return response.statusCode;
  }

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Добавить участника...'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "Email нового участника..."),

          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отменить', style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Добавить', style: TextStyle(color: Colors.green),),
              onPressed: () {
                _requestForInviteUser(_textFieldController.text, spaceId)
                    .then((value){
                      if (value == 200) {
                        Navigator.pop(context);
                      }
                });
              },
            ),
          ],
        );
      });
}