import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/services/secure_storage.dart';
import 'package:green_thumb_mobile/business_logic/models/space_class.dart';
import 'package:green_thumb_mobile/screens/user_profile/components/invitation_card.dart';

class ListInvitations extends StatefulWidget {
  const ListInvitations({Key? key}) : super(key: key);

  @override
  _ListInvitationsState createState() => _ListInvitationsState();
}

class _ListInvitationsState extends State<ListInvitations> {
  late Future<List<SpaceCardContent>> invitationsList;

  @override
  void initState() {
    invitationsList = _fetchInvitations();
    super.initState();
  }

  Future<List<SpaceCardContent>> _fetchInvitations() async {
    final response =
        await Session.get(Uri.http(Session.SERVER_IP, '/getUserInvites'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse
          .map((data) => SpaceCardContent.fromJson(data))
          .toList();
    } else {
      throw Exception(
          'Ошибка ${response.statusCode} при получении приглашений');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: invitationsList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<SpaceCardContent> invitations =
                snapshot.data as List<SpaceCardContent>;

            return invitations.isEmpty
                ? const Center(child: Text("Пока приглашений нет!"))
                : ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    itemCount: invitations.length,
                    itemBuilder: (BuildContext context, int index) {

                      void removeInvitationFromList(int idInvitation) {
                        setState(() {
                          invitations.removeWhere(
                                  (element) => element.id == idInvitation);
                        });
                      }

                      return InvitationCard(
                        invitedSpace: invitations[index],
                        removeInvitation: removeInvitationFromList,
                      );
                    });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );
  }
}
