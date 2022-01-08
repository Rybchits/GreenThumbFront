import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/domain/repositories/spaces_store.dart';
import 'package:provider/provider.dart';
import 'package:green_thumb_mobile/data/dto_models/image_request_model.dart';
import 'package:green_thumb_mobile/data/dto_models/plant_request_model.dart';
import 'package:green_thumb_mobile/domain/entities/plant_class.dart';
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

    Future<void> onActionButtonClick() async {

      var requestModel = PlantRequestModel(
        plantId: widget.editingPlant?.id,
        spaceId: widget.spaceId,
        name: _namePlantController.text,
        group: _groupPlantController.text,
        image: _imagePlant == null? null : ImageRequestModel(
            extension: p.extension(_imagePlant!.path),
            data: base64Encode(_imagePlant!.readAsBytesSync())),
        wateringPeriodDays: int.parse(_wateringPeriodController.text)
      );

      if (widget.editingPlant != null) {
        Provider.of<SpacesStore>(context, listen: false).updatePlantInSpace(requestModel)
            .then((value) => Navigator.pop(context))
            .onError((error, stackTrace) { log(error as String); });
      }
      else {
        Provider.of<SpacesStore>(context, listen: false).createPlantInSpace(requestModel)
            .then((value) => Navigator.pop(context))
            .onError((error, stackTrace) { log(error as String); });
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

    final actionButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(4.0),
      color: Theme.of(context).primaryColorLight,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        onPressed: onActionButtonClick,
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
                    child: actionButton,
                    height: 36,
                    margin: const EdgeInsets.only(bottom: 5)),
              ],
            ),
        ),
    );
  }
}