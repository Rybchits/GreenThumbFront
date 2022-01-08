import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/domain/repositories/spaces_store.dart';
import 'package:green_thumb_mobile/domain/repositories/user_store.dart';
import 'package:green_thumb_mobile/domain/view_models/space_card_info.dart';
import 'package:green_thumb_mobile/domain/view_models/space_page_argument.dart';
import 'package:green_thumb_mobile/screens/spaces_list/components/space_filters_component.dart';
import 'package:green_thumb_mobile/screens/spaces_list/components/space_list_component.dart';
import 'package:green_thumb_mobile/ui_components/avatar.dart';
import 'package:green_thumb_mobile/ui_components/title.dart';
import 'package:green_thumb_mobile/domain/entities/user_class.dart';
import 'package:green_thumb_mobile/screens/spaces_list/components/space_edit_page.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';

class SpacesListPage extends StatefulWidget {
  const SpacesListPage({Key? key}) : super(key: key);

  @override
  _SpacesListPageState createState() => _SpacesListPageState();
}

class _SpacesListPageState extends State<SpacesListPage> {
  late Future futureGetSpaces;

  @override
  void initState() {
    futureGetSpaces = Provider.of<SpacesStore>(context, listen: false).fetchSpaces();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refreshSpaces() async {
    futureGetSpaces = Provider.of<SpacesStore>(context, listen: false).fetchSpaces();
  }

  // Todo реализовать callback для filters
  void refreshListSpacesByFilters(String searchString, bool spacesBelong) {}

  @override
  Widget build(BuildContext context) {
    final User currentUser = Provider.of<UserStore>(context).user ?? User(nameUser: ' ');

    // Метод обработки долгого нажатия на карточку пространства (открывает модальное окно для редактирования)
    void longPressUpOnSpaceCard(SpaceCardInfo space) {
      // Todo сообщить что пользователь не имеет прав редактировать пространство
      if (currentUser.id == space.creator.id) {
        showModalBottomSheet(
            isScrollControlled: true, context: context, builder: (_) => SpaceEditPage(editingSpaceId: space.id));
      }
    }

    // Метод обработки нажатия на карточку пространства (открывает страницу для просмотра деталей)
    void pressOnSpaceCard(SpaceCardInfo space) {
      Navigator.pushNamed(context, '/space', arguments: SpacePageArgument(space.id, space.name));
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          title: TitleLogo('small'),
          actions: [
            GestureDetector(
              child: Container(
                height: 64,
                width: 64,
                margin: const EdgeInsets.only(right: 15),
                child: UserAvatar(currentUser, 'medium'),
              ),
              onTap: () => {Navigator.pushNamed(context, '/user-profile')},
            ),
          ],
          backgroundColor: const Color(0x10000000),
          automaticallyImplyLeading: false,
          toolbarHeight: 100,
        ),
        body: RefreshIndicator(
          onRefresh: _refreshSpaces,
          child: SingleChildScrollView(
            primary: true,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              decoration: const BoxDecoration(image: AppTheme.backgroundImage),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: <Widget>[
                const SizedBox(height: 120),
                SpaceFiltersComponent(refreshListByFilters: refreshListSpacesByFilters),
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder(
                    future: futureGetSpaces,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        List<SpaceCardInfo> spaces = Provider.of<SpacesStore>(context, listen: false)
                            .spaces.map((e) => SpaceCardInfo.fromSpaceDetails(e)).toList();

                        // Todo вынести логику сортировки и фильтрации в репозиторий
                        /*  searchedSpaces.sort((a, b) => a.name.compareTo(b.name));
                                  searchedSpaces = searchedSpaces.where((element) =>
                                      element.name.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
                              */

                        return spaces.isEmpty
                            ? const Center(child: Text("На данный момент пространств нет!"))
                            : SpaceListComponent(
                                spaces: spaces,
                                pressOnCard: pressOnSpaceCard,
                                longPressUpOnCard: longPressUpOnSpaceCard,
                              );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ]),
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 40.0, right: 5),
          child: FloatingActionButton(
            elevation: 3,
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(isScrollControlled: true, context: context, builder: (_) => const SpaceEditPage());
            },
          ),
        ));
  }
}
