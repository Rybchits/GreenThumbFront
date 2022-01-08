import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:green_thumb_mobile/data/dto_models/image_request_model.dart';
import 'package:green_thumb_mobile/data/dto_models/space_request_model.dart';
import 'package:green_thumb_mobile/domain/repositories/spaces_store.dart';
import 'package:green_thumb_mobile/domain/entities/space_class.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import '../../../ui_components/image_picker.dart';

class SpaceEditPage extends StatefulWidget {
  final int? editingSpaceId;

  const SpaceEditPage({Key? key, this.editingSpaceId}) : super(key: key);

  @override
  _SpaceEditPageState createState() => _SpaceEditPageState();
}

class _SpaceEditPageState extends State<SpaceEditPage> {
  Future<SpaceDetails?>? getSpaceFuture;

  final _notificationTimeController = TextEditingController();
  final _nameController = TextEditingController();
  final _notificationTimeFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _tagsFocusNode = FocusNode();

  TimeOfDay? _selectedTime;
  File? _image;
  List<String> tags = [];
  bool _disableActionButton = false;

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(_onFocusNodeEvent);
    _notificationTimeFocusNode.addListener(_onFocusNodeEvent);
    _tagsFocusNode.addListener(_onFocusNodeEvent);

    if (widget.editingSpaceId != null) {
      getSpaceFuture = Provider.of<SpacesStore>(context, listen: false).getSpaceFromApi(widget.editingSpaceId!);
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
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 0, minute: 0),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        final now = DateTime.now();
        final tempDate = DateTime(now.year, now.month, now.day, _selectedTime!.hour, _selectedTime!.minute);
        _notificationTimeController.text = DateFormat("hh:mm a").format(tempDate).toString();
      });
    }
  }

  void setImage(File file) {
    setState(() {
      _image = file;
    });
  }

  Future<void> onActionButtonClick() async {
    _disableActionButton = true;

    var requestModel = SpaceRequestModel(
        name: _nameController.text,
        notificationTimeOfDay: _selectedTime,
        imageAvatar: _image == null
            ? null
            : ImageRequestModel(
                data: base64Encode(_image!.readAsBytesSync()), extension: p.extension(_image?.path ?? "")),
        tags: tags);

    if (widget.editingSpaceId == null) {
      Provider.of<SpacesStore>(context, listen: false)
          .addNewSpace(requestModel)
          .then((value) => Navigator.pop(context));
    } else {
      Provider.of<SpacesStore>(context, listen: false)
          .editExistSpace(widget.editingSpaceId!, requestModel)
          .then((value) => Navigator.pop(context));
    }

    _disableActionButton = false;
  }

  @override
  Widget build(BuildContext context) {

    SpaceDetails? oldSpace;

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
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColorDark, width: 2)),
          ),
          controller: _notificationTimeController,
        ));

    final nameField = TextFormField(
      obscureText: false,
      focusNode: _nameFocusNode,
      style: const TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
      decoration: InputDecoration(
        hintText: 'Название пространства...',
        hintStyle:
            TextStyle(color: _nameFocusNode.hasFocus ? const Color(0xffA9B2AA) : const Color.fromRGBO(0, 0, 0, 60)),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffA9B2AA)),
        ),
      ),
      controller: _nameController,
    );

    final tagsField = ChipsInput(
        initialValue: tags,
        focusNode: _tagsFocusNode,
        decoration: InputDecoration(
          labelText: "Теги пространства",
          labelStyle: TextStyle(
              color: _tagsFocusNode.hasFocus ? Theme.of(context).primaryColorDark : const Color.fromRGBO(0, 0, 0, 60)),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(color: Color(0xff979797)),
          ),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColorDark, width: 2)),
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
              return value.toLowerCase().contains(lowercaseQuery) || value.toLowerCase().contains(lowercaseQuery);
            }).toList(growable: false);
          } else {
            return [query];
          }
        });

    final actionButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(4.0),
      color: _disableActionButton ? Colors.grey : Theme.of(context).primaryColorLight,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        onPressed: _disableActionButton ? null : onActionButtonClick,
        disabledColor: Colors.grey,
        child: Text(widget.editingSpaceId != null ? "РЕДАКТИРОВАТЬ ПРОСТРАНСТВО" : "СОЗДАТЬ ПРОСТРАНСТВО",
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.white)),
      ),
    );

    final editSpaceForm = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 80,
          child: Row(
            children: [
              Expanded(
                child: ImageFromGalleryEx(setImage: setImage, initialImageUrl: oldSpace?.imageUrl),
                flex: 6,
              ),
              const Expanded(child: SizedBox(), flex: 1),
              Expanded(child: nameField, flex: 11)
            ],
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),
          margin: const EdgeInsets.only(bottom: 16),
        ),
        Container(child: notificationTimeField, height: 56, margin: const EdgeInsets.only(bottom: 16)),
        Container(child: tagsField, height: 56, margin: const EdgeInsets.only(bottom: 16)),
        Container(child: actionButton, height: 36, margin: const EdgeInsets.only(bottom: 5)),
      ],
    );

    return Container(
        margin: const EdgeInsets.all(25),
        padding: MediaQuery.of(context).viewInsets,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: widget.editingSpaceId != null? FutureBuilder(
            future: getSpaceFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {

                oldSpace = snapshot.data as SpaceDetails?;
                _nameController.text = oldSpace?.name ?? '';
                tags = oldSpace?.tags ?? [];

                final now = DateTime.now();
                final tempDate = DateTime(now.year, now.month, now.day, oldSpace?.notificationTime.hour ?? 0,
                    oldSpace?.notificationTime.minute ?? 0);

                _notificationTimeController.text =
                    oldSpace?.notificationTime == null ? '' : DateFormat("hh:mm a").format(tempDate).toString();

                return editSpaceForm;
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error as String));
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ) : editSpaceForm,
        ),
    );
  }
}
