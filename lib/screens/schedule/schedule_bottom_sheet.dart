import 'package:flutter/material.dart';
import '../../services/database.dart';
import '../../models/event.dart';
import '../../models/user.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final UserData user;
  final Event event;

  ScheduleBottomSheet(this.event, this.user);

  @override
  _ScheduleBottomSheetState createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  String _currentStatus;
  String _reason;

  @override
  void initState() {
    _currentStatus = widget.event.currentUserStatus(widget.user.uid);
    _reason = widget.event.currentUserReason(widget.user.uid);
    super.initState();
  }

  void _updateStatus(String value) {
    setState(() {
      _currentStatus = value;
    });
  }

  void _updateReason(String value) {
    setState(() {
      _reason = value;
    });
  }

  void _submit() async {
    if (_currentStatus != 'other') {
      _reason = "";
    }

    DatabaseService().updateAtendee(widget.event.id, widget.user.uid,
        widget.user.name, _currentStatus, _reason);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: ListView(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select your availability',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _submit();
                            Navigator.of(context).pop();
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: Radio<String>(
              groupValue: _currentStatus,
              value: "available",
              onChanged: (value) => _updateStatus(value),
            ),
            title: Text('Available'),
          ),
          ListTile(
            leading: Radio<String>(
              groupValue: _currentStatus,
              value: "unavailable",
              onChanged: (value) => _updateStatus(value),
            ),
            title: Text('Unavailable'),
          ),
          ListTile(
            leading: Radio<String>(
              groupValue: _currentStatus,
              value: "injured",
              onChanged: (value) => _updateStatus(value),
            ),
            title: Text('Injured'),
          ),
          ListTile(
            leading: Radio<String>(
              groupValue: _currentStatus,
              value: "other",
              onChanged: (value) => _updateStatus(value),
            ),
            title: TextFormField(
              initialValue: _reason,
              decoration: InputDecoration(labelText: 'other'),
              onChanged: (value) => _updateReason(value),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
