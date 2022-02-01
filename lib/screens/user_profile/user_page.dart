import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/ui_components/avatar.dart';
import 'package:green_thumb_mobile/domain/entities/user_class.dart';
import 'package:green_thumb_mobile/screens/user_profile/components/list_invitations.dart';
import 'package:green_thumb_mobile/domain/repositories/user_store.dart';
import 'package:green_thumb_mobile/ui_components/named_icon.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onLogoutButtonClick() {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
      Provider.of<UserStore>(context, listen: false).logout();
    }

    final User currentUser = Provider.of<UserStore>(context).user ?? User(nameUser: ' ');

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

    void showInvitations() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (_) => Container(
              margin: const EdgeInsets.all(5),
              padding: MediaQuery.of(context).viewInsets,
              child: const ListInvitations()));
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xfff7f7f7),
          elevation: 1,
          iconTheme: const IconThemeData(color: Colors.black, size: 16),
          actions: <Widget>[
            NamedIcon(iconData: Icons.email, notificationCount: 0, onTap: showInvitations),
            IconButton(icon: const Icon(Icons.logout), onPressed: () => {onLogoutButtonClick()}),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: Align(
            alignment: Alignment.topCenter,
            child: Container(
                decoration: const BoxDecoration(image: AppTheme.backgroundImage),
                child: Column(children: [
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
                        child: UserAvatar(currentUser, 'large')),
                    flex: 6,
                  ),
                  Expanded(
                    child: Text(currentUser.name,
                        textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
                    flex: 1,
                  ),
                  Expanded(
                      child: Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: emailForm),
                      flex: 5)
                ]))));
  }
}
