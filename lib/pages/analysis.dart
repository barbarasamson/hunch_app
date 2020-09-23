import 'package:flutter/material.dart';

class AnalysisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    void _onItemTapped(int index) {
      switch(index) {
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
        title: Text("Second Screen"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first screen when tapped.
          },
          child: Text('Go back!'),
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
        onTap: _onItemTapped,
      ),
    );
  }
}