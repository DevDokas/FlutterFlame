import 'package:flutter/material.dart';
import 'package:time_beater/blocs/chronometer_bloc.dart';
import 'package:time_beater/time_beater.dart';

import '../components/pause_button.dart';

class PauseScreen extends StatelessWidget {
  final TimeBeater game;

  const PauseScreen(this.game, {super.key});

  void _resumeGame() {
    game.paused = false;
    game.chronometerBloc.add(RunningChronometerEvent());
    game.overlays.remove(game.pauseOverlayIdentifier);
    game.add(PauseButton());
  }

  void _restartGame() {
    game.overlays.remove(game.hudOverlayIdentifier);
    game.chronometerBloc.add(ResetChronometerEvent());
    Future.delayed(const Duration(milliseconds: 10), () {
      game.overlays.add(game.hudOverlayIdentifier);
    });
    game.paused = false;
    game.overlays.remove(game.pauseOverlayIdentifier);
    game.add(PauseButton());
    game.player.position = game.player.startingPosition;
    game.chronometerBloc.add(RunningChronometerEvent());
  }

  _backToMainMenu() {
    game.overlays.remove(game.hudOverlayIdentifier);
    game.overlays.remove(game.pauseOverlayIdentifier);
    game.overlays.add(game.mainMenuOverlayIdentifier);
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
            padding: const EdgeInsets.all(50),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                TextButton(
                    onPressed: () => _restartGame(),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(350.0, 50.0),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      "Reiniciar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    )
                ),
                TextButton(
                    onPressed: () => _backToMainMenu(),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(350.0, 50.0),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      "Voltar ao Menu",
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
  }
}