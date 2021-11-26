import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/components/avatar.dart';
import 'package:green_thumb_mobile/components/title.dart';
import 'package:green_thumb_mobile/lib/session.dart';
import 'package:green_thumb_mobile/models/space_class.dart';
import 'package:green_thumb_mobile/models/user_class.dart';
import 'package:green_thumb_mobile/screens/spaces_list/space_component.dart';
import 'package:green_thumb_mobile/screens/spaces_list/space_edit_page.dart';
import 'package:green_thumb_mobile/stores/user_store.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';

class SpacesListPage extends StatefulWidget {
  const SpacesListPage({Key? key}) : super(key: key);

  @override
  _SpacesListPageState createState() => _SpacesListPageState();
}

class _SpacesListPageState extends State<SpacesListPage> {

  late Future<List<SpaceCardInfo>> spaces;
  final _searchController = TextEditingController();
  int spacesBelong = 0;
  bool loading = false;

  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {});
    });
    spaces = _fetchSpaces();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<SpaceCardInfo>> _fetchSpaces() async{
    final response = await Session.get(
        Uri.http(Session.SERVER_IP, '/getSpaces', {'filter': 'all'}));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => SpaceCardInfo.fromJson(data)).toList();
    } else {
      throw Exception('Ошибка ${response.statusCode} при получении пространств');
    }
  }

  Future<void> _refreshSpaces() async {
    final newSpaces = _fetchSpaces();
    setState(() {
      spaces = newSpaces;
    });
  }

  @override
  Widget build(BuildContext context) {

    final User? currentUser = Provider.of<UserStore>(context).user;

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
            newValue = newValue ?? 0;
            setState(() {
              spacesBelong = newValue!;
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
                  child: UserAvatar(currentUser!, 'medium'),
                ),
              onTap:  () => {Navigator.pushNamed(context, '/user-profile')},
            ),
          ],
          backgroundColor: const Color(0xfff7f7f7),
          automaticallyImplyLeading: false,
          toolbarHeight: 120,
        ),
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
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
                child: FutureBuilder(
                    future: spaces,
                    builder: (context, snapshot) {

                      if (snapshot.hasData) {
                        List<SpaceCardInfo> searchedSpaces = snapshot.data as List<SpaceCardInfo>;

                        searchedSpaces = searchedSpaces.where((element) =>
                            element.name.toLowerCase().contains(_searchController.text.toLowerCase())).toList();

                        return RefreshIndicator(
                          onRefresh: _refreshSpaces,
                          child: searchedSpaces.isEmpty ? const Text("На данный момент пространств нет!") :
                          ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              itemCount: searchedSpaces.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () => {Navigator.pushNamed(context, '/space')},
                                    child: SpaceCard(currentSpace: searchedSpaces[index]));
                              }),
                        );
                      }
                      else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                })
              )
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 40.0, right: 5),
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (_) => const SpaceEditPage());
            },
          ),
        )
    );
  }
}

