import 'dart:async';
import 'package:bitirmece_test/backend/resultInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResultInfoFirebaseValues {
  static String newResultCount = 'newResultCount';
  static String timestamp = 'timestamp';
  static String data = 'data';
  static String isRead = "isRead";
}


late ResultInfoService userGlobalService;


class ResultInfoService {
  final String userUid;
  late final CollectionReference resultInfoInstance;
  late final CollectionReference resultsInstance;
  late final CollectionReference userInfoInstance;

  ResultInfoService({required this.userUid}) {
    resultInfoInstance = FirebaseFirestore.instance.collection('ResultInfo');
    resultsInstance = resultInfoInstance.doc(userUid).collection("Results");
    userInfoInstance = FirebaseFirestore.instance.collection("UserInfo");
  }


  Stream<DocumentSnapshot<Map<String, dynamic>>?>
      getResultInfoDocumentSnapshot() {
    return resultInfoInstance.doc(userUid).snapshots()
        as Stream<DocumentSnapshot<Map<String, dynamic>>?>;
  }

  Future<void> initializeResultInfo() async {
    try {
      resultInfoInstance
          .doc(userUid)
          .set({ResultInfoFirebaseValues.newResultCount: 0});
    } catch (e) {
      print('Error: $e');
      print("INITTE");
      print(userUid.toString());
    }
  }

  void resetNewResultCount() {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction
          .update(resultInfoInstance.doc(userUid), {"newResultCount": 0});
    }).catchError((error) {
      print('Failed: $error');
    }).whenComplete(() {
      print('Success');
    });
  }

  Future<void> deleteResult(ResultInfo result) async {
    try {
      resultsInstance.doc(result.id).delete();
      print('Notification is deleted!');
    } catch (e) {
      print('Error: $e');
    }
  }

  int _resultInfoCountsSnapshot(DocumentSnapshot snapshot) {
    int resultCount = 0;

    resultCount = snapshot.get(ResultInfoFirebaseValues.newResultCount);

    return resultCount;
  }

  Future <bool> readResult(ResultInfo resultInfo) async{
    await resultsInstance.doc(resultInfo.id).update({
      ResultInfoFirebaseValues.isRead : true
    });
    return true;
  }

  Future <bool> changeActiveUser(String userUid) async{
    await userInfoInstance.doc("userData").update({
      "activeUserUid" : userUid
    });
    return true;
  }

  Stream<int> get resultInfoCountsSnapshot {
    return resultInfoInstance
        .doc(userUid)
        .snapshots()
        .map(_resultInfoCountsSnapshot);
  }

  List<ResultInfo> _resultFromSnapshot(QuerySnapshot snapshot) {
    List<ResultInfo> temp = snapshot.docs
        .map((doc) => ResultInfo(
              timestamp: getDateTimeFromTimeStamp(doc.get(ResultInfoFirebaseValues.timestamp)),
              fruitData: getFruitMapFromDynamicMap(doc.get(ResultInfoFirebaseValues.data)),
              isRead: doc.get(ResultInfoFirebaseValues.isRead),
              id: doc.id,
            ))
        .toList();

    //sort list by date
    temp.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return temp;
  }

  //get database stream every time there is a change on it
  Stream<List<ResultInfo>> get resultListSnapshot {
    return resultsInstance.snapshots().map(_resultFromSnapshot);
  }
}
