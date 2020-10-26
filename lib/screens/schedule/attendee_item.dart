import 'package:flutter/material.dart';
import '../../models/event.dart';

class AttendeeItem extends StatelessWidget {
  final Attendee atendee;

  AttendeeItem(this.atendee);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: atendee.status == 'available'
                ? Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 30,
                  )
                : atendee.status == 'other'
                    ? Icon(
                        Icons.help_outline,
                        color: Colors.orange,
                        size: 30,
                      )
                    : Icon(
                        Icons.highlight_off,
                        color: Colors.red,
                        size: 30,
                      ),
          ),
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(atendee.name, style: TextStyle(fontSize: 18)),
                  if (atendee.reason.isNotEmpty)
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(atendee.reason,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 14)),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
