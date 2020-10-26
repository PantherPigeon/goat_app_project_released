import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/constants.dart';
import '../../services/database.dart';
import '../../models/event.dart';
import '../../models/user.dart';

import 'schedule_bottom_sheet.dart';
import 'edit_schedule_bottom_sheet.dart';

class ScheduleItem extends StatelessWidget {
  final Event event;
  final UserData user;

  ScheduleItem({this.event, this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Attendee>>(
        stream: DatabaseService().attendeeData(event.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Text('No Data');
          }

          event.attendees = snapshot.data;

          return GestureDetector(
            onLongPress: () {
              if (user.isAdmin) {
                showBottomSheet(
                  context: context,
                  builder: (context) => EditScheduleBottomSheet(
                    event: event,
                    user: user,
                  ),
                );
              }
            },
            onTap: () => Navigator.pushNamed(
              context,
              ROUTE_NAME_VIEW_EVENT,
              arguments: {
                'user': user,
                'event': event,
              },
            ),
            child: Card(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: Colors.orange[500],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              DateFormat('MMM').format(event.date),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              DateFormat('dd').format(event.date),
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              event.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              DateFormat('EEEEE').add_jm().format(event.date),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Chip(label: Text('${event.numAvailable} Going')),
                          GestureDetector(
                            onTap: () => Scaffold.of(context).showBottomSheet(
                                (context) => ScheduleBottomSheet(event, user)),
                            child: Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.black)),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  event.currentUserStatus(user.uid) != null
                                      ? event.currentUserStatus(user.uid)
                                      : 'Set Availability',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
