import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void showLoading() {
  EasyLoading.instance
    ..loadingStyle =EasyLoadingStyle.custom
    ..backgroundColor = Colors.lightBlueAccent
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..indicatorSize = 50.0
    ..indicatorType = EasyLoadingIndicatorType.wave
    ..radius = 10.0
    ..dismissOnTap = false
  ..userInteractions = false;
  EasyLoading.show(
    maskType: EasyLoadingMaskType.black,
    status: 'loading',
  );
}

void hideLoading() {
  EasyLoading.dismiss();
}
