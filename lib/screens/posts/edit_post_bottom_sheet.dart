import 'package:flutter/material.dart';
import 'package:goat_app/services/database.dart';
import '../../utils/constants.dart';
import '../../models/user.dart';
import '../../models/post.dart';

class EditPostBottomSheet extends StatelessWidget {
  final Post post;
  final UserData user;
  EditPostBottomSheet({this.post, this.user});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                color: Theme.of(context).primaryColor,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(
                    context,
                    ROUTE_NAME_ADD_POST,
                    arguments: {
                      'post': post,
                      'user': user,
                    },
                  );
                },
                child: ListTile(
                  leading: Icon(
                    Icons.edit,
                    color: Colors.grey[800],
                  ),
                  title: Text(
                    'Edit Post',
                    style: TextStyle(fontSize: 20, color: Colors.grey[800]),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog<Null>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Delete Post"),
                      content: Text("Are you sure you want to delete?"),
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
                              DatabaseService().deletePost(post.id);
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),
                  );
                },
                child: ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Colors.grey[800],
                  ),
                  title: Text(
                    'Delete Post',
                    style: TextStyle(fontSize: 20, color: Colors.grey[800]),
                  ),
                ),
              ),
              SizedBox(height: 10)
            ],
          ),
        ),
      ],
    );
  }
}
