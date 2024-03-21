import 'package:flutter/material.dart';
import 'package:test_ar/augmented_reality.dart';

Widget imageWidget(BuildContext context, bool isScreenShotRunning) {
  return SizedBox(
    height: MediaQuery.sizeOf(context).height,
    child: AugmentedRealityPlugin(
        'https://w7.pngwing.com/pngs/955/626/png-transparent-men-s-blue-dress-shirt-and-blue-and-gray-necktie-t-shirt-dress-shirt-suit-necktie-t-shirt-blue-electric-blue-formal-wear.png',isScreenShotRunning),
  );
}