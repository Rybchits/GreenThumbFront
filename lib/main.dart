import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/app_theme.dart';
import 'package:green_thumb_mobile/domain/repositories/api_repository.dart';
import 'package:green_thumb_mobile/domain/repositories/spaces_store.dart';
import 'package:green_thumb_mobile/domain/view_models/space_page_argument.dart';
import 'package:green_thumb_mobile/screens/login/login_page.dart';
import 'package:green_thumb_mobile/screens/registration/registration_page.dart';
import 'package:green_thumb_mobile/screens/space_details/space_page.dart';
import 'package:green_thumb_mobile/screens/user_profile/user_page.dart';
import 'package:green_thumb_mobile/domain/repositories/user_store.dart';
import 'screens/spaces_list/spaces_list_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( MultiProvider(providers: [
    Provider(create: (_) => APIRepository()),

    ChangeNotifierProxyProvider<APIRepository, UserStore>(
        create: (_) => UserStore(),
        update: (_, APIRepository api, UserStore? prev) => (prev?..api = api) ?? UserStore(api: api)),

    ChangeNotifierProxyProvider<APIRepository, SpacesStore>(
        create: (_) => SpacesStore(),
        update: (_, APIRepository api, SpacesStore? prev) => (prev?..api = api) ?? SpacesStore(api: api)),
  ], child: const MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/registration': (context) => const RegistrationPage(),
          '/spaces': (context) => const SpacesListPage(),
          '/user-profile': (context) => const UserPage(),
          '/space': (context) => SpacePage(argument: ModalRoute.of(context)?.settings.arguments as SpacePageArgument?)
        },
        theme: AppTheme.lightTheme);
  }
}
