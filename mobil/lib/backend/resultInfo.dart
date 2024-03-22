import 'package:bitirmece_test/backend/resultInfoService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


enum ObjectType { apple, orange, banana, carrot, broccoli, fruit, unknown}

Map<ObjectType, String> FruitNamesToShow = {
  ObjectType.apple: "Apple",
  ObjectType.orange: "Orange",
  ObjectType.banana: "Banana",
  ObjectType.broccoli: "Broccoli",
  ObjectType.carrot : "Carrot",
  ObjectType.unknown : "Unknown Object"
};

Map<String, ObjectType> ObjectTypeFromFirebaseStr = {
  "apple": ObjectType.apple,
  "orange": ObjectType.orange,
  "banana": ObjectType.banana,
  "broccoli": ObjectType.broccoli,
  "carrot": ObjectType.carrot,
  "unknown": ObjectType.unknown
};


class ResultInfo {
  String id;
  DateTime timestamp;
  Map<ObjectType, int> fruitData;
  bool isRead;

  ResultInfo({required this.timestamp, required this.fruitData, this.id = "", this.isRead = false});
}

Map<ObjectType, int> getFruitMapFromDynamicMap(
    Map<String, dynamic> firebaseMap) {
  Map<ObjectType, int> retVal = {};

  firebaseMap.forEach((fruitName, fruitCount) {
    ObjectType? type = ObjectTypeFromFirebaseStr[fruitName];
    if (type != null) {
      retVal[type] = fruitCount;
    } else {

      //other objects
    }
  });
  return retVal;
}

DateTime getDateTimeFromTimeStamp(Timestamp timestamp) {
  DateTime? tryParseResult = DateTime.tryParse(timestamp.toDate().toString());
  if (tryParseResult != null) return tryParseResult;
  return DateTime(2023);
}

String getDateTimeText(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
}
