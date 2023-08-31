import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String millisecondsText = "";
  GameState gameState = GameState.readyToStart;
  Timer? waitingTimer;
  Timer? stoppableTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF282E3D),
      body: Stack(
        children: [
          Align(
              alignment: AlignmentDirectional(0,-0.8),
              child: Text(
                "Test of \n reaction speed",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 38, color: Colors.white ),
              )
          ),
          Align(alignment: Alignment.center,
              child:ColoredBox(
                  color: Color(0xFF6D6D6D),
                  child: SizedBox(
                      height: 150,
                      width: 300,
                      child: Center(
                          child: Text(
                              millisecondsText,
                              style: TextStyle(fontSize: 36, color: Colors.white)
                          )
                      )
                  )
              )
          ),
          Align(alignment: AlignmentDirectional(0, 0.8),
              child: GestureDetector(
                onTap: () => setState(() {
                  switch(gameState) {
                    case GameState.readyToStart:
                      gameState = GameState.waiting;
                      millisecondsText = "";
                      _startWaitingTimer();
                      break;
                    case GameState.waiting:
                      gameState = GameState.canBeStopped;
                      break;
                    case GameState.canBeStopped:
                      gameState = GameState.readyToStart;
                      stoppableTimer?.cancel();
                      break;
                  }
                }),
                child: ColoredBox(
                    color: _getActionButtonColor(),
                    child: SizedBox(
                        height: 150,
                        width: 200,
                        child: Center(
                            child: Text(
                                _getButtonText(),
                                style: TextStyle(fontSize: 38, color: Colors.white)
                            )
                        )
                    )
                ),
              )
          )],
      ),
    );
  }

  String _getButtonText() {
    switch(gameState){
      case GameState.readyToStart:
        return "START";
        break;
      case GameState.waiting:
        return "WAIT";
        break;
      case GameState.canBeStopped:
        return "STOP";
        break;
    }
  }

  void _startWaitingTimer(){
    final int randomMiliseconds = Random().nextInt(4000) + 1000;
    waitingTimer = Timer(Duration(milliseconds: randomMiliseconds), (){
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStoppableTimer();
    });
  }

  void _startStoppableTimer () {
    stoppableTimer = Timer.periodic(Duration(microseconds: 16), (timer) {
      setState(() {
        millisecondsText = "${timer.tick * 16} ms";
      });
    });
  }

  Color _getActionButtonColor() {
    switch(gameState){
      case GameState.readyToStart:
        return Color(0xFF40CA88);
        break;
      case GameState.waiting:
        return Color(0xFFE0982D);
        break;
      case GameState.canBeStopped:
        return Color(0xFFE02D47);
        break;
    }
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }

}

enum GameState {readyToStart, waiting, canBeStopped}