import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/components/avatar.dart';
import 'package:green_thumb_mobile/models/space_class.dart';

import '../../app_theme.dart';

class SpaceCard extends StatelessWidget {
  final SpaceCardInfo currentSpace;

  const SpaceCard({Key? key, required this.currentSpace}) : super(key: key);

  Widget _buildChip(String label) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      label: Text(
        label,
        style: const TextStyle(color: AppTheme.chipsColor, fontSize: 12),
      ),
      backgroundColor: AppTheme.chipsBackgroundColor,
      elevation: 3.0,
      shadowColor: Colors.grey[60],
      padding: const EdgeInsets.all(1),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppTheme.chipsColor, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 135,
        child: Card(
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: <Widget>[
                const Expanded(child: SizedBox(), flex: 1),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                      currentSpace.name.length < 18
                                          ? currentSpace.name
                                          : currentSpace.name.substring(0, 15) +
                                              '...',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    child: UserAvatar(
                                        'https://sun9-48.userapi.com/impf/fmm-Q1ZA22IAdubGy31cFfz3h0CNwq1CP0Gs5w/v5DFeC3CLms.jpg?size=1619x2021&quality=96&sign=3a0a859c5727c9517cc8186d3266b822&type=album',
                                        'small'),
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
                                              style: TextStyle(
                                                  color: Color(0xffBDBEC9),
                                                  fontSize: 14)))
                                      : Wrap(
                                          spacing: 6.0,
                                          runSpacing: 6.0,
                                          children: currentSpace.tags
                                              .map((e) => _buildChip(e))
                                              .toList())),
                              Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: currentSpace.numberPlants == 0
                                      ? const Text("Растения не указаны...")
                                      : Row(children: <Widget>[
                                          Text(
                                              "Число растений: ${currentSpace.numberPlants}"),
                                          const SizedBox(width: 5),
                                          const Image(
                                            image: AssetImage(
                                                'assets/images/Leafs.jpg'),
                                            width: 18,
                                            height: 18,
                                          )
                                        ]))
                            ])),
                    flex: 14),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: FadeInImage.assetNetwork(
                                placeholder: "assets/images/VstuLogo.jpg",
                                image:
                                    "https://www.province.ru/media/k2/items/cache/2d565dcc1792c919daba23b9424013fe_Generic.jpg")),
                      ],
                    ),
                    flex: 6),
                const Expanded(child: SizedBox(), flex: 1),
              ],
            )
        )
    );
  }
}
