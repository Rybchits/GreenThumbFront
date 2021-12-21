import 'package:flutter/cupertino.dart';
import 'package:green_thumb_mobile/domain/entities/space_class.dart';
import 'package:green_thumb_mobile/screens/spaces_list/components/space_card.dart';

class SpaceListComponent extends StatelessWidget{
  final List<SpaceCardInfo> spaces;
  final void Function(SpaceCardInfo currentSpace)? longPressUpOnCard;
  final void Function(SpaceCardInfo currentSpace)? pressOnCard;

  const SpaceListComponent({Key? key, required this.spaces, this.longPressUpOnCard, this.pressOnCard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: spaces.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onLongPressUp: () {
                longPressUpOnCard == null? null : longPressUpOnCard!(spaces[index]);
              },
              onTap: () {
                pressOnCard == null? null : pressOnCard!(spaces[index]);
              },
              child: SpaceCard(currentSpace: spaces[index]));
        });
  }

}