import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:green_thumb_mobile/domain/entities/space_class.dart';
import 'package:green_thumb_mobile/domain/repositories/user_store.dart';
import 'package:green_thumb_mobile/screens/user_profile/components/invitation_card.dart';

class ListInvitations extends StatefulWidget {
  const ListInvitations({Key? key}) : super(key: key);

  @override
  _ListInvitationsState createState() => _ListInvitationsState();
}

class _ListInvitationsState extends State<ListInvitations> {
  late Future<List<SpaceDetails>> invitationsList;

  @override
  void initState() {
    invitationsList = Provider.of<UserStore>(context, listen: false).getInvitesCurrentUser();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: invitationsList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var invitations = snapshot.data as List<SpaceDetails>;

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
                          invitations.removeWhere((element) => element.id == idInvitation);
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
