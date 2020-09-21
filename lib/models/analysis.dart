import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter/cupertino.dart';

import 'colors.dart';

class RollsBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  RollsBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory RollsBarChart.fromData(List<int> rolls, ColorModel colorModel) {
    return new RollsBarChart(
      _createData(rolls, colorModel),
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
  static List<charts.Series<OrdinalRolls, String>> _createData(List<int> rolls, ColorModel colorModel) {

    List<int> domain = List.filled(colorModel.length+1, 0); // enables us to count from 1
    for(int i = 0; i < rolls.length; i++) {
      assert (rolls[i] <= domain.length);
      domain[rolls[i]]++;
    }

    final List<OrdinalRolls> ordinalRolls = List<OrdinalRolls>();
    for(int i = 1; i < rolls.length; i++) {
      ordinalRolls.add(OrdinalRolls(i, rolls[i], colorModel.getColor(i)));
    }

    return [
      new charts.Series<OrdinalRolls, String>(
        id: 'Control Rolls',
        fillColorFn: (index, __) {
          var color = index.myColor;
            return charts.Color(
                r: color.red,
                g: color.green,
                b: color.blue,
                a: color.alpha);
          },
        colorFn: (index, __) {
          return charts.MaterialPalette.blue.shadeDefault;
        },
        domainFn: (OrdinalRolls rolls, _) => rolls.amount.toString(),
        measureFn: (OrdinalRolls rolls, _) => rolls.amount,
        data: ordinalRolls,
      )
    ];
  }
}

class OrdinalRolls {
  final int rollNumber;
  final int amount;
  final Color myColor;

  OrdinalRolls(this.rollNumber, this.amount, this.myColor);
}