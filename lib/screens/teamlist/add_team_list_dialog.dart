import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:goat_app/models/teamList.dart';
import 'package:goat_app/utils/constants.dart';

class AddTeamListDialog extends StatefulWidget {
  final int index;
  final String title;
  final List<Player> listOfPlayers;
  final Function addPlayer;
  AddTeamListDialog(this.index, this.title, this.listOfPlayers, this.addPlayer);

  @override
  _AddTeamListDialogState createState() => _AddTeamListDialogState();
}

class _AddTeamListDialogState extends State<AddTeamListDialog> {
  GlobalKey<AutoCompleteTextFieldState<Player>> key = new GlobalKey();
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(8.0),
      insetPadding: EdgeInsets.all(0),
      elevation: 0,
      title: Text(
        widget.title,
        textAlign: TextAlign.center,
      ),
      content: AutoCompleteTextField<Player>(
        key: key,
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Select Player',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        // This is what the appear when searching
        itemBuilder: (context, item) => ListTile(
          // Todo
          leading: item.status == 'available'
              ? Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 30,
                )
              : item.status == 'other'
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
          title: Text(item.name),
        ),

        itemFilter: (item, query) =>
            item.name.toLowerCase().startsWith(query.toLowerCase()),
        itemSorter: (a, b) {
          return a.name.compareTo(b.name);
        },
        itemSubmitted: (item) {
          widget.addPlayer(item, widget.index);

          Navigator.of(context).pop();
        },
        suggestions: widget.listOfPlayers,
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            widget.addPlayer(
                Player(
                  name: controller.value.text,
                  isDefault: true,
                  profileImage: defaultImage,
                ),
                widget.index);

            Navigator.of(context).pop();
          },
          child: Text('ADD'),
          color: Theme.of(context).primaryColor,
        )
      ],
    );
  }
}
