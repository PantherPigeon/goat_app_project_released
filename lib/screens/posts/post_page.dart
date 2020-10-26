import 'package:flutter/material.dart';
import 'package:goat_app/screens/login/login_page.dart';
import 'package:goat_app/screens/posts/post_add_button.dart';
import 'package:goat_app/screens/posts/post_item.dart';
import 'package:provider/provider.dart';

import '../../services/database.dart';
import '../../models/post.dart';
import '../../models/user.dart';

import '../app_drawer.dart';

class PostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    //Catch is the use logs out and redirect to Login Page
    if (user == null) {
      return LoginPage();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('CU Rugby'),
        ),
        drawer: AppDrawer(),
        body: StreamBuilder<UserData>(
          stream: DatabaseService().userData(user.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            UserData userData = snapshot.data;

            return StreamBuilder<List<Post>>(
              stream: DatabaseService().postData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return Text('No Data');
                }

                if (userData.isAdmin) {
                  return ListView.builder(
                    itemCount: snapshot.data.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return PostAddButton(userData);
                      }

                      return PostItem(
                        post: snapshot.data[index - 1],
                        user: userData,
                      );
                    },
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return PostItem(
                      post: snapshot.data[index],
                      user: userData,
                    );
                  },
                );
              },
            );
          },
        ));
  }
}
