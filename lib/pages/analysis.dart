import 'package:flutter/material.dart';
import 'package:hunch_app/models/analysis.dart';
import 'package:hunch_app/models/colors.dart';
import 'package:hunch_app/models/simpleBarChart.dart';
import 'package:hunch_app/models/globals.dart';

abstract class AnalysisListItem {
  Widget buildImage(BuildContext context);
  Widget buildTitle(BuildContext context);
  Widget buildSubtitle(BuildContext context);
  Widget buildAll(BuildContext context);
}

class AnalysisHeading implements AnalysisListItem {
  String heading;

  AnalysisHeading(this.heading);

  @override
  Widget buildAll(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
    child:
    buildTitle(context),
    );
  }

  @override
  Widget buildImage(BuildContext context) => null;

  @override
  Widget buildSubtitle(BuildContext context) => null;

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
    );
  }
}

class AnalysisGraphic implements AnalysisListItem {
  Widget graphic;
  String title;
  String subtitle;

  AnalysisGraphic(this.graphic, this.title, {this.subtitle});

  @override
  Widget buildAll(BuildContext context) {
    return Column(
      children: [
      buildImage(context),
      buildTitle(context),
        if (subtitle != null) buildSubtitle(context),
      ],
    );
  }

  @override
  Widget buildImage(BuildContext context) {
    return Container(
      height: 100,
      child: Center(
        child: graphic,
      ),
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) {
    if (subtitle != null) {
      return Text(subtitle);
    }
    return null;
  }

  @override
  Widget buildTitle(BuildContext context) => Text(title);
}

List<AnalysisListItem> buildItems() {
  Global global = Global();
  List<AnalysisListItem> items = List();
  /*
  items.add(AnalysisHeading("Checking the graph function"));
  items.add(AnalysisGraphic(
    RollsBarChart.fromData(List.of([1, 2, 3, 4, 1, 2, 3, 4]), global.colorModel),
      "1 2 3 4"));*/

  items.add(AnalysisHeading("Rolls Analysis"));
  items.add(AnalysisGraphic(
      RollsBarChart.fromData(global.rolls, global.colorModel),
      "Distribution of Rolls"));
  items.add(AnalysisHeading("Guess Analysis"));
  items.add(AnalysisGraphic(
      RollsBarChart.fromData(global.guesses, global.colorModel),
      "Distribution of Guesses"));
  return items;
}

class AnalysisScreen extends StatelessWidget {
  Global global = Global();
  final List<AnalysisListItem> items = buildItems();

  @override
  Widget build(BuildContext context) {
    void _onNavTapped(int index) {
      switch (index) {
        case 1:
          Navigator.pop(context);
          break;
        case 0:
          Navigator.pushReplacementNamed(context, '/settings');
          break;
        case 2:
        default:
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Intuition - Analysis"),
      ),
      body: Card(
        clipBehavior: Clip.antiAlias,
        child: ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: items.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = items[index];

            return item.buildAll(context);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.settings),
            title: new Text("Settings"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.apps),
            title: new Text("Play"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.all_inclusive),
            title: new Text("Analysis"),
          )
        ],
        onTap: _onNavTapped,
      ),
    );
  }
}
