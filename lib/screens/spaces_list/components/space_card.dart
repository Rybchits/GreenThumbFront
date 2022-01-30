import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/domain/view_models/space_card_info.dart';
import 'package:green_thumb_mobile/ui_components/avatar.dart';
import 'package:green_thumb_mobile/ui_components/chips_list.dart';

class SpaceCard extends StatelessWidget {
  final SpaceCardInfo currentSpace;

  const SpaceCard({Key? key, required this.currentSpace}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 135,
        child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Text(currentSpace.name,
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                          maxLines: 1,
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    child: UserAvatar(currentSpace.creator, 'small'),
                                    height: 28,
                                    width: 28,
                                  )
                                ],
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: currentSpace.tags.isEmpty
                                      ? Container(
                                          height: 35,
                                          alignment: Alignment.centerLeft,
                                          child: const Text("Теги не указаны",
                                              style: TextStyle(color: Color(0xffBDBEC9), fontSize: 14)))
                                      : ChipsList(stringList: currentSpace.tags)),
                              Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: currentSpace.numberPlants == 0
                                      ? const Text("Растения не указаны...")
                                      : Row(children: <Widget>[
                                          Text("Число растений: ${currentSpace.numberPlants}"),
                                          const SizedBox(width: 5),
                                          const Image(
                                            image: AssetImage('assets/images/Leafs.jpg'),
                                            width: 18,
                                            height: 18,
                                          )
                                        ]))
                            ])),
                    flex: 8),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      alignment: Alignment.centerRight,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/VstuLogo.jpg",
                            image: currentSpace.imageUrl == null? '' : currentSpace.imageUrl!,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                Image.asset("assets/images/VstuLogo.jpg"),
                          ))),
                  flex: 5,
                ),
              ],
            )));
  }
}
