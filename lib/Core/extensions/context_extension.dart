import 'dart:math';

import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  void unFocusKeyBoard() => FocusScope.of(this).unfocus();

  dynamic get getArgument => ModalRoute.of(this)?.settings.arguments;

  TextTheme get appTextTheme => Theme.of(this).textTheme;

  Color get primaryColor => Theme.of(this).primaryColor;

  double get screenHeight => MediaQuery.of(this).size.height;

  double get screenWidth => MediaQuery.of(this).size.width;

  Size get screenSize => MediaQuery.of(this).size;

  double get minScreenSize =>
      min(MediaQuery.of(this).size.height, MediaQuery.of(this).size.width);

  double get maxScreenSize =>
      max(MediaQuery.of(this).size.height, MediaQuery.of(this).size.width);
}
