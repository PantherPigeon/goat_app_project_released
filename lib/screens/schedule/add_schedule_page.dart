import 'package:flutter/material.dart';
import 'package:goat_app/services/database.dart';
import 'package:intl/intl.dart';
import '../../models/event.dart';
import '../../models/user.dart';

class AddSchedulePage extends StatefulWidget {
  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  bool isInit = true;
  bool _isLoading = false;
  bool isEdit = false;
  Map args;
  UserData user;
  Event event = Event();
  // DateTime date = DateTime.now();

  TextEditingController _date = new TextEditingController();
  TextEditingController _time = new TextEditingController();

  @override
  void initState() {
    event.type = "training";
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      Map args = ModalRoute.of(context).settings.arguments as Map;
      event.authorUid = args['user'];

      if (args['event'] != null) {
        setState(() {
          isEdit = true;
          event = args['event'] as Event;
          // date = event.date;
          _date.text = DateFormat('dd MMM yyyy').format(event.date);
          _time.text = DateFormat().add_jm().format(event.date);
        });
      }
      setState(() {
        isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  /* Set the event type and also update state so the colour of the chip can
  can be updated also.  */
  void _setType(context, String type) {
    setState(() {
      event.type = type;
    });
  }

  /* Take the time from the Time Picker and add it to the date 
  update state so value is shown in Time Text Field */
  void _setTime(context) async {
    FocusScope.of(context).unfocus(); //Clears keyboard
    var time = await showTimePicker(
        // context: context, initialTime: TimeOfDay.fromDateTime(date));
        context: context,
        initialTime: TimeOfDay.fromDateTime(event.date));

    if (time != null) {
      setState(() {
        event.date = DateTime(event.date.year, event.date.month, event.date.day,
            time.hour, time.minute);
        _time.value =
            TextEditingValue(text: DateFormat().add_jm().format(event.date));
      });
    }
  }

  /* Take the date from the Date Picker and add it to the date 
  update state so value is shown in Date Text Field */
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != event.date)
      setState(() {
        event.date = picked;
        _date.value =
            TextEditingValue(text: DateFormat('dd MMM yyyy').format(picked));
      });
  }

  /*Save the form and attempt to send data to the back end. if it is valid.
  if it is not valid then show the error message below the Text Fields.  */
  void _saveForm(context) async {
    FocusScope.of(context).unfocus(); // Clears keyboard
    if (!_formKey.currentState.validate()) return; //Validate form

    _formKey.currentState.save(); //Save form data

    setState(() => _isLoading = true);
    try {
      if (isEdit) {
        await DatabaseService().updateEvent(event);
      } else {
        await DatabaseService().addEvent(event);
      }
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("An Error Occured"),
          content: Text("Something went Wrong"),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }

    setState(() => _isLoading = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        textTheme:
            TextTheme(headline6: TextStyle(color: Colors.black, fontSize: 18)),
        title: isEdit ? Text('Edit Event') : Text("New Event"),
        centerTitle: true,
        actions: [
          FlatButton(
            child: Text(
              isEdit ? 'Update' : 'Add',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () => _saveForm(context),
          )
        ],
      ),
      body: _isLoading
          ? Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ))
          : Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              padding: EdgeInsets.only(left: 10, right: 10, top: 20),

              // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /* Chips along the top to select Training, Game and Event */
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => _setType(context, 'training'),
                            child: Chip(
                              label: SizedBox(
                                height: 20,
                                width: MediaQuery.of(context).size.width * 0.22,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Training',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              elevation: 5,
                              backgroundColor: event.type == 'training'
                                  ? Colors.deepOrange
                                  : Colors.grey[200],
                              labelStyle: TextStyle(
                                fontSize: 20,
                                color: event.type == 'training'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              labelPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 8),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _setType(context, 'game'),
                            child: Chip(
                              label: SizedBox(
                                height: 20,
                                width: MediaQuery.of(context).size.width * 0.22,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Game',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              elevation: 5,
                              backgroundColor: event.type == 'game'
                                  ? Colors.deepOrange
                                  : Colors.grey[200],
                              labelStyle: TextStyle(
                                fontSize: 20,
                                color: event.type == 'game'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              labelPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 8),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _setType(context, 'event'),
                            child: Chip(
                              label: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.22,
                                height: 20,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Event',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              elevation: 5,
                              backgroundColor: event.type == 'event'
                                  ? Colors.deepOrange
                                  : Colors.grey[200],
                              labelStyle: TextStyle(
                                fontSize: 20,
                                color: event.type == 'event'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              labelPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 8),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextFormField(
                          initialValue: event.title,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'You Must Have a title.';
                            }
                            return null; // Input Correct
                          },
                          onSaved: (value) => event.title = value,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: _date,
                                      decoration: InputDecoration(
                                        labelText: 'Date',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter a date';
                                        }
                                        return null; // Input Correct
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: GestureDetector(
                                onTap: () => _setTime(context),
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _time,
                                    decoration: InputDecoration(
                                      labelText: 'Time',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter a time';
                                      }
                                      return null; // Input Correct
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          initialValue: event.details,
                          decoration: InputDecoration(
                            labelText: 'Details',
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          minLines: 6,
                          maxLines: 10,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter the details of the event.';
                            }
                            return null; // Input Correct
                          },
                          onSaved: (value) => event.details = value,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
