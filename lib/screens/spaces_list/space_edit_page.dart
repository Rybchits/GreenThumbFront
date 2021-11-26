import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:green_thumb_mobile/lib/session.dart';
import 'image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class SpaceEditPage extends StatefulWidget {
  const SpaceEditPage({Key? key}) : super(key: key);

  @override
  _SpaceEditPageState createState() => _SpaceEditPageState();
}

class _SpaceEditPageState extends State<SpaceEditPage> {
  final _notificationTimeController = TextEditingController();
  final _nameController = TextEditingController();
  final _notificationTimeFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _tagsFocusNode = FocusNode();
  var _selectedTime = const TimeOfDay(hour: 0, minute: 0);
  File? _image;
  List<String> tags = [];

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(_onFocusNodeEvent);
    _notificationTimeFocusNode.addListener(_onFocusNodeEvent);
    _tagsFocusNode.addListener(_onFocusNodeEvent);
  }

  @override
  void dispose() {
    _notificationTimeController.dispose();
    _nameController.dispose();
    _notificationTimeFocusNode.dispose();
    _nameFocusNode.dispose();
    _tagsFocusNode.dispose();
    super.dispose();
  }

  _onFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _notificationTimeController.text = "${picked.hour}:${picked.minute}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<int> createSpace(
        String name, String time, String image64, String ex, String tags) async {
      var res = await Session.post( Uri.http(Session.SERVER_IP, '/createSpace', {'spaceName': name}),
          jsonEncode({
            'spaceName': name,
            'notificationTime': time,
            'tags': tags,
            'image': {'data': image64, 'extension': ex}
          }));
      return res.statusCode;
    }

    String formatTimeOfDay(TimeOfDay tod) {
      final now = new DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
      return dt.toIso8601String();
    }

    Future<void> onCreateButtonClick() async {
      var name = _nameController.text;
      var time = formatTimeOfDay(_selectedTime);
      String img64 = "";
      var ex = p.extension(_image?.path ?? "");
      if (_image != null) {
        final bytes = _image!.readAsBytesSync();
        img64 = base64Encode(bytes);
      }

      var res = await createSpace(name, time, img64, ex, tags.join(','));
      print(tags.join(','));
      if (res == 200) {
        print('created');

        Navigator.pop(context);
      } else {
        print('error. Code: $res');
      }
    }

    void setImage(File file) {
      setState(() {
        _image = file;
      });
    }

    final notificationTimeField = InkWell(
        onTap: () {
          _selectTime(context);
        },
        child: TextFormField(
          obscureText: false,
          enabled: false,
          focusNode: _notificationTimeFocusNode,
          style: const TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
          decoration: InputDecoration(
            labelText: 'Время прихода уведомлений',
            labelStyle: TextStyle(
                color: _notificationTimeFocusNode.hasFocus
                    ? Theme.of(context).primaryColorDark
                    : const Color.fromRGBO(0, 0, 0, 60)),
            contentPadding: const EdgeInsets.fromLTRB(20.0, 12.0, 12.0, 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(color: Color(0xff979797)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(color: Color(0xff979797)),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColorDark, width: 2)),
          ),
          controller: _notificationTimeController,
        ));

    final nameField = TextFormField(
      obscureText: false,
      focusNode: _nameFocusNode,
      style: const TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
      decoration: InputDecoration(
        hintText: 'Название пространства...',
        hintStyle: TextStyle(
            color: _nameFocusNode.hasFocus
                ? const Color(0xffA9B2AA)
                : const Color.fromRGBO(0, 0, 0, 60)),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffA9B2AA)),
        ),
      ),
      controller: _nameController,
    );

    final tagsField = ChipsInput(
      initialValue: const <String>[],
      focusNode: _tagsFocusNode,
      decoration: InputDecoration(
        labelText: "Теги пространства",
        labelStyle: TextStyle(
            color: _tagsFocusNode.hasFocus
                ? Theme.of(context).primaryColorDark
                : const Color.fromRGBO(0, 0, 0, 60)),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: Color(0xff979797)),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).primaryColorDark, width: 2)),
      ),
      onChanged: (List<String> data) {
        tags = data;
      },
      chipBuilder: (context, state, dynamic value) {
        return InputChip(
          key: ObjectKey(value),
          label: Text(value),
          onDeleted: () => state.deleteChip(value),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      },
        suggestionBuilder: (context, dynamic state, dynamic value) {
          return ListTile(
            key: ObjectKey(value),
            title: Text(value),
            subtitle: Text(value),
          );
        },
      findSuggestions: (String query) {
        if (query.isNotEmpty) {
          var lowercaseQuery = query.toLowerCase();
          return [query].where((value) {
            return value.toLowerCase().contains(lowercaseQuery) ||
                value.toLowerCase().contains(lowercaseQuery);
          }).toList(growable: false);
        } else {
          return [query];
        }
      }
    );

    final createButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(4.0),
      color: Theme.of(context).primaryColorLight,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        onPressed: onCreateButtonClick,
        child: const Text("СОЗДАТЬ ПРОСТРАНСТВО",
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
                  child: Row(
                    children: [
                      Expanded(
                        child: ImageFromGalleryEx(setImage: setImage),
                        flex: 6,
                      ),
                      const Expanded(child: SizedBox(), flex: 1),
                      Expanded(child: nameField, flex: 11)
                    ],
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                ),
                Container(
                    child: notificationTimeField,
                    height: 56,
                    margin: const EdgeInsets.only(bottom: 16)),
                Container(
                    child: tagsField,
                    margin: const EdgeInsets.only(bottom: 16)),
                Container(
                    child: createButton,
                    height: 36,
                    margin: const EdgeInsets.only(bottom: 5)),
              ],
            )));
  }
}
