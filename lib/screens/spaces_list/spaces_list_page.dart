import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/components/avatar.dart';
import 'package:green_thumb_mobile/components/title.dart';
import 'package:green_thumb_mobile/models/space_class.dart';
import 'package:green_thumb_mobile/screens/spaces_list/space_component.dart';

import '../../app_theme.dart';

class SpacesListPage extends StatefulWidget {
  const SpacesListPage({Key? key}) : super(key: key);

  @override
  _SpacesListPageState createState() => _SpacesListPageState();
}

class _SpacesListPageState extends State<SpacesListPage> {
  final List<Space> spaces = <Space>[
    Space(1, "Моя квартира", const TimeOfDay(hour: 8, minute: 0), "url", {'#ВолгГТУ'}),
    Space(1, "Твоя квартира", const TimeOfDay(hour: 8, minute: 0), "url", {'#Home', '#YourFlat'}),
    Space(1, "Наша квартира", const TimeOfDay(hour: 8, minute: 0), "url", {}),
    Space(1, "Бабки квартира", const TimeOfDay(hour: 8, minute: 0), "url", {}),
    Space(1, "Еще одна квартираааа", const TimeOfDay(hour: 8, minute: 0), "url", {})
  ];
  final _searchController = TextEditingController();
  int? spacesBelong = 0;

  void _pushSaved() {
    Navigator.pushNamed(context, '/space-form');
  }

  @override
  Widget build(BuildContext context) {
    final comboboxSpacesBelong = InputDecorator(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 10.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: spacesBelong,
          isDense: true,
          isExpanded: true,
          items: const [
            DropdownMenuItem(child: Text("Все"), value: 0),
            DropdownMenuItem(child: Text("Личные"), value: 1),
          ],
          onChanged: (newValue) {
            setState(() {
              spacesBelong = newValue;
            });
          },
        ),
      ),
    );

    final searchField = TextFormField(
      controller: _searchController,
      decoration: const InputDecoration(
        hintText: 'Поиск...',
        hintStyle: TextStyle(
          color: Color(0xffA9B2AA),
          fontSize: 14,
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
          child: Icon(Icons.search, size: 20, color: Color(0xffA9B2AA)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffA9B2AA)),
        ),
        contentPadding: EdgeInsets.fromLTRB(5.0, 20.0, 10.0, 0.0),
      ),
      cursorColor: Theme.of(context).primaryColorDark,
    );

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: TitleLogo('small'),
          actions: [
            GestureDetector(
                child: Container(
                  height: 64,
                  width: 64,
                  margin: const EdgeInsets.only(right: 15),
                  child: UserAvatar(
                  'https://sun9-48.userapi.com/impf/fmm-Q1ZA22IAdubGy31cFfz3h0CNwq1CP0Gs5w/v5DFeC3CLms.jpg?size=1619x2021&quality=96&sign=3a0a859c5727c9517cc8186d3266b822&type=album',
                  'medium'),
                ),
              onTap:  () => {Navigator.pushNamed(context, '/user-profile')},
            ),
          ],
          backgroundColor: const Color(0xfff7f7f7),
          automaticallyImplyLeading: false,
          toolbarHeight: 120,
        ),
        body: Container(
          decoration:
              const BoxDecoration(gradient: AppTheme.backgroundGradient),
          padding: const EdgeInsets.symmetric(horizontal: 19),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: searchField, flex: 8),
                  const Expanded(child: SizedBox(width: 20), flex: 1),
                  Expanded(
                      child: SizedBox(child: comboboxSpacesBelong, height: 35),
                      flex: 4)
                ],
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    itemCount: spaces.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SpaceCard(currentSpace: spaces[index]);
                    }),
              )
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 40.0, right: 5),
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColorLight,
            child: const Icon(Icons.add),
            onPressed: _pushSaved,
          ),
        ));
  }
}
