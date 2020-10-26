import 'package:flutter/material.dart';
import 'package:goat_app/screens/login/login_page.dart';
import 'package:goat_app/services/auth.dart';
import 'package:goat_app/services/database.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User _user = Provider.of<User>(context);

    if (_user == null) {
      return LoginPage();
    }

    return StreamBuilder<UserData>(
        stream: DatabaseService().userData(_user != null ? _user.uid : ' '),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          UserData userData = snapshot.data;

          return Drawer(
            child: Column(
              children: <Widget>[
                Container(
                    color: Theme.of(context).primaryColor,
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: MemoryImage(userData.profileImage),
                          radius: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            userData.name,
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Games: ${userData.games}',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ],
                    )),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () => Navigator.of(context).pushNamed(ROUTE_NAME_HOME),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('Schedule'),
                  onTap: () =>
                      Navigator.of(context).pushNamed(ROUTE_NAME_SCHEDULE),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.supervised_user_circle),
                  title: Text('Teamsheet'),
                  onTap: () =>
                      Navigator.of(context).pushNamed(ROUTE_NAME_TEAM_LIST),
                ),
                Divider(
                  color: Colors.black,
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Sign Out'),
                  onTap: () {
                    Navigator.of(context).pop();
                    showDialog<Null>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Sign Out"),
                        content: Text("Are you sure you want to Sign Out?"),
                        actions: <Widget>[
                          FlatButton(
                            color: Colors.blue[800],
                            child: Text("No"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          FlatButton(
                              color: Theme.of(context).errorColor,
                              child: Text("Yes"),
                              onPressed: () {
                                AuthService().signOut();
                                Navigator.of(context).pop();
                              }),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}
