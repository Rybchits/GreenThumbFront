import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/models/plant_class.dart';
import 'package:intl/intl.dart';

class PlantCard extends StatelessWidget {
  final Plant currentPlant;
  final bool isSelected;
  final void Function(int index, bool? newValue) setIsSelectThisPlant;

  const PlantCard(
      {Key? key,
      required this.currentPlant,
      required this.isSelected,
      required this.setIsSelectThisPlant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 115,
        child: Card(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Transform.scale(
                      child: Checkbox(
                          value: isSelected,
                          shape: const CircleBorder(),
                          onChanged: (newValue) => {
                                setIsSelectThisPlant(currentPlant.id, newValue)
                              },
                          activeColor: Theme.of(context).primaryColor
                      ),
                      scale: 1.4),
                  flex: 3),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              currentPlant.name.length < 19? currentPlant.name
                                  : currentPlant.name.substring(0, 15) + "...",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            Text("Группа цветов: " +
                                (currentPlant.group.isNotEmpty? currentPlant.group : "не указана"),
                                style: const TextStyle(fontSize: 14)
                            ),

                            Text("Следующий полив: " + DateFormat('dd.MM.yyyy')
                                    .format(currentPlant.dateOfNextWatering!),
                              style: const TextStyle(fontSize: 14),
                            )
                          ])),
                  flex: 14),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(5),
                    alignment: Alignment.center,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/PlantDefault.png",
                            image: currentPlant.urlImage ?? '',
                            imageErrorBuilder: (context, error, stackTrace) =>
                                Image.asset("assets/images/PlantDefault.png"),
                        ))),
                flex: 7,
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ));
  }
}
