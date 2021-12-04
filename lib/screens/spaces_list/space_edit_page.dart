import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:green_thumb_mobile/lib/session.dart';
import 'package:green_thumb_mobile/models/space_class.dart';
import 'image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class SpaceEditPage extends StatefulWidget {
  final SpaceCardInfo? editingSpace;

  const SpaceEditPage({Key? key, this.editingSpace}) : super(key: key);

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
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.editingSpace?.name ?? '';
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
    
    Future<void> createSpace(
        String name, String time, String image64, String ex) async {
      var res = await Session.post( Uri.http(Session.SERVER_IP, '/createSpace', {'spaceName': name}),
          jsonEncode({
            'spaceName': name,
            'notificationTime': time,
            'image': {'data': image64, 'extension': ex}
          }));

      if (res.statusCode == 200) {
        print('created');
      } else {
        Future.error ("Что-то пошло не так. Код ошибки: $res");
      }
    }

    String formatTimeOfDay(TimeOfDay tod) {
      final now = new DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
      return dt.toIso8601String();
    }

    Future<void> onCreateButtonClick() async {

      _loading = true;

      var name = _nameController.text;
      var time = formatTimeOfDay(_selectedTime);
      String img64 = "";
      var ex = p.extension(_image?.path ?? "");
      if (_image != null) {
        final bytes = _image!.readAsBytesSync();
        img64 = base64Encode(bytes);
      }

      await createSpace(name, time, img64, ex).then((value) => Navigator.pop(context));
      _loading = false;
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
      initialValue: const [],
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
      maxChips: 3,
      onChanged: (List<dynamic> value) {},
      suggestionBuilder:
          (BuildContext context, ChipsInputState<dynamic> state, data) {
        return const ListTile(
          key: ObjectKey(""),
          title: Text(""),
        );
      },
      findSuggestions: (String query) {
        if (query.isNotEmpty) {
          var lowercaseQuery = query.toLowerCase();
          return [].where((profile) {
            return profile.name.toLowerCase().contains(query.toLowerCase()) ||
                profile.email.toLowerCase().contains(query.toLowerCase());
          }).toList(growable: false)
            ..sort((a, b) => a.name
                .toLowerCase()
                .indexOf(lowercaseQuery)
                .compareTo(b.name.toLowerCase().indexOf(lowercaseQuery)));
        } else {
          return const [];
        }
      },
      chipBuilder:
          (BuildContext context, ChipsInputState<dynamic> state, data) {
        return const InputChip(
          key: ObjectKey(""),
          label: Text(""),
        );
      },
    );

    final createButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(4.0),
      color: _loading? Colors.grey : Theme.of(context).primaryColorLight,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        onPressed: _loading? null : onCreateButtonClick,
        disabledColor: Colors.grey,
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
                        child: ImageFromGalleryEx(setImage: setImage, initialImageUrl: widget.editingSpace?.imageUrl),
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
