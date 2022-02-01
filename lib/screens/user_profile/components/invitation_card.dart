import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/domain/entities/space_class.dart';
import 'package:green_thumb_mobile/domain/repositories/spaces_store.dart';
import 'package:green_thumb_mobile/domain/repositories/user_store.dart';
import 'package:provider/provider.dart';

class InvitationCard extends StatelessWidget {
  final SpaceDetails invitedSpace;
  final void Function(int index) removeInvitation;

  const InvitationCard({Key? key, required this.invitedSpace, required this.removeInvitation}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future<void> _rejectInvitation() async {
      Provider.of<UserStore>(context, listen: false).rejectInviteToSpace(invitedSpace.id)
          .then((value) {
            removeInvitation(invitedSpace.id);
            Provider.of<SpacesStore>(context, listen: false).fetchSpaces();})
          .onError((error, stackTrace) {
            log(error.toString());
          });
    }

    Future<void> _acceptInvitation() async {
      Provider.of<UserStore>(context, listen: false).acceptInviteToSpace(invitedSpace.id)
          .then((value) => removeInvitation(invitedSpace.id))
          .onError((error, stackTrace) {
        log(error.toString());
      });
    }

    return Card(
        elevation: 1,
        child: ListTile(
            title: Text(
              invitedSpace.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
            subtitle: Text('Приглашение от ${invitedSpace.creator.name}'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              IconButton(
                  onPressed: _rejectInvitation, icon: const Icon(Icons.cancel_outlined, color: Colors.red, size: 35)),
              IconButton(
                  onPressed: _acceptInvitation,
                  icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 35))
            ])));
  }
}
