import 'package:flutter/material.dart';
// External import
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Hope',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Hope(),
    );
  }
}

class Hope extends StatefulWidget {
  @override
  _HopeState createState() => _HopeState();
}

class _HopeState extends State<Hope> with TickerProviderStateMixin {
  List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.indigo,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
    Colors.pink,
    Colors.amber,
    Colors.grey
  ];

  List<Color> _shadowColors = [];

  List<Color> _currentColors = [];

  List<double> _shadows = [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0
  ];

  void keySound(int note) {
    final audioPlayer = AudioCache();
    audioPlayer.play('starwars$note.mp3');
  }

  Widget keyNote({int note, BuildContext context}) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _currentColors[note - 1] = _colors[note - 1].withAlpha(255);
          _shadowColors[note - 1] = _colors[note - 1].withAlpha(100);
          _shadows[note - 1] = -20.0;
        });
        keySound(note);
        Future.delayed(Duration(seconds: 1)).then((_) {
          setState(() {
            _currentColors[note - 1] = _colors[note - 1].withAlpha(100);
            _shadowColors[note - 1] = _colors[note - 1].withAlpha(100);
            _shadows[note - 1] = 0.0;
          });
        });
      },
      child: AnimatedContainer(
        height: (MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom) *
            0.1,
        width: double.infinity,
        decoration: BoxDecoration(
            color: _currentColors[note - 1],
            boxShadow: [
              BoxShadow(
                  color: _currentColors[note - 1],
                  spreadRadius: _shadows[note - 1],
                  blurRadius: -_shadows[note - 1] * 2,
              )
            ]
        ),
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  void initState() {
    _colors.shuffle();
    for (int i = 0; i < 10; i++) {
      _currentColors.add(_colors[i].withAlpha(100));
      _shadowColors.add(_colors[i].withAlpha(100));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _colors.length,
        itemBuilder: (BuildContext context, int index) {
          return keyNote(note: index + 1, context: context);
        },
      ),
    );
  }
}
