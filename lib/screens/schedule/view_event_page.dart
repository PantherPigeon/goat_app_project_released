import 'package:flutter/material.dart';
import 'package:goat_app/models/event.dart';

import '../../models/user.dart';
import '../../models/event.dart';

import 'view_event_details.dart';
import 'attendee_item.dart';

class ViewEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map _args;
    UserData _user;
    Event _event;

    // Get the user and event details from the scheule item
    _args = ModalRoute.of(context).settings.arguments as Map;
    _user = _args['user'];
    _event = _args['event'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        children: [
          ViewEventDetails(_event),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var attendee in _event.attendees) AttendeeItem(attendee),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
