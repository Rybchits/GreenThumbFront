import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:green_thumb_mobile/components/avatar.dart';
import 'package:green_thumb_mobile/models/space_class.dart';
import 'package:green_thumb_mobile/models/user_class.dart';
import 'package:green_thumb_mobile/stores/user_store.dart';
import 'package:provider/provider.dart';

class SpacePage extends StatefulWidget {
  const SpacePage({Key? key}) : super(key: key);

  @override
  _SpacePageState createState() => _SpacePageState();
}

class _SpacePageState extends State<SpacePage> {
  SpaceCardContent space = SpaceCardContent.fullConstructor(
      0,
      "Наша квартира",
      "https://www.province.ru/media/k2/items/cache/2d565dcc1792c919daba23b9424013fe_Generic.jpg",
      const TimeOfDay(hour: 8, minute: 0),
      [],
      [ User("", "",
            "https://sun9-48.userapi.com/impf/fmm-Q1ZA22IAdubGy31cFfz3h0CNwq1CP0Gs5w/v5DFeC3CLms.jpg?size=1619x2021&quality=96&sign=3a0a859c5727c9517cc8186d3266b822&type=album"),
        User("", "",
            "https://sun9-87.userapi.com/impf/c849424/v849424663/ec86d/Pj6oJ8NDHsk.jpg?size=198x198&quality=96&sign=d457797e08c876def200b8a01dae1f22&type=audio")
      ],
      true);

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isAuthorSpace = space.idCreator == Provider.of<UserStore>(context).user.id;

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

    final waterButton = Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).primaryColorLight,
        child: MaterialButton(
            onPressed: () {},
            child: const Text("ПОЛИТЬ",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, color: Colors.white))));

    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              backgroundColor: const Color.fromRGBO(115, 115, 115, 0.4),
              elevation: 1,
              actions: <Widget>[
                Row( crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(space.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 10)
                ])
              ],
          ),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FadeInImage.assetNetwork(
                  placeholder: "assets/images/VstuLogo.jpg",
                  image: space.imageUrl == null ? "" : space.imageUrl!,
                ),
                const Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: Text("Участники",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500))),
                Expanded(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            width: 48.0 * space.users.length,
                            child: ListView.builder(
                                padding: const EdgeInsets.only(left: 10),
                                itemCount: space.users.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                      width: 40.0,
                                      height: 40.0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 0),
                                      child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: UserAvatar(
                                              space.users[index].urlAvatar,
                                              "small")));
                                })),
                        if (isAuthorSpace)
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: RawMaterialButton(
                              onPressed: () {},
                              elevation: 2.0,
                              fillColor: Colors.white,
                              child: const Icon(Icons.add,
                                  color: Color.fromRGBO(0, 0, 0, 0.2),
                                  size: 30.0),
                              shape: const CircleBorder(
                                  side: BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.2))),
                            ),
                            height: 40,
                            width: 40,
                          ),
                        IconButton(
                            alignment: Alignment.topCenter,
                            icon: Icon(
                                space.notificationOn ? Icons.notifications_active_sharp
                                    : Icons.notifications_none,
                                size: 35),
                            onPressed: () {
                              setState(() {
                                space.notificationOn = !space.notificationOn;
                              });
                            })
                      ]),
                  flex: 1,
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: searchField, flex: 8),
                          const Expanded(child: SizedBox(), flex: 1),
                          Expanded(child: waterButton, flex: 4)
                        ],
                      ),
                    ),
                    flex: 1),
                const Expanded(child: SizedBox(), flex: 5)
              ]),
        )
    );
  }
}
