class Event {
  String id;
  String title;
  String type;
  String details;
  DateTime date;
  String authorUid;
  List<Attendee> attendees;

  Event({
    this.id,
    this.title,
    this.type,
    this.details,
    this.date,
    this.authorUid,
    this.attendees,
  });

  int get numAvailable {
    int numAvailable = 0;
    attendees.forEach((attendee) {
      if (attendee.isAvailable()) numAvailable++;
    });
    return numAvailable;
  }

  int get numNotAvailable {
    int numNotAvailable = 0;
    attendees.forEach((attendee) {
      if (attendee.isNotAvailable()) numNotAvailable++;
    });
    return numNotAvailable;
  }

  int get numOther {
    int numOther = 0;
    attendees.forEach((attendee) {
      if (attendee.isOther()) numOther++;
    });
    return numOther;
  }

  String currentUserStatus(String id) {
    for (var atendee in attendees) {
      if (atendee.uid == id) {
        return atendee.status;
      }
    }
    return null;
  }

  String currentUserReason(String id) {
    for (var atendee in attendees) {
      if (atendee.uid == id) {
        return atendee.reason;
      }
    }
    return null;
  }
}

class Attendee {
  String uid;
  String name;
  String status;
  String reason;

  Attendee({this.uid, this.name, this.reason, this.status});

  bool isAvailable() {
    return status == 'available' ? true : false;
  }

  bool isNotAvailable() {
    return status == 'injured' || status == 'unavailable' ? true : false;
  }

  bool isOther() {
    return status == 'other' ? true : false;
  }
}
