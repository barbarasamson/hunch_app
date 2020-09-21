
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:hunch_app/models/significance.dart';

class ControlsBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  ControlsBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory ControlsBarChart.fromData(Significance sig, int myScore) {
    return new ControlsBarChart(
      _createData(sig, myScore),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalControls, String>> _createData(Significance sig, int myScore) {
    Map<int, int> sigData = sig.getOrderedControlData();
    if (sigData.containsKey(myScore)) {
      sigData.update(myScore, (int) => sigData[myScore] + 1);
    } else {
      sigData[myScore] = 1;
    }
    var sortedKeys = sigData.keys.toList()..sort();

    final List<OrdinalControls> ordinalRolls = List<OrdinalControls>();
    for(int i = 0; i < sortedKeys.length; i++) {
      int k = sortedKeys[i];
      ordinalRolls.add(OrdinalControls(k, sigData[k]));
    }

    return [
      new charts.Series<OrdinalControls, String>(
        id: 'Control Rolls',
        fillColorFn: (index, __) {
          if (index.number_correct_guesses == myScore) {
            return charts.MaterialPalette.red.shadeDefault;
          }
          return charts.MaterialPalette.blue.shadeDefault;
        },
        colorFn: (index, __) {
          return charts.MaterialPalette.blue.shadeDefault;
        },
        domainFn: (OrdinalControls rolls, _) => rolls.number_correct_guesses.toString(),
        measureFn: (OrdinalControls rolls, _) => rolls.amount,
        data: ordinalRolls,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalControls {
  final int number_correct_guesses;
  final int amount;

  OrdinalControls(this.number_correct_guesses, this.amount);
}