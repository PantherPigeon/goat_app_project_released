import 'package:flutter/material.dart';
import 'package:goat_app/models/user.dart';
import '../../utils/constants.dart' as constants;

class PostAddButton extends StatelessWidget {
  final UserData user;

  PostAddButton(this.user);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Theme.of(context).primaryColor,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, constants.ROUTE_NAME_ADD_POST,
            arguments: {'user': user, 'postId': null}),
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Text(
            'Add a new Post...',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
