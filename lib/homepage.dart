// ignore_for_file: prefer_const_constructors

import 'bird.dart';
import 'dart:async';
import 'pipe.dart';
import 'package:flutter/material.dart';

var imgBg = AssetImage("lib/flappy-bird-assets/sprites/background-day.png");
var ground = AssetImage("lib/flappy-bird-assets/sprites/base.png");

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -3.5; //how stronng gravity
  double velocity = 2.0; //strong jump
  double birdWight = 0.075;
  double birdHeight = 0.075;

  bool gameHasStarted = false;

  //pipe variables
  static List<double> pipeX = [2, 2 + 1.5];
  static double pipeWidth = 1.0;
  List<List<double>> pipeHeight = [
    //top height, bottom height
    [0.6, 0.4],
    [0.6, 0.4],
  ];

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 12), (timer) {
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - height;
      });

      //check if the bird is dead
      if (birdIsDead()) {
        timer.cancel();
        gameHasStarted = false;
        _showDialog();
      }
      moveMap();

      //keep the time going
      time += 0.01;
    });
  }

  void moveMap() {
    for (int i = 0; i < pipeX.length; i++) {
      setState(() {
        pipeX[i] -= 0.01;
      });
      if (pipeX[i] < -2.0) {
        pipeX[i] += 3.0;
      }
    }
  }

  void resetGame() {
    Navigator.pop(context); // dismiss the alter dialog
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 57, 50, 41),
            title: Center(
              child: Image.asset('lib/flappy-bird-assets/sprites/gameover.png'),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Color.fromARGB(255, 87, 124, 61),
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  bool birdIsDead() {
    //bird hitting top/bottom of screen
    if (birdY < -1 || birdY > 0.9) {
      return true;
    }
    //bird hitting the pipe
    for (int i = 0; i < pipeX.length; i++) {
      if (pipeX[i] <= birdHeight &&
          pipeX[i] + pipeWidth >= -birdWight &&
          (birdY <= -1 + pipeHeight[i][0] ||
              birdY + birdHeight >= 1 - pipeHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(imgBg, context);
    precacheImage(ground, context);
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: imgBg, fit: BoxFit.cover),
                ),
                //color: Color.fromARGB(255, 78, 130, 180),
                child: Center(
                  child: Stack(
                    children: [
                      MyBird(
                        birdY: birdY,
                        birdHeight: birdHeight,
                        birdWidth: birdWight,
                      ),

                      MyPipe(
                        //Top pipe 0
                        pipeX: pipeX[0],
                        pipeWidth: pipeWidth,
                        pipeHeight: pipeHeight[0][0],
                        isThisBottomPipe: false,
                      ),
                      MyPipe(
                        //Bottom pipe 0
                        pipeX: pipeX[0],
                        pipeWidth: pipeWidth,
                        pipeHeight: pipeHeight[0][1],
                        isThisBottomPipe: true,
                      ),
                      MyPipe(
                        //Top pipe 1
                        pipeX: pipeX[1],
                        pipeWidth: pipeWidth,
                        pipeHeight: pipeHeight[0][0],
                        isThisBottomPipe: false,
                      ),
                      MyPipe(
                        //Bottom pipe 1
                        pipeX: pipeX[1],
                        pipeWidth: pipeWidth,
                        pipeHeight: pipeHeight[0][1],
                        isThisBottomPipe: true,
                      ),

                      Container(
                        alignment: Alignment(0, -0.14),
                        child: gameHasStarted
                            ? Text('')
                            : Image.asset(
                                'lib/flappy-bird-assets/sprites/message.png',
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: ground, fit: BoxFit.cover),
                ),
                //color: Color.fromARGB(255, 49, 36, 36),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
