import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Significance {
  static int NUM_CONTROLS = 100;

  List<int> control_correct_guesses = new List(NUM_CONTROLS);
  //List<int> control_incorrect_guesses = new List(NUM_CONTROLS);

  List<Random> control_randoms = new List(NUM_CONTROLS);

  Significance() {
    var now = new DateTime.now();
    int seed = now.millisecondsSinceEpoch;
    for (int i = 0; i < NUM_CONTROLS; i++) {
      control_randoms[i] = Random(seed++);
      control_correct_guesses[i] = 0;
      //control_incorrect_guesses[i] = 0;
    }
  }

//note that rolls are from 1 to num_choices, not starting at 0
  int getPValue(int num_choices, int roll, bool guess_true, int score) {
    //print("getPValue: roll: $roll guess_true: $guess_true score: $score");
    int p_value = 0;
    int neg_p_value = 0;
    for (int i = 0; i < NUM_CONTROLS; i++) {
      int control_roll = (control_randoms[i].nextInt(num_choices) + 1);
      if (((control_roll == roll) && guess_true) ||
          ((control_roll != roll) && !guess_true)) {
        control_correct_guesses[i]++;
      }

      if (control_correct_guesses[i] == score) {
        p_value++;
        neg_p_value--;
      } else if (control_correct_guesses[i] > score) {
        p_value++;
      } else {
        neg_p_value--;
      }
    }
    if (p_value.abs() <= neg_p_value.abs()) {
      return p_value;
    } else {
      return neg_p_value;
    }
  }

  Map<int, int> getOrderedControlData() {
    Map<int, int> valuesMap = Map();
    for (int i = 0; i < NUM_CONTROLS; i++) {
      int value = control_correct_guesses[i];
      if (valuesMap.containsKey(value)) {
        valuesMap.update(value, (int) => valuesMap[value] + 1);
      } else {
        valuesMap[value] = 1;
      }
    }
    return valuesMap;
  }
}
