import 'package:flutter/material.dart';
import 'dart:math';

List<Color> allColors = [
  Colors.deepPurple,
  Colors.yellow,
  Colors.green,
  Colors.lightGreen,
  Colors.blue,
  Colors.indigo,
  Colors.cyan,
  Colors.amber,
  Colors.orange,
  Colors.red,
];

List<Color> allFrames = [
  Colors.deepPurpleAccent,
  Colors.yellowAccent,
  Colors.greenAccent,
  Colors.lightGreenAccent,
  Colors.cyanAccent,
  Colors.blueAccent,
  Colors.cyanAccent,
  Colors.orangeAccent,
  Colors.redAccent,
  Colors.orangeAccent,
];


class ColorModel {
  final List<Color> _colors = List<Color>();
  final List<Color> _frames = List<Color>();

  ColorModel(int howMany) {
    Random _random = Random(DateTime.now().millisecondsSinceEpoch);
    int numColors = howMany.clamp(0, allColors.length);
    List<int> picked = [];
    while (picked.length < numColors) {
      int pick = _random.nextInt(allColors.length);
      if (!picked.contains(pick)) {
        _colors.add(allColors[pick]);
        _frames.add(allFrames[pick]);
        picked.add(pick);
      }
    }
  }

  int get length {
    return _colors.length;
  }

  Color getColor(int position) {
    if (position <= 0) return Colors.transparent;
    assert(position <= _colors.length);
    return _colors[position - 1];
  }

  Color getFrame(int position) {
    if (position <= 0) return Colors.transparent;
    assert(position <= _frames.length);
    return _frames[position - 1];
  }
}
