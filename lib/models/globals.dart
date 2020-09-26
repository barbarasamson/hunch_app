import 'package:flutter/material.dart';

import 'package:hunch_app/models/colors.dart';
import 'package:hunch_app/models/analysis.dart';

class Global {

  static final Global _global = Global.internal();

  ColorModel colorModel = ColorModel(4);
  final List rolls = List<int>();
  final List guesses = List<int>();
  final List guessRights= List<bool>();

  factory Global() {
    return _global;
  }

  Global.internal();

}