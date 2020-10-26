import 'package:flutter/material.dart';
import 'package:goat_app/models/teamList.dart';
import 'package:goat_app/screens/teamlist/add_team_list_dialog.dart';
import 'package:goat_app/screens/teamlist/team_list_item.dart';
import 'package:goat_app/screens/teamlist/team_list_item_place_holder.dart';
import 'package:goat_app/utils/constants.dart';
import '../../services/database.dart';

class AddTeamList extends StatefulWidget {
  @override
  _AddTeamListState createState() => _AddTeamListState();
}

class _AddTeamListState extends State<AddTeamList> {
  bool isLoading = true;
  bool isInit = true;
  int _index = 0;

  List<Player> listOfPlayers = [];
  List<Player> listofSelectedPlayers = [];
  List<String> postions = [
    'Looshead Prop',
    'Hooker',
    'Tighthead Prop',
    'Lock (4)',
    'Lock (5)',
    'Flanker (6)',
    'Flanker (7)',
    'No. 8',
    'Scrum-Half',
    'Fly-Half',
    'Winger (11)',
    'Inside Center',
    'Outside Center',
    'Winger (14)',
    'Fullback',
    'Reserve (16)',
    'Reserve (17)',
    'Reserve (18)',
    'Reserve (19)',
    'Reserve (20)',
    'Reserve (21)',
    'Reserve (22)',
    'Reserve (23)',
    'Reserve (24)',
    'Reserve (25)',
  ];

  //Using the init state to create a list of default players
  @override
  void initState() {
    //Creates the default
    for (var i = 0; i < 25; i++) {
      listofSelectedPlayers.add(
        Player(
          isDefault: true,
          name: postions[i],
          // profileImage: defaultImageString,
          profileImage: defaultImage,
        ),
      );
    }

    isLoading = true;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      _index = 1 +
          _getIndex(); //as we want 1 to be prem grade 2 to be reserver 3 to be third
      _loadListOfPlayers();
      _loadListOfSelectedPlayers(_index);
      isInit = false;
    }

    super.didChangeDependencies();
  }

  int _getIndex() {
    return ModalRoute.of(context).settings.arguments as int;
  }

  /* Load List of players that can be selected for each team */
  Future<void> _loadListOfPlayers() async {
    listOfPlayers = await DatabaseService().playerList;
  }

  /* Load in the team list*/
  Future<void> _loadListOfSelectedPlayers(int index) async {
    List<Player> listFromDb =
        await DatabaseService().teamListSelectedGrade(index.toString());

    for (var i = 0; i < listFromDb.length; i++) {
      listofSelectedPlayers.insert(i, listFromDb[i]);
      listofSelectedPlayers.removeAt(i + 1);
    }

    setState(() {
      isLoading = false;
    });
  }

  // Take the data from that add dialog place it on the list of Selected Players
  // Insert the new player and delete the place holder
  void addPlayer(Player player, int index) {
    setState(() {
      listofSelectedPlayers.insert(index - 1, player);
      listofSelectedPlayers.removeAt(index);
    });
  }

  // When a icon is clicked the index is set.
  // This index is used to get the title so when the dialog box
  // is open you know which position you are assigning the player to.
  void setIndex(context, int index) {
    String title = postions[index - 1];

    showDialog<Null>(
      context: context,
      builder: (context) =>
          AddTeamListDialog(index, title, listOfPlayers, addPlayer),
    );
  }

  Future<void> _submit(context) async {
    setState(() {
      isLoading = true;
    });

    await DatabaseService()
        .updateTeamList(_index.toString(), listofSelectedPlayers);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            FlatButton(
              onPressed: () => _submit(context),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                children: [
                  //for loop here to create
                  for (var i = 0; i < listofSelectedPlayers.length; i++)
                    //Check to see if placeholde is requried
                    listofSelectedPlayers[i].isDefault
                        ? TeamListItemPlaceHolder(
                            i + 1, listofSelectedPlayers[i].name, setIndex)
                        : TeamListItem(
                            index: i + 1,
                            name: listofSelectedPlayers[i].name,
                            profileImage: listofSelectedPlayers[i].profileImage,
                            setIndex: setIndex)
                ],
              ));
  }
}
