import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/screens/spaces_list/components/space_filters_component.dart';
import 'package:green_thumb_mobile/screens/spaces_list/components/space_list_component.dart';
import 'package:green_thumb_mobile/ui_components/avatar.dart';
import 'package:green_thumb_mobile/ui_components/title.dart';
import 'package:green_thumb_mobile/services/secure_storage.dart';
import 'package:green_thumb_mobile/business_logic/models/space_class.dart';
import 'package:green_thumb_mobile/business_logic/models/user_class.dart';
import 'package:green_thumb_mobile/screens/spaces_list/components/space_edit_page.dart';
import 'package:green_thumb_mobile/business_logic/stores/user_store.dart';
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

  Future<List<SpaceCardInfo>> _fetchSpaces() async {
    final response = await Session.get(Uri.http(Session.SERVER_IP, '/getSpaces', {'filter': 'all'}));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
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

  // Todo реализовать callback для filters
  void refreshListSpacesByFilters(String searchString, bool spacesBelong){

  }

  @override
  Widget build(BuildContext context) {

    // Todo проверить пользователя на null
    final User? currentUser = Provider.of<UserStore>(context).user;

    // Метод обработки долгого нажатия на карточку пространства (открывает модальное окно для редактирования)
    void longPressUpOnSpaceCard(SpaceCardInfo space){

      if (currentUser!.id == space.creator.id){
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) =>
                SpaceEditPage(editingSpaceId: space.id));
      }
    }

    // Метод обработки нажатия на карточку пространства (открывает страницу для просмотра деталей)
    void pressOnSpaceCard(SpaceCardInfo space){
      Navigator.pushNamed(context, '/space', arguments: {
        'id': space.id,
        'name': space.name
      });
    }

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
              onTap: () => {Navigator.pushNamed(context, '/user-profile')},
            ),
          ],
          backgroundColor: const Color(0xfff7f7f7),
          automaticallyImplyLeading: false,
          toolbarHeight: 100,
        ),
        body: RefreshIndicator(
          onRefresh: _refreshSpaces,
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                  decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  child: Column(
                    children: <Widget>[
                      SpaceFiltersComponent(refreshListByFilters: refreshListSpacesByFilters),
                      const SizedBox(height: 10),
                      Expanded(
                          child: FutureBuilder(
                              future: spaces,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<SpaceCardInfo> searchedSpaces = snapshot.data as List<SpaceCardInfo>;
                                  searchedSpaces.sort((a, b) => a.name.compareTo(b.name));

                                  searchedSpaces = searchedSpaces.where((element) =>
                                      element.name.toLowerCase().contains(_searchController.text.toLowerCase())).toList();

                                  return searchedSpaces.isEmpty ?
                                    const Center(child: Text("На данный момент пространств нет!"))
                                      : SpaceListComponent(
                                            spaces: searchedSpaces,
                                            pressOnCard: pressOnSpaceCard,
                                            longPressUpOnCard: longPressUpOnSpaceCard,
                                  );
                                }
                                else if (snapshot.hasError) { return Text("${snapshot.error}"); }
                                return const Center(child: CircularProgressIndicator());
                              })
                      )
                    ],
                  ),
                  height: MediaQuery.of(context).size.height)),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 40.0, right: 5),
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(isScrollControlled: true, context: context, builder: (_) => const SpaceEditPage());
            },
          ),
        )
    );
  }
}