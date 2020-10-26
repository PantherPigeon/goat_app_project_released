import 'package:flutter/material.dart';
import 'package:goat_app/screens/teamlist/add_team_list.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

//Constants
import './utils/constants.dart';

import 'services/auth.dart';
import 'package:goat_app/models/user.dart';

//Screens
import 'screens/wrapper.dart';
import 'screens/posts/post_page.dart';
import 'screens/schedule/schedule_page.dart';
import 'screens/login/login_page.dart';
import 'screens/posts/add_post_page.dart';
import 'screens/schedule/add_schedule_page.dart';
import 'screens/schedule/view_event_page.dart';
import 'screens/teamlist/team_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'CU Rugby',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.black,
          scaffoldBackgroundColor: Colors.grey[300],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Wrapper(),
        routes: {
          ROUTE_NAME_LOGIN: (context) => LoginPage(),
          ROUTE_NAME_HOME: (context) => PostPage(),
          ROUTE_NAME_SCHEDULE: (context) => SchedulePage(),
          ROUTE_NAME_TEAM_LIST: (context) => TeamListPage(),
          ROUTE_NAME_ADD_POST: (context) => AddPostPage(),
          ROUTE_NAME_ADD_EVENT: (context) => AddSchedulePage(),
          ROUTE_NAME_VIEW_EVENT: (context) => ViewEventPage(),
          ROUTE_NAME_ADD_TEAM_LIST: (context) => AddTeamList(),
        },
      ),
    );
  }
}

/* 
TODO TEAM LIST ADD DIALOG WHEN NO USER

*/
