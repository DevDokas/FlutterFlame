import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../time_beater.dart';

class LoadScreen extends StatelessWidget {
  final TimeBeater game;
  const LoadScreen(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Stack(
        children: [
/*          Image.asset(
            'assets/images/HUD/MainMenu.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
          ),*/
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Text("Loading ... "),
          )
        ],
      ),
    );
    throw UnimplementedError();
  }

}