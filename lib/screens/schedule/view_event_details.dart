import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/event.dart';

class ViewEventDetails extends StatelessWidget {
  final Event _event;
  ViewEventDetails(this._event);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              _event.title,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            DateFormat('EEEEE @').add_jm().format(_event.date),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ConstrainedBox(
            constraints: new BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.2,
            ),
            child: Container(
              padding: EdgeInsets.only(top: 8.0),
              child: SingleChildScrollView(
                child: Text(_event.details),
              ),
            ),
          ),
          Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Text('Going', style: TextStyle(fontSize: 18)),
                        Text(
                          _event.numAvailable.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Text('Unavailable', style: TextStyle(fontSize: 18)),
                        Text(
                          _event.numNotAvailable.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Text('Other', style: TextStyle(fontSize: 18)),
                        Text(
                          _event.numOther.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
