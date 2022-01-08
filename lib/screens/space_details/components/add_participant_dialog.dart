import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:green_thumb_mobile/domain/repositories/spaces_store.dart';

Future<void> displayTextInputDialog(BuildContext context, int spaceId) async {
  var _textFieldController = TextEditingController();

  Future<void> _pressOnInviteButton() async{

    Provider.of<SpacesStore>(context, listen: false).inviteUserInSpace(spaceId, _textFieldController.text)
        .then((value) { Navigator.pop(context); })
        .onError((error, stackTrace) { log(error as String); });
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
            TextButton (
              child: const Text('Добавить', style: TextStyle(color: Colors.green),),
              onPressed: _pressOnInviteButton
            ),
          ],
        );
      });
}