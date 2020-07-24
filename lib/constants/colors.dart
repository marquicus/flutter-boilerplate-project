import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // this basically makes it so you can't instantiate this class

  static const Map<int, Color> orange = const <int, Color>{
    100: const Color(0xFFFCF2E7),
    200: const Color(0xFFE69138),
    300: const Color(0xFFD56217)
  };

  static const Map<int, Color> blue = const <int, Color>{
    100: const Color(0xffccccff),
    200: const Color(0xff3E96DB),
    300: const Color(0xff4f81bd)
  };

  static const Map<int, Color> grey = const <int, Color>{
    100: const Color(0xffd9d9d9),
    200: const Color(0xff968c8c),
    300: const Color(0xff62686c)
  };
}
