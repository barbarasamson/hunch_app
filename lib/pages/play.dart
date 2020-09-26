import 'dart:collection';
import 'package:hunch_app/models/simpleBarChart.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:hunch_app/models/colors.dart';
import 'package:hunch_app/models/significance.dart';
import 'package:hunch_app/models/globals.dart';
import 'package:vibration/vibration.dart';


import 'dart:math';

import 'package:provider/provider.dart';

Global global = Global();
bool _guessTrue = true;
int rolled = 0;
//double _score = 0.0;
int _intScore = 0;
double _raw_score = 0.0;
String sig_text = "";
//double _c2_score = 0.0;
HashMap<int, AnimationController> controllers = HashMap();
Significance sig = Significance();
bool canVibrate;

const int CORRECT_RESULT = 0; //column 0
const int INCORRECT_RESULT = 1; // column 1
const int RIGHT_GUESS = 0; // row 0
const int WRONG_GUESS = 1; // row 1
const int NEITHER_GUESS = 2; // row 2

Roller _roller = Roller();


void resetControllers() {
  if (controllers?.isNotEmpty ?? false) {
    controllers.forEach((key, value) {
      if (value.isAnimating) {
        value.reset();
      }
    });
  }
}

class Roller extends ChangeNotifier {
  void roll(int guess) {
    double p = (1 / GuessButton.numButtons);
    GuessButtonState.rollbegins = true;
    var now = DateTime.now();
    int seed = now.millisecondsSinceEpoch;
    Random random = Random(seed);
    rolled = random.nextInt(GuessButton.numButtons) + 1;
    global.guesses.add(guess);
    global.rolls.add(rolled);
    global.guessRights.add(_guessTrue);
    if (rolled == guess) {
      _raw_score++;
    }
    if ((_guessTrue && (rolled == guess)) || (!_guessTrue && (rolled != guess))) {
      _intScore++;
    }

    int pvalue = sig.getPValue(4, rolled, _guessTrue, _intScore);
    if (pvalue.abs() > 20) {
      sig_text = "Results about average";
    } else if (pvalue < 0) {
      sig_text = "${pvalue.abs()} % of controls scored as poorly as you";
    } else {
      sig_text = "$pvalue % of controls scored as well as you";
    }
    notifyListeners();
  }

  void clear() {
    sig = Significance();
    rolled = 0;
    _intScore = 0;
    _raw_score = 0;
    global.guesses.clear();
    global.rolls.clear();
    controllers.clear();
    notifyListeners();
  }
}


class PlayScreen extends StatefulWidget {
  PlayScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  Choice _selectedChoice = choices[2]; // The app's "state".
  int _selectedIndex = 1;

  void _select(Choice choice) {
    resetControllers();
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
      global.colorModel = ColorModel(choice.numGuessBoxes);
      _roller.clear();
    });
  }

  void _onItemTapped(int index) {

    switch(index) {
      case 0:
        Navigator.pushNamed(context, '/settings');
        break;
      case 2:
        Navigator.pushNamed(context, '/analysis');
        break;
      case 1:
      default:
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        //title: Text(widget.title),
        title: Text("Intuition"),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () {
              _roller.clear();
            },
          ),
          PopupMenuButton<Choice>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.skip(1).map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              }),
        ],
      ),
      body: ChangeNotifierProvider(
    create: (context) => _roller,
    child:

    Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Consumer<Roller>(
              builder: (BuildContext context, Roller value, Widget child) {
                return Result();
              },
            ),
          ),
          Expanded(
              flex: 3,
              child: Center(
                child: Consumer<Roller>(
                  builder: (BuildContext context, Roller value, Widget child) {
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: GridView.count(
                        crossAxisCount: _selectedChoice.crossAxisCount ?? 2,
                        children: GuessButton.createButtons(
                            _selectedChoice.numGuessBoxes),
                      ),
                    );
                  },
                ),
              )),
          Expanded(flex: 1, child: RightWrong()),
        ],
      ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
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

class Result extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ResultState();
  }
}

class ResultState extends State {
  static NumberFormat f1 = NumberFormat("#####.##", "en_US");
  static NumberFormat f2 = NumberFormat("####.#", "en_US");

  @override
  Widget build(BuildContext context) {
    //double p_value = prob();
    List<Widget> collateResults() {
      GridTile tile(int rollOrGuess) {
        return GridTile(
          child: Container(
              width: 1, height: 1, color: global.colorModel?.getColor(rollOrGuess)),
        );
      }

      List<Widget> results = [];
      if (global.rolls.isEmpty) results.add(tile(0));
      assert(global.rolls.length == global.guesses.length);
      for (int i = 0; i < global.rolls.length; i++) {
        results.insert(0, tile(global.guesses[i]));
        results.insert(0, tile(global.rolls[i]));
      }
      return results;
    }

    return Center(
      child: Column(children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          height: 45,
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: GridView.count(
            crossAxisCount: 2,
            scrollDirection: Axis.horizontal,
            children: collateResults(),
          ),
        ),
        Expanded(
          child: Center(
            child: ControlsBarChart.fromData(sig, _intScore),
            /*child: Row(
            children: <Widget>[
          //    Text("  raw score: "),
          //    Text(
          //      f1.format(_raw_score),
          //      textScaleFactor: 2,
          //    ),
              Text("     score: "),
              Text(
                f1.format(_intScore),
                textScaleFactor: 2,
              ),
              Text("   $sig_text"),

            ],
          )*/),
        ),
      ]),
    );
  }
}

class Choice {
  const Choice(
      {this.title, this.icon, this.numGuessBoxes, this.crossAxisCount});
  final String title;
  final IconData icon;
  final int numGuessBoxes;
  final int crossAxisCount;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Clear All', icon: Icons.clear_all),
  const Choice(title: 'Two Guesses', numGuessBoxes: 2, crossAxisCount: 2),
  const Choice(title: 'Four Guesses', numGuessBoxes: 4, crossAxisCount: 2),
  const Choice(title: 'Six Guesses', numGuessBoxes: 6, crossAxisCount: 3),
  const Choice(title: 'Nine Guesses', numGuessBoxes: 9, crossAxisCount: 3),
];

class GuessButton extends StatefulWidget {
  static int numButtons = 0;

  int myNumber;

  GuessButton(this.myNumber, {Key key}) : super(key: key);

  static List<GuessButton> createButtons(int howMany) {
    numButtons = howMany;
    //colorModel = ColorModel(howMany);
    final guessList = List<GuessButton>();
    for (int i = 1; i <= howMany; i++) {
      guessList.add(GuessButton(i, key: UniqueKey()));
    }
    return guessList;
  }

  @override
  State<StatefulWidget> createState() {
    return GuessButtonState(
        myNumber, global.colorModel.getColor(myNumber), global.colorModel.getFrame(myNumber));
  }
}

class GuessButtonState extends State with SingleTickerProviderStateMixin {
  final int _myNumber;
  final Color _myColor;
  final Color _myFrame;
  static bool rollbegins = false;

  Animation<Color> _animation;
  AnimationController _controller;
  Color animColor;

  @override
  void initState() {
    super.initState();
    animColor = _myColor;
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    controllers?.update(_myNumber, (AnimationController) => _controller,
        ifAbsent: () => _controller);
    _animation = ColorTween(begin: _myColor, end: _myFrame).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.stop(canceled: true);
        }
      })
      ..addListener(() {
        setState(() {
          animColor = _animation.value;
        });
      });
  }

  GuessButtonState(
      this._myNumber,
      this._myColor,
      this._myFrame,
      );

  @override
  Widget build(BuildContext context) {
    if (rolled != _myNumber) {
      animColor = _myColor;
    } else if (rollbegins) {
      _controller.forward();
      rollbegins = false;
    }
    GridTile retVal = GridTile(
        child: Container(
            padding: EdgeInsets.all(10),
            child: Container(
                color: animColor,
                padding: EdgeInsets.all(10),
                child: Container(
                    color: _myColor,
                    child: InkWell(
                      onTap: () {
                        resetControllers();
                        _roller.roll(_myNumber);
                      },
                      onLongPress: () {
                        resetControllers();
                        _roller.roll(_myNumber);
                        if (rolled == _myNumber) {
                          Vibration.vibrate();
                        }
                      },
                    )))));

    return retVal;
  }
}

class RightWrong extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RightWrongState();
  }
}

class RightWrongState extends State {
  @override
  Widget build(BuildContext context) {
    return Wrap(children: <Widget>[
      ChoiceChip(
        selected: _guessTrue == true,
        onSelected: (bool) {
          setState(() {
            _guessTrue = true;
          });
        },
        label: Text("Right"),
      ),
      ChoiceChip(
        selected: _guessTrue == false,
        onSelected: (bool) {
          setState(() {
            _guessTrue = false;
          });
        },
        label: Text("Wrong"),
      ),
    ], spacing: 20);
  }
}
