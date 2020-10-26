import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goat_app/models/teamList.dart';
import 'package:goat_app/utils/constants.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../models/event.dart';

class DatabaseService {
  //collection Refferences
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  final CollectionReference teamListCollection =
      FirebaseFirestore.instance.collection('teamList');

  /* Maps the input from the database into the UserData Model */
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: snapshot.id,
      email: snapshot.data()['email'],
      name: snapshot.data()['name'],
      type: snapshot.data()['type'],
      isAdmin: snapshot.data()['isAdmin'],
      isVerified: snapshot.data()['isVerified'],
      games: snapshot.data()['games'],
      profileImage:
          base64.decode(snapshot.data()['image'] ?? defaultImageString),
    );
  }

  /* Realtime data stream from the database this returns the User Data which
  could be considered the "profile" of the user */
  Stream<UserData> userData(String uid) {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  /*Register a user this is called automatically in the Register Function in
  the auth service. This is required because we want an user in the auth table 
  but also require extra fields to handle additional information */
  Future registerUser(UserData user) {
    return userCollection.doc(user.uid).set({
      'email': user.email ?? 'User Email',
      'name': user.name ?? 'User Name',
      'type': user.type ?? 'player',
      'games': user.games ?? 0,
      'isAdmin': user.isAdmin ?? false,
      'isVerified': user.isVerified ?? false,
      'image': defaultImageString
    });
  }

  /* Formats the data recieved from the database into a List of Posts*/
  List<Post> _postsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Post(
        id: doc.id,
        authorName: doc.data()['authorName'] ?? '',
        authorUid: doc.data()['authorUid'] ?? '',
        content: doc.data()['content'] ?? '',
        date: DateTime.parse(doc.data()['date']),
      );
    }).toList();
  }

  /*Gets the posts information from the database in a live stream format */
  Stream<List<Post>> get postData {
    return postCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map(_postsListFromSnapshot);
  }

  /* Add a post to the database */
  Future addPost(UserData user, String content, DateTime date) async {
    try {
      await postCollection.add({
        'authorName': user.name,
        'authorUid': user.uid,
        'content': content,
        'date': DateTime.now().toIso8601String(),
      });
    } catch (error) {
      print(error);
    }
  }

  /*Update a post to the database */
  Future updatePost(String id, String content) async {
    try {
      await postCollection.doc(id).update({'content': content});
    } catch (error) {
      print(error);
    }
  }

  /*Delete a post */
  Future deletePost(String id) async {
    try {
      await postCollection.doc(id).delete();
    } catch (error) {
      print(error);
    }
  }

  /*Event Collection Formatter */
  List<Event> _eventListSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Event(
        id: doc.id,
        title: doc.data()['title'] ?? 'title',
        details: doc.data()['details'] ?? 'details',
        type: doc.data()['type'] ?? 'type',
        authorUid: doc.data()['authorUid'] ?? '',
        date: DateTime.parse(doc.data()['date']),
        attendees: [],
      );
    }).toList();
  }

  /*Get list of events in real time from database in a live stream format */
  Stream<List<Event>> get eventData {
    return eventCollection
        .orderBy('date', descending: false)
        // .where('date', isGreaterThanOrEqualTo: DateTime.now().toIso8601String())
        .snapshots()
        .map(_eventListSnapshot);
  }

  /*Format Attendee data from the database */
  List<Attendee> _attendeeSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Attendee(
        uid: doc.id,
        name: doc.data()['name'] ?? 'name',
        reason: doc.data()['reason'] ?? 'reason',
        status: doc.data()['status'] ?? 'status',
      );
    }).toList();
  }

  /* Get the list of attendees fro an event */
  Stream<List<Attendee>> attendeeData(id) {
    return eventCollection
        .doc(id)
        .collection('attendees')
        .snapshots()
        .map(_attendeeSnapShot);
  }

  /*Add event to database */
  Future addEvent(Event event) async {
    try {
      await eventCollection.add({
        'title': event.title,
        'authorUid': event.authorUid,
        'date': event.date.toIso8601String(),
        'details': event.details,
        'type': event.type,
      });
    } catch (error) {
      print('Add event error');
      print(error);
    }
  }

  /*Update Event*/
  Future updateEvent(Event event) async {
    await eventCollection.doc(event.id).update({
      'title': event.title,
      'authorUid': event.authorUid,
      'date': event.date.toIso8601String(),
      'details': event.details,
      'type': event.type,
    });
  }

  /*Update Atendee Status for an event*/
  Future updateAtendee(
    String eventId,
    String attendeeId,
    String name,
    String status,
    String reason,
  ) async {
    try {
      await eventCollection
          .doc(eventId)
          .collection('attendees')
          .doc(attendeeId)
          .set({
        'name': name,
        'status': status,
        'reason': reason,
      });
    } catch (error) {
      print('update attendee');
      print(error);
    }
  }

  //*Delete Event */
  Future deleteEvent(String id) async {
    try {
      await eventCollection.doc(id).delete();
    } catch (error) {
      print('delete attendee');
      print(error);
    }
  }

  /* Team List Stream*/
  List<TeamList> _teamListSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TeamList(
        grade: doc.id,
        players: doc
                .data()['players']
                .map(
                  (player) => Player(
                    id: player['id'] ?? 'No Id',
                    name: player['name'] ?? 'No Name',
                    isDefault: false,
                    status: player['status'] ?? 'No Status',
                    profileImage:
                        base64.decode(player['image'] ?? defaultImageString),
                  ),
                )
                .toList() ??
            [],
      );
    }).toList();
  }

  Stream<List<TeamList>> get teamListData {
    return teamListCollection.snapshots().map(_teamListSnapshot);
  }

  /*Get the players on the current team list for premier grade.
    this is only used in the case of editing  the team list  */
  Future<List<Player>> teamListSelectedGrade(String grade) async {
    DocumentSnapshot result = await teamListCollection.doc(grade).get();

    List temp = result.data()['players'];

    return temp
        .map((player) => Player(
              id: player['id'] ?? 'No Id',
              name: player['name'] ?? 'No Name',
              isDefault: player['isDefault'] ?? true,
              // profileImage: player['image'] ?? defaultImageString,
              profileImage: base64.decode(player['image']) ?? defaultImage,
            ))
        .toList();
  }

  /* Add or update the teamlist */
  Future<void> updateTeamList(String grade, List<Player> players) async {
    try {
      await teamListCollection.doc(grade).set({
        'players': players
            .map((player) => {
                  "id": player.id,
                  "name": player.name,
                  "isDefault": player.isDefault,
                  "image": base64.encode(player.profileImage)
                })
            .toList(),
      });
    } catch (error) {
      print('update team list error');
    }
  }

  /*Get the player list this will be used for the drop down menu 
    when searching for players */
  Future<List<Player>> get playerList async {
    try {
      var result = await userCollection.get();
      return result.docs
          .map((player) => Player(
                id: player.id,
                name: player.data()['name'] ?? 'No Name',
                isDefault: false,
                status: player.data()['status'] ?? "other",
                profileImage:
                    base64.decode(player.data()['image']) ?? defaultImage,
              ))
          .toList();
    } catch (error) {
      return [];
    }
  }
}
