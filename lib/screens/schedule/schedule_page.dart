import 'package:flutter/material.dart';
import 'package:goat_app/screens/schedule/schedule_add_button.dart';
import 'package:provider/provider.dart';
import '../../services/database.dart';
import '../../models/user.dart';
import '../../models/event.dart';
import '../login/login_page.dart';
import '../schedule/schedule_item.dart';

import '../app_drawer.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    //Catch is the use logs out and redirect to Login Page
    if (user == null) {
      return LoginPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
      ),
      drawer: AppDrawer(),
      body: StreamBuilder<UserData>(
        stream: DatabaseService().userData(user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          UserData user = snapshot.data;

          return StreamBuilder<List<Event>>(
            stream: DatabaseService().eventData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData) {
                return Text('No Data');
              }

              if (user.isAdmin) {
                return ListView.builder(
                  itemCount: snapshot.data.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return ScheduleAddButton(user);
                    }

                    return ScheduleItem(
                      event: snapshot.data[index - 1],
                      user: user,
                    );
                  },
                );
              }

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ScheduleItem(
                    event: snapshot.data[index],
                    user: user,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
