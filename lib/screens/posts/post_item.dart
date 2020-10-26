import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//models
import '../../models/post.dart';
import '../../models/user.dart';
import 'edit_post_bottom_sheet.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final UserData user;

  PostItem({this.post, this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (user.uid == post.authorUid) {
          showBottomSheet(
              context: context,
              builder: (context) => EditPostBottomSheet(
                    post: post,
                    user: user,
                  ));
        }
      },
      child: Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    post.authorName,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.7),
                  ),
                  Text(DateFormat('MMM d, hh:mm ').format(post.date)),
                ],
              ),
              Container(height: 8),
              Text(
                post.content,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
