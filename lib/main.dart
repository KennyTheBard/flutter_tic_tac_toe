import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Tic Tac Toe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final List<List<int>> combs = <List<int>>[
    <int>[0, 1, 2],
    <int>[3, 4, 5],
    <int>[6, 7, 8],
    <int>[0, 3, 6],
    <int>[1, 4, 7],
    <int>[2, 5, 8],
    <int>[0, 4, 8],
    <int>[2, 4, 6],
  ];

  List<int> cells = List<int>.generate(9, (int index) => 0);
  int playersValue = 1;
  bool gameRunning = true;

  void onTap(int index) {
    setState(() {
      // no need to play after winning
      if (!gameRunning) {
        return;
      }

      // so one player cannot overrides another player's move
      if (cells[index] != 0) {
        return;
      }

      cells[index] = playersValue;
      playersValue *= -1;

      _checkGameState();
    });
  }

  void _checkGameState() {
    for (final List<int> comb in combs) {
      int sum = 0;

      for (final int c in comb) {
        sum += cells[c];
      }

      if (sum.abs() == 3) {
        _gamesEnd(sum.sign);
        return;
      }
    }
  }

  void _gamesEnd(int winnersValue) {
    gameRunning = false;
    showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(content: Text(winnersValue > 0 ? 'Green wins' : 'Red wins'));
        });
  }

  void _restartGame() {
    setState(() {
      cells = List<int>.generate(9, (int index) => 0);
      gameRunning = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: Colors.black,
                    child: GridView.builder(
                        itemCount: 9,
                        padding: const EdgeInsets.all(5.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, mainAxisSpacing: 5.0, crossAxisSpacing: 5.0),
                        itemBuilder: (BuildContext context, int index) {
                          return Item(
                              index: index,
                              color: cells[index] == 0
                                  ? Colors.white
                                  : cells[index] > 0
                                  ? Colors.green
                                  : Colors.red,
                              onTap: onTap);
                        }),
                  )),
              TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.blue,
                    textStyle: const TextStyle(color: Colors.white, fontSize: 40, fontStyle: FontStyle.italic),
                  ),
                  onPressed: _restartGame,
                  child: const Text('Restart'))
            ],
          ),
        ));
  }
}

typedef OnTap = void Function(int);

class Item extends StatelessWidget {
  const Item({Key? key, required this.index, required this.color, required this.onTap}) : super(key: key);
  final int index;
  final OnTap onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onTap(index);
        },
        child: Container(color: color, child: Text('$index')));
  }
}
