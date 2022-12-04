// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:math';
import 'package:flutter/material.dart';
var pipe = const AssetImage('lib/flappy-bird-assets/sprites/pipe-green.png');

class MyPipe extends StatelessWidget {
  final random = Random();
  final pipeWidth;
  final pipeHeight;
  final pipeX;
  final bool isThisBottomPipe;
  
  MyPipe({
    super.key, 
    this.pipeWidth, 
    this.pipeHeight, 
    this.pipeX, 
    required this.isThisBottomPipe});


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2*pipeX+pipeWidth)/(2-pipeWidth),
        isThisBottomPipe ? 1 : -1),
      child: Container(
        //color: const Color.fromARGB(255, 13, 88, 36),
        decoration: BoxDecoration(
          image: DecorationImage(image:pipe, fit: BoxFit.fill),
        ),
        width: MediaQuery.of(context).size.width*pipeWidth/3,
        height: MediaQuery.of(context).size.height*3/4 *pipeHeight/1.5,
      ),
    );
  }
}
