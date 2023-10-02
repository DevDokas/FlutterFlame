import 'package:flutter/material.dart';
import 'package:time_beater/time_beater.dart';

import '../components/pause_button.dart';

class PauseScreen extends StatelessWidget {
  final TimeBeater game;
  final pauseOverlayIdentifier = 'PauseMenu';

  const PauseScreen(this.game, {super.key});

  void _resumeGame() {
    game.paused = false;
    game.overlays.remove(pauseOverlayIdentifier);
    game.add(PauseButton());
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Stack(
        children: [
/*          Image.asset(
            '',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
          ),*/
          Container(
            height: 300,
            width: 500,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: <Widget>[
                TextButton(
                    onPressed: () => _resumeGame(),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(350.0, 50.0),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      "Continuar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    )
                ),
              ],
            ),
          ),
        ],
      )
    );
    throw UnimplementedError();
  }
}