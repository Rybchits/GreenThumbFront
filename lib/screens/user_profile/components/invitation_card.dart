import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/services/secure_storage.dart';
import 'package:green_thumb_mobile/business_logic/models/space_class.dart';

class InvitationCard extends StatelessWidget {
  final SpaceCardContent invitedSpace;
  final void Function(int index) removeInvitation;

  const InvitationCard({Key? key, required this.invitedSpace,
    required this.removeInvitation}) : super(key: key);

  Future<void> _rejectInvitation() async {

    final response = await Session.post(Uri.http(Session.SERVER_IP, '/rejectInviteToSpace',
        {'spaceId': invitedSpace.id.toString()}), jsonEncode({}));

    if (response.statusCode == 200) {
      removeInvitation(invitedSpace.id);
    }
  }

  Future<void> _acceptInvitation() async {

    final response = await Session.post(Uri.http(Session.SERVER_IP, '/acceptInviteToSpace',
        {'spaceId': invitedSpace.id.toString()}), jsonEncode({}));

    if (response.statusCode == 200) {
      removeInvitation(invitedSpace.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
        child: ListTile(
            title: Text(invitedSpace.name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
            subtitle: Text('Приглашение от ${invitedSpace.creator.name}'),
          trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                    onPressed: _rejectInvitation,
                    icon: const Icon(Icons.cancel_outlined, color: Colors.red, size: 35)),
                IconButton(onPressed: _acceptInvitation,
                    icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 35))
            ])
        )
    );
  }
}