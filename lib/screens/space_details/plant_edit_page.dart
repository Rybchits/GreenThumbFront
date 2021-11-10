import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/screens/spaces_list/image_picker.dart';

class PlantAddPage extends StatefulWidget {
  const PlantAddPage({Key? key}) : super(key: key);

  @override
  _PlantAddPageState createState() => _PlantAddPageState();
}

class _PlantAddPageState extends State<PlantAddPage> {
  final _namePlantController = TextEditingController();
  final _groupPlantController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _groupFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(_onFocusNodeEvent);
    _groupFocusNode.addListener(_onFocusNodeEvent);
  }

  _onFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  @override
  Widget build(BuildContext context) {

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

    final createButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(4.0),
      color: Theme.of(context).primaryColorLight,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        onPressed: () => { Navigator.pop(context) },
        child: const Text("СОЗДАТЬ РАСТЕНИЕ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white)),
      ),
    );


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
                    const Expanded(
                      child: ImageFromGalleryEx(),
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
                    child: createButton,
                    height: 36,
                    margin: const EdgeInsets.only(bottom: 5)),
              ],
            )));
  }

}