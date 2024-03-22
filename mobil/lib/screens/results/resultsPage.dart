import 'package:bitirmece_test/screens/signIn/signInPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bitirmece_test/theme.dart';
import 'package:provider/provider.dart';
import '../../backend/resultInfo.dart';
import '../../backend/resultInfoService.dart';
import 'lastResultPopUp.dart';

List<ResultInfo> results = [
  ResultInfo(timestamp: DateTime.now(), fruitData: {
    ObjectType.orange: 1,
    ObjectType.apple: 1,
    ObjectType.banana: 1
  }),
  ResultInfo(
      timestamp: DateTime.fromMillisecondsSinceEpoch(1000000),
      fruitData: {
        ObjectType.orange: 2,
        ObjectType.apple: 1,
        ObjectType.banana: 0
      }),
  ResultInfo(
      timestamp: DateTime.fromMillisecondsSinceEpoch(1060000),
      fruitData: {
        ObjectType.orange: 0,
        ObjectType.apple: 3,
        ObjectType.banana: 0
      }),
  ResultInfo(
      timestamp: DateTime.fromMillisecondsSinceEpoch(1020000),
      fruitData: {
        ObjectType.orange: 1,
        ObjectType.apple: 1,
        ObjectType.banana: 1
      }),
];

class ResultsPage extends StatefulWidget {
  ResultsPage();

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

List<ResultInfo> currentResultInfoList = [];
int currentResultCount = 0;

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet: Container(
          height: CurrentAppTheme.height * 0.1,
          child: GestureDetector(
            onTap: () {
            FirebaseAuth _auth = FirebaseAuth.instance;
            _auth.signOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
                (route) => false);
          },
            child: Center(
              child: Text("Sign Out", style: TextStyle(color: Colors.red)),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Container(
              margin: EdgeInsets.all(CurrentAppTheme.height * 0.05),
              height: CurrentAppTheme.height * 0.2,
              child: Center(
                child: Text(
                  "Detection Results",
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ),
        body: StreamBuilder<List<ResultInfo>>(
            stream: userGlobalService.resultListSnapshot,
            builder: (context, listSnapshot) {
              return StreamBuilder<int>(
                  stream: userGlobalService.resultInfoCountsSnapshot,
                  builder: (context, countSnapshot) {
                    if (ConnectionState.active == listSnapshot.connectionState &&
                        ConnectionState.active == countSnapshot.connectionState) {
                      if (!countSnapshot.hasError &&
                          countSnapshot.hasData &&
                          !listSnapshot.hasError &&
                          listSnapshot.hasData) {
                        print("RESULTS PAGE REBUILD:" + countSnapshot.data.toString());

                        currentResultInfoList = listSnapshot.data!;
                        return getResultsPart(currentResultInfoList);
                      } else {
                        final error = listSnapshot.error.toString() +
                            "  " +
                            countSnapshot.error.toString();
                        return Text('$error');
                      }
                    }

                    return getResultsPart(currentResultInfoList);
                  });
            }),
      ),
    );
  }

  Container getResultsPart(List<ResultInfo> _resultInfo) {

    return Container(
      height: CurrentAppTheme.height * 0.8,
      child: Column(
        children: [
          Container(
              height: CurrentAppTheme.height * 0.05,
              margin: EdgeInsets.only(top: 10),
              child: Text("Results:",
                  style: TextStyle(color: Colors.blue, fontSize: 20))),
          Container(
            height: CurrentAppTheme.height * 0.7,
            margin: EdgeInsets.only(
                top: 10,
                left: CurrentAppTheme.width * 0.1,
                right: CurrentAppTheme.width * 0.1),
            child: ListView.builder(
              itemCount: _resultInfo.length,
              itemBuilder: (context, index) {
                if ((_resultInfo.length - index) % 5 == 0) {
                  return Container(
                    child: Column(
                      children: [
                        Divider(),
                        resultListTile(context, _resultInfo[index], _resultInfo.length - index - 1)
                      ],
                    ),
                  );
                }
                return resultListTile(context, _resultInfo[index], _resultInfo.length - index - 1);
              },
            ),
          ),
        ],
      ),
    );
  }
}

ListTile resultListTile(context, ResultInfo result, int resultNo) {

  return ListTile(
    onTap: () async {
      userGlobalService.readResult(result);
      await showResult(context, result);
    },
    leading: Icon(
      Icons.shopping_basket_outlined,
      color: Colors.green,
    ),
    trailing: Container(
      width: CurrentAppTheme.width*0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(DateFormat('HH:mm').format(result.timestamp)),
         result.isRead ? Container() : Icon(
            Icons.circle,
            color: Colors.red,
            size: CurrentAppTheme.width*0.03,
          )
        ],
      ),
    ),
    title: Text("No: " + (resultNo + 1).toString()),
  );
}
