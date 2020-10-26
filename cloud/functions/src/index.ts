import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

export const deleteUser = functions.auth.user().onDelete(async (user) => {
  try {
    await admin.firestore().collection("users").doc(user.uid).delete();
  } catch (error) {
    console.log(error);
  }
});

export const updateAttendeeStatus = functions.firestore
  .document("events/{docId}/attendees/{userId}")
  .onWrite(async (change, context) => {
    const userId = context.params.userId;
    const docId = context.params.docId;

    if (change !== null) {
      const { status } = change.after.data() ?? { status: null };

      const result = await admin
        .firestore()
        .collection("events")
        .doc(docId)
        .get();

      const { type } = result.data() ?? { type: null };

      if (type === "game") {
        if (status !== null) {
          await admin
            .firestore()
            .collection("users")
            .doc(userId)
            .update({ status: status });
        }
      }
    }
  });

/*Every monday delete any events that have already passed */
export const scheduledDelete = functions.pubsub
  .schedule("0 1 * * 1")
  .timeZone("Australia/Perth")
  .onRun(async (context) => {
    const dateNow = new Date().toISOString();
    const result = await admin
      .firestore()
      .collection("events")
      .where("date", "<", dateNow)
      .get();

    result.forEach(async (doc) => {
      try {
        await admin.firestore().collection("events").doc(doc.id).delete();
      } catch (error) {
        console.log("database error");
      }
    });

    return null;
  });

export const clearTeamList = functions.pubsub
  .schedule("0 1 * * 1")
  .timeZone("Australia/Perth")
  .onRun(async (context) => {
    await admin
      .firestore()
      .collection("teamList")
      .doc("1")
      .update({ players: [] });

    await admin
      .firestore()
      .collection("teamList")
      .doc("2")
      .update({ players: [] });

    await admin
      .firestore()
      .collection("teamList")
      .doc("3")
      .update({ players: [] });
  });
