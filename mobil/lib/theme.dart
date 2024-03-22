import 'package:flutter/material.dart';

late AppTheme CurrentAppTheme;

class AppTheme {
  double height = 0;
  double width = 0;

  AppTheme() {
    //EdgeInsets paddingInsets = WidgetsBinding.instance.window.; // MediaQuery.of(context).padding;
    var screenSize = WidgetsBinding.instance.window.physicalSize;
    var pixelRatio = WidgetsBinding.instance.window.devicePixelRatio;
    height = screenSize.height / pixelRatio;// - (paddingInsets.bottom + paddingInsets.top);
    width = screenSize.width / pixelRatio;// - (paddingInsets.left + paddingInsets.right);
  }

  double getWindowWidth() {
    return width;
  }

  double getWindowHeight() {
    return height;
  }
}
