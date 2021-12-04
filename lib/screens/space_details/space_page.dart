import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:green_thumb_mobile/components/avatar.dart';
import 'package:green_thumb_mobile/lib/session.dart';
import 'package:green_thumb_mobile/models/plant_class.dart';
import 'package:green_thumb_mobile/models/space_class.dart';
import 'package:green_thumb_mobile/screens/space_details/add_participant_dialog.dart';
import 'package:green_thumb_mobile/screens/space_details/plant_edit_page.dart';
import 'package:green_thumb_mobile/screens/space_details/plant_component.dart';
import 'package:green_thumb_mobile/stores/user_store.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';

class SpacePage extends StatefulWidget {
  const SpacePage({Key? key}) : super(key: key);

  @override
  _SpacePageState createState() => _SpacePageState();
}

class _SpacePageState extends State<SpacePage> {
  late Map startInfo;

  final _searchController = TextEditingController();
  List<int> _idsSelectedPlants = [];

  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<SpaceCardContent> _fetchSpaceInfo() async {
    int spaceId = startInfo['id'];
    final response = await Session.get(Uri.http(
        Session.SERVER_IP, '/getSpace', {'spaceId': spaceId.toString()}));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));

      return SpaceCardContent.fromJson(jsonResponse);
    } else {
      throw Exception(
          'Ошибка ${response.statusCode} при получении информации о пространстве');
    }
  }

  void waterSelectedPlants(SpaceCardContent space) async {
    final response = await Session.post(
        Uri.http(Session.SERVER_IP, '/wateringPlants'),
        json.encode({'plantsId': _idsSelectedPlants}));

    if (response.statusCode == 200) {
      setState(() {
        _idsSelectedPlants.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    startInfo = ModalRoute.of(context)!.settings.arguments as Map;

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

    Material createWaterButton(SpaceCardContent space) {
      return Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8.0),
          color: _idsSelectedPlants.isEmpty
              ? Colors.grey
              : Theme.of(context).primaryColor,
          child: MaterialButton(
              onPressed: () => _idsSelectedPlants.isEmpty
                  ? null
                  : waterSelectedPlants(space),
              disabledColor: Colors.grey,
              child: const Text("ПОЛИТЬ",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16, color: Colors.white))));
    }

    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(115, 115, 115, 0.4),
            elevation: 1,
            actions: <Widget>[
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Text(startInfo['name'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w500)),
                const SizedBox(width: 2),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                ),
                const SizedBox(width: 3),
              ])
            ],
          ),
          body: FutureBuilder(
              future: _fetchSpaceInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  SpaceCardContent space = snapshot.data as SpaceCardContent;

                  bool isAuthorSpace = space.creator.id ==
                      Provider.of<UserStore>(context).user.id;

                  List<Plant> searchedPlants = space.plants
                      .where((element) => element.name
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()))
                      .toList();

                  return RefreshIndicator(
                      onRefresh: () async {
                        setState(() { });
                      },
                      child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(
                            decoration: const BoxDecoration(
                                gradient: AppTheme.backgroundGradient),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  FadeInImage.assetNetwork(
                                    placeholder:
                                        "assets/images/BigVstuLogo.jpg",
                                    image: space.imageUrl == null
                                        ? ""
                                        : Uri.http(Session.SERVER_IP,
                                                space.imageUrl!)
                                            .toString(),
                                    imageErrorBuilder: (context, error,
                                            stackTrace) =>
                                        Image.asset(
                                            "assets/images/BigVstuLogo.jpg"),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 20, 0, 0),
                                      child: Text("Участники",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500))),
                                  Expanded(
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10),
                                              width: 40.0,
                                              height: 40.0,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2,
                                                      vertical: 0),
                                              child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: UserAvatar(
                                                      space.creator, "small"))),
                                          SizedBox(
                                              width: 48.0 *
                                                  space.otherParticipants.length,
                                              child: ListView.builder(
                                                  itemCount: space
                                                      .otherParticipants.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                        width: 40.0,
                                                        height: 40.0,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 2,
                                                                vertical: 0),
                                                        child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: UserAvatar(
                                                                space.otherParticipants[
                                                                    index],
                                                                "small")));
                                                  })),
                                          if (isAuthorSpace)
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: RawMaterialButton(
                                                onPressed: () {
                                                  displayTextInputDialog(
                                                      context, space.id);
                                                },
                                                elevation: 2.0,
                                                fillColor: Colors.white,
                                                child: const Icon(Icons.add,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.2),
                                                    size: 30.0),
                                                shape: const CircleBorder(
                                                    side: BorderSide(
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 0.2))),
                                              ),
                                              height: 40,
                                              width: 40,
                                            ),
                                          IconButton(
                                              icon: Icon(
                                                  space.notificationOn
                                                      ? Icons.notifications_active_sharp
                                                      : Icons.notifications_none,
                                                  size: 35),
                                              onPressed: () {
                                                setState(() {
                                                  space.notificationOn =
                                                      !space.notificationOn;
                                                });
                                              })
                                        ]),
                                    flex: 1,
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                                child: searchField, flex: 8),
                                            const Expanded(
                                                child: SizedBox(), flex: 1),
                                            Expanded(
                                                child: createWaterButton(space),
                                                flex: 4)
                                          ],
                                        ),
                                      ),
                                      flex: 1),
                                  Expanded(
                                      child: searchedPlants.isEmpty
                                          ? const Center(
                                              child: Text(
                                                  "На данный момент растений нет!"))
                                          : ListView.builder(
                                              padding: const EdgeInsets.all(15),
                                              itemCount: searchedPlants.length,
                                              itemBuilder: (context, index) {
                                                void selectPlant(
                                                    int index, bool? newValue) {
                                                  setState(() {
                                                    if (newValue == true) {
                                                      _idsSelectedPlants
                                                          .add(index);
                                                    } else if (newValue ==
                                                        false) {
                                                      _idsSelectedPlants
                                                          .remove(index);
                                                    }
                                                  });
                                                }

                                                return PlantCard(
                                                    currentPlant:
                                                        searchedPlants[index],
                                                    isSelected:
                                                        _idsSelectedPlants
                                                            .contains(
                                                                searchedPlants[
                                                                        index]
                                                                    .id),
                                                    setIsSelectThisPlant:
                                                        selectPlant);
                                              }),
                                      flex: 5)
                                ]),
                            height: MediaQuery.of(context).size.height,
                          )
                      )
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}"));
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 40.0, right: 5),
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (_) => PlantAddPage(spaceId: startInfo['id']));
              },
            ),
          ),
        ));
  }
}
