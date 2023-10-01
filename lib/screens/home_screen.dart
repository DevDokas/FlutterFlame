import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../time_beater.dart';

class HomeScreen extends StatelessWidget {
  final TimeBeater game;

  HomeScreen(this.game, {super.key});

  void startGame() {
    game.overlays.remove(game.mainMenuOverlayIdentifier);
    game.overlays.add(game.admobOverlayIdentifier);
    game.inMainMenu = false;
    game.paused = false;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Stack(
        children: [
          Image.asset(
            'assets/images/HUD/MainMenu.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(50),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                    onPressed: () => startGame(),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(350.0, 50.0),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      "Novo Jogo",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}