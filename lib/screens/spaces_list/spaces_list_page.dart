import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/components/avatar.dart';
import 'package:green_thumb_mobile/components/title.dart';

import '../../app_theme.dart';

class SpacesListPage extends StatefulWidget {
  const SpacesListPage({Key? key}) : super(key: key);

  @override
  _SpacesListPageState createState() => _SpacesListPageState();
}

class _SpacesListPageState extends State<SpacesListPage> {
  final List<String> users = <String>["Tom", "Alice", "Bob", "Sam", "Kate"];


  @override
  Widget build(BuildContext context) {

    final comboboxSpacesBelong = DropdownButton<String>(
      items: <String>['Все', 'Личные'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (_) {},
    );

    final searchField = TextFormField(
      decoration: const InputDecoration(
          hintText: 'Поиск...',
          hintStyle: TextStyle(
            color: Color(0xffA9B2AA),
            fontSize: 14,
          ),
          contentPadding: EdgeInsets.fromLTRB(5.0, 15.0, 10.0, 0.0),
          suffixIcon: Icon(
            Icons.search,
            size: 20,
        )
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: TitleLogo('small'),
        actions: [
          Container(
            height: 64,
            width: 64,
            margin: const EdgeInsets.only(right: 15),
            child: UserAvatar(
                'https://sun9-48.userapi.com/impf/fmm-Q1ZA22IAdubGy31cFfz3h0CNwq1CP0Gs5w/v5DFeC3CLms.jpg?size=1619x2021&quality=96&sign=3a0a859c5727c9517cc8186d3266b822&type=album',
                'medium'),
          )
        ],
        backgroundColor: const Color(0xfff7f7f7),
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
      ),

      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        padding: const EdgeInsets.symmetric(horizontal: 19),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(child: searchField,

                  flex: 7,
                ),
              Expanded(child: comboboxSpacesBelong,
                  flex: 4
                )
              ]
            ),
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(users[index], style: TextStyle(fontSize: 22));
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
