import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_beater/blocs/chronometer_bloc.dart';
import 'package:time_beater/time_beater.dart';

import '../config/ColorPallet.dart';

class FlagMenu extends StatelessWidget {
  final TimeBeater game;

  const FlagMenu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    final chronometerBloc = BlocProvider.of<ChronometerBloc>(context);
    final state = chronometerBloc.state;
    int? milliseconds = 0;
    int? seconds = 0;
    int? minutes = 0;

     if (state is PauseChronometer) {
      milliseconds = state.milliseconds;
      seconds = state.seconds;
      minutes = state.minutes;

      return Align(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/HUD/PauseMenu.png',
              fit: BoxFit.cover,
              width: 500,
              height: 300,
              alignment: Alignment.center,
            ),
            Container(
            height: 300,
            width: 500,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.blueGrey, width: 5),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                    "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}:${milliseconds.toString().padLeft(3, '0')}",
                    style: const TextStyle(
                        fontSize: 44
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => _restartGame(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(ColorPallet().primaryButtonColor),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                  ),
                  child: const Text("Reiniciar a nivel"),
                ),
                TextButton(
                  onPressed: () => _backToMainMenu(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(ColorPallet().primaryButtonColor),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                  ),
                  child: const Text("Voltar ao Menu"),
                ),
              ],
            ),
          ),
          ],
        ),
      );
    } else {
      return const Align(
        child: Text(""),
      );
    }
  }

  _backToMainMenu() {
    game.overlays.remove(game.hudOverlayIdentifier);
    game.overlays.remove(game.flagMenuOverlayIdentifier);
    game.overlays.add(game.mainMenuOverlayIdentifier);
  }

  void _restartGame() {
    game.player.hasReachedCheckpoint = false;
    game.overlays.remove(game.hudOverlayIdentifier);
    game.chronometerBloc.add(ResetChronometerEvent());
    Future.delayed(const Duration(milliseconds: 10), () {
      game.overlays.add(game.hudOverlayIdentifier);
    });
    game.paused = false;
    game.overlays.remove(game.flagMenuOverlayIdentifier);
    game.player.position = game.player.startingPosition;
    game.chronometerBloc.add(RunningChronometerEvent());
  }
}