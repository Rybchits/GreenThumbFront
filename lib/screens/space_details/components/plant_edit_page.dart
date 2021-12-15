import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/services/secure_storage.dart';
import 'package:green_thumb_mobile/business_logic/models/plant_class.dart';
import 'package:green_thumb_mobile/ui_components/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:number_inc_dec/number_inc_dec.dart';

class PlantAddPage extends StatefulWidget {
  const PlantAddPage({Key? key, required this.spaceId, this.editingPlant}) : super(key: key);

  final int spaceId;
  final Plant? editingPlant;

  @override
  _PlantAddPageState createState() => _PlantAddPageState();
}

class _PlantAddPageState extends State<PlantAddPage> {
  final _namePlantController = TextEditingController();
  final _groupPlantController = TextEditingController();
  final _wateringPeriodController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _groupFocusNode = FocusNode();
  File? _imagePlant;

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(_onFocusNodeEvent);
    _groupFocusNode.addListener(_onFocusNodeEvent);

    // Todo убрать...
    _namePlantController.text = widget.editingPlant?.name ?? '';
    _groupPlantController.text = widget.editingPlant?.group ?? '';
    _wateringPeriodController.text = widget.editingPlant?.wateringPeriodDays.toString() ?? '';
  }

  _onFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  @override
  Widget build(BuildContext context) {

    Future<int> createPlant(
        String name, String group, int wateringPeriod, dynamic image64) async {
      var res = await Session.post(
          Uri.http(
              Session.SERVER_IP,
              widget.editingPlant != null ? '/editPlant' : '/createPlant',
              {'plantId': widget.editingPlant?.id.toString()}),
          jsonEncode({
            'spaceId': widget.spaceId,
            'plantId': widget.editingPlant?.id,
            'plantName': name,
            'wateringPeriodDays': wateringPeriod,
            'nextWateringDate': DateTime.now().toIso8601String(),
            'group': group,
            'image': image64
          }));
      return res.statusCode;
    }

    Future<void> onCreateButtonClick() async {
      var name = _namePlantController.text;
      var group = _groupPlantController.text;
      var wateringPeriod = int.parse(_wateringPeriodController.text);

      dynamic img;
      var ex = p.extension(_imagePlant?.path ?? "");
      if (_imagePlant != null) {
        final bytes = _imagePlant!.readAsBytesSync();
        final img64 = base64Encode(bytes);
        img = {'data': img64, 'extension': ex};
      }

      var res = await createPlant(name, group, wateringPeriod, img);

      if (res == 200) {
        print('created');

        Navigator.pop(context);
      } else {
        print('error. Code: $res');
      }
    }

    final nameField = TextFormField(
      obscureText: false,
      focusNode: _nameFocusNode,
      style: const TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
      decoration: InputDecoration(
        hintText: 'Название растения...',
        hintStyle: TextStyle(
            color: _nameFocusNode.hasFocus
                ? const Color(0xffA9B2AA)
                : const Color.fromRGBO(0, 0, 0, 60)),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffA9B2AA)),
        ),
      ),
      controller: _namePlantController,
    );

    final groupField = TextFormField(
      obscureText: false,
      focusNode: _groupFocusNode,
      style: const TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
      decoration: InputDecoration(
        hintText: 'Группа растения...',
        hintStyle: TextStyle(
            color: _groupFocusNode.hasFocus
                ? const Color(0xffA9B2AA)
                : const Color.fromRGBO(0, 0, 0, 60)),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: Color(0xff979797)),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).primaryColorDark, width: 2)),
      ),
      controller: _groupPlantController,
    );

    final wateringPeriodField = NumberInputWithIncrementDecrement(
      controller: _wateringPeriodController,
      min: 1,
      max: 31,
    );

    final createButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(4.0),
      color: Theme.of(context).primaryColorLight,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        onPressed: onCreateButtonClick,
        child: Text(widget.editingPlant != null ? "РЕДАКТИРОВАТЬ РАСТЕНИЕ" : "СОЗДАТЬ РАСТЕНИЕ",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.white)),
      ),
    );

    void setImage(File file) {
      setState(() {
        _imagePlant = file;
      });
    }

    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
            margin: const EdgeInsets.all(25),
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 80,
                  child: Row(children: [
                    Expanded(
                      child: ImageFromGalleryEx(setImage: setImage, initialImageUrl: widget.editingPlant?.urlImage),
                      flex: 6,
                    ),
                    const Expanded(child: SizedBox(), flex: 1),
                    Expanded(child: nameField, flex: 11)
                  ], crossAxisAlignment: CrossAxisAlignment.stretch,),
                  margin: const EdgeInsets.only(bottom: 16),
                ),
                Container(
                    child: groupField,
                    height: 56,
                    margin: const EdgeInsets.only(bottom: 16)),
                Container(
                    child: wateringPeriodField,
                    height: 56,
                    margin: const EdgeInsets.only(bottom: 16)),
                Container(
                    child: createButton,
                    height: 36,
                    margin: const EdgeInsets.only(bottom: 5)),
              ],
            )));
  }

}