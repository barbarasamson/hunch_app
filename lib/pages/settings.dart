import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    void _onItemTapped(int index) {
      switch(index) {
        case 1:
          Navigator.pop(context);
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/analysis');
          break;
        case 0:
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
        currentIndex: 0,
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