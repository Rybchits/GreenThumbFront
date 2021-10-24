import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:green_thumb_mobile/app_theme.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'image_picker.dart';

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
  var _selectedTime = const TimeOfDay(hour: 0, minute: 0);

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(_onOnFocusNodeEvent);
    _notificationTimeFocusNode.addListener(_onOnFocusNodeEvent);
  }

  @override
  void dispose() {
    _notificationTimeController.dispose();
    _nameController.dispose();
    _notificationTimeFocusNode.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  _onOnFocusNodeEvent() {
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
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
        labelText: 'Название пространства',
        labelStyle: TextStyle(
            color: _nameFocusNode.hasFocus
                ? Theme.of(context).primaryColorDark
                : const Color.fromRGBO(0, 0, 0, 60)),
        contentPadding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffA9B2AA)),
        ),
      ),
      controller: _nameController,
    );

    final tagsField = ChipsInput(
      initialValue: const [],
      decoration: InputDecoration(
        labelText: "Теги пространства",
        labelStyle: TextStyle(
            color: _nameFocusNode.hasFocus
                ? Theme.of(context).primaryColorDark
                : const Color.fromRGBO(0, 0, 0, 60)),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
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
      color: Theme.of(context).primaryColorLight,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        onPressed: () => {Navigator.pushNamed(context, '/spaces')},
        child: const Text("СОЗДАТЬ ПРОСТРАНСТВО",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white)),
      ),
    );

    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).primaryColorLight),
      body: Center(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 0),
              decoration:
                  const BoxDecoration(gradient: AppTheme.backgroundGradient),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(children: [
                            const SizedBox(
                              child: ImageFromGalleryEx(),
                              height: 77,
                              width: 93,
                            ),
                            Container(
                                child: nameField,
                                height: 77,
                                width: 160,
                                margin: const EdgeInsets.only(left: 16))
                          ]),
                          margin: const EdgeInsets.only(bottom: 16, top: 16),
                        ),
                        Container(
                            child: notificationTimeField,
                            height: 56,
                            margin: const EdgeInsets.only(bottom: 16)),
                        Container(
                            child: tagsField,
                            height: 56,
                            margin: const EdgeInsets.only(bottom: 250)),
                        Container(
                            child: createButton,
                            height: 36,
                            margin: const EdgeInsets.only(bottom: 50)),
                      ],
                    )),
              ))),
    );
  }
}
