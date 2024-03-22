import 'package:bitirmece_test/backend/resultInfoService.dart';
import 'package:flutter/material.dart';

import '../../backend/resultInfo.dart';
import '../../theme.dart';

Future<dynamic> showResult(context, ResultInfo result) {
  Map<ObjectType, int> fruits = {};
  Map<ObjectType, int> others = {};
  double fruitsHeight = CurrentAppTheme.height * 0.05;
  double othersHeight = CurrentAppTheme.height * 0.05;
  int fruitCount = 0;

  result.fruitData.forEach((key, value) {
    if (key.index < ObjectType.fruit.index) {
      if (value != 0) {
        fruits[key] = value;
        fruitCount = fruitCount + value;
        fruitsHeight = fruitsHeight + CurrentAppTheme.height * 0.025;
      }
    }
  });
  if (fruitCount < 3 && fruitCount != 0) {
    others[ObjectType.unknown] = 3 - fruitCount;
  }
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.white,
          child: Container(
            height: fruitsHeight + othersHeight + CurrentAppTheme.height * 0.2,
            width: CurrentAppTheme.width,
            child: Center(
              child: Container(
                width: CurrentAppTheme.width * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: CurrentAppTheme.height * 0.05,
                      alignment: Alignment.bottomCenter,
                      child: Text("Results:",
                          style: TextStyle(color: Colors.blue, fontSize: 20)),
                    ),
                    Divider(),
                    fruits.isNotEmpty ? Container(
                      height: fruitsHeight,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          if (fruits.values.toList()[index] != 0) {
                            return getFruitDataRow(fruits.keys.toList()[index],
                                fruits.values.toList()[index]);
                          } else {
                            return Container();
                          }
                        },
                        itemCount: fruits.length,
                      ) ,
                    ) : Container(child: Center(child: Text("Empty Box", style: TextStyle(fontSize: 16)),),),
                    others.isNotEmpty ? Divider() : Container(),
                    others.isNotEmpty
                        ? Container(
                            height: othersHeight,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return getFruitDataRow(
                                    others.keys.toList()[index],
                                    others.values.toList()[index]);
                              },
                              itemCount: others.length,
                            ),
                          )
                        : Container(),
                    IconButton(
                      onPressed: () async {
                        print("siliniyorr");
                        await userGlobalService.deleteResult(result);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.cancel_outlined),
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

Container getFruitDataRow(ObjectType object, int count) {
  return Container(
    child: Row(
      children: [
        Text(count.toString() + " ",
            style: TextStyle(color: Colors.black, fontSize: 16)),
        Text(FruitNamesToShow[object]!,
            style: TextStyle(color: Colors.red, fontSize: 16)),

      ],
    ),
  );
}
