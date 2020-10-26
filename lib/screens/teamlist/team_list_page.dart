import 'package:flutter/material.dart';
import 'package:goat_app/models/teamList.dart';
import 'package:goat_app/services/database.dart';
import '../app_drawer.dart';
import 'team_list_item.dart';
import '../../utils/constants.dart';
import '../../models/user.dart';
import 'package:provider/provider.dart';
import '../login/login_page.dart';

class TeamListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int _index = 0;
    User user = Provider.of<User>(context);

    //Catch is the user logs out and redirect to Login Page
    if (user == null) {
      return LoginPage();
    }

    return StreamBuilder<UserData>(
        stream: DatabaseService().userData(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DefaultTabController(
              initialIndex: 0,
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Team Lists'),
                  actions: [
                    if (snapshot.data.isAdmin)
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => Navigator.of(context).pushNamed(
                            ROUTE_NAME_ADD_TEAM_LIST,
                            arguments: _index),
                      ),
                  ],
                  bottom: TabBar(
                    onTap: (value) => _index = value,
                    tabs: [
                      Tab(text: 'Premier Grade'),
                      Tab(text: 'Reserve Grade'),
                      Tab(text: 'Third Grade'),
                    ],
                  ),
                ),
                drawer: AppDrawer(),
                body: StreamBuilder<List<TeamList>>(
                    stream: DatabaseService().teamListData,
                    builder: (context, snapshot) {
                      //Data has been recieved
                      if (snapshot.hasData) {
                        return TabBarView(
                          /* Each grid view below is a team list. The data is the databse will only every be 
                      updated they wont be deleted so we can use 0 for prems, 1 for reservers and 2 for third grade */
                          children: [
                            //ID 0 isequal to prermier grade
                            snapshot.data[0].players.length > 0
                                ? GridView.builder(
                                    itemCount: snapshot.data[0].players.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    itemBuilder: (context, index) =>
                                        TeamListItem(
                                      index: index + 1,
                                      name:
                                          snapshot.data[0].players[index].name,
                                      profileImage: snapshot
                                          .data[0].players[index].profileImage,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      "Teamlist has not yet been named",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                            //ID 1 is equal to reserve grade
                            snapshot.data[1].players.length > 0
                                ? GridView.builder(
                                    itemCount: snapshot.data[1].players.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    itemBuilder: (context, index) =>
                                        TeamListItem(
                                      index: index + 1,
                                      name:
                                          snapshot.data[1].players[index].name,
                                      profileImage: snapshot
                                          .data[1].players[index].profileImage,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      "Teamlist has not yet been named",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),

                            //ID 2 is equal to third grade
                            snapshot.data[2].players.length > 0
                                ? GridView.builder(
                                    itemCount: snapshot.data[2].players.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    itemBuilder: (context, index) =>
                                        TeamListItem(
                                      index: index + 1,
                                      name:
                                          snapshot.data[2].players[index].name,
                                      profileImage: snapshot
                                          .data[2].players[index].profileImage,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      "Teamlist has not yet been named",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                          ],
                        );
                      }

                      return Center(child: CircularProgressIndicator());
                    }),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
