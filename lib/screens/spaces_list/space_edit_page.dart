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
  final int? editingSpaceId;

  const SpaceEditPage({Key? key, this.editingSpaceId}) : super(key: key);

  @override
  _SpaceEditPageState createState() => _SpaceEditPageState();
}

class _SpaceEditPageState extends State<SpaceEditPage> {
  SpaceCardContent? oldSpace;

  final _notificationTimeController = TextEditingController();
  final _nameController = TextEditingController();
  final _notificationTimeFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _tagsFocusNode = FocusNode();
  var _selectedTime = const TimeOfDay(hour: 0, minute: 0);
  File? _image;
  bool _loading = false;
  List<String> tags = [];

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(_onFocusNodeEvent);
    _notificationTimeFocusNode.addListener(_onFocusNodeEvent);
    _tagsFocusNode.addListener(_onFocusNodeEvent);

    if(widget.editingSpaceId != null){
      _fetchSpaceInfo().then((value){
        setState(() {
          oldSpace = value;
          _nameController.text = oldSpace?.name ?? '';
          _notificationTimeController.text = oldSpace?.notificationTime.format(context) ?? '';
          tags = oldSpace?.tags ?? [];
        });
      });
    }
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

  Future<SpaceCardContent> _fetchSpaceInfo() async {
    final response = await Session.get(Uri.http(
        Session.SERVER_IP, '/getSpace', {'spaceId': widget.editingSpaceId.toString()}));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));

      return SpaceCardContent.fromJson(jsonResponse);
    } else {
      throw Exception(
          'Ошибка ${response.statusCode} при получении информации о пространстве');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> createSpace(String name, String time, String? image, String tags) async {
      var res = await Session.post(
          Uri.http(Session.SERVER_IP, widget.editingSpaceId != null ? '/editSpace' : '/createSpace', {'spaceId': widget.editingSpaceId?.toString()}),
          jsonEncode({
            'spaceName': name,
            'notificationTime': time,
            'tags': tags,
            'image': image
          }));

      if (res.statusCode == 200) {
        print('created');
      } else {
        Future.error("Что-то пошло не так. Код ошибки: ${res.statusCode}");
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
      String? img;
      if (_image != null) {
        final bytes = _image!.readAsBytesSync();
        var img64 = base64Encode(bytes);
        var ex = p.extension(_image?.path ?? "");
        img = jsonEncode({'data': img64, 'extension': ex});
      }

      await createSpace(name, time, img, tags.join(','))
          .then((value) => Navigator.pop(context));
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
        });

    final createButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(4.0),
      color: _loading ? Colors.grey : Theme.of(context).primaryColorLight,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        onPressed: _loading ? null : onCreateButtonClick,
        disabledColor: Colors.grey,
        child: Text(widget.editingSpaceId != null ? "РЕДАКТИРОВАТЬ ПРОСТРАНСТВО" : "СОЗДАТЬ ПРОСТРАНСТВО",
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
                        child: ImageFromGalleryEx(
                            setImage: setImage,
                            initialImageUrl: oldSpace?.imageUrl),
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
