import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_beater/blocs/chronometer_bloc.dart';
import 'package:time_beater/components/player.dart';
import 'package:time_beater/time_beater.dart';

import '../blocs/points_bloc.dart';
import '../components/dash_button.dart';
import '../components/down_button.dart';
import '../components/jump_button.dart';
import '../components/level.dart';
import '../components/pause_button.dart';
import '../config/ColorPallet.dart';

class FlagMenu extends StatelessWidget {
  final TimeBeater game;

  const FlagMenu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    final chronometerBloc = BlocProvider.of<ChronometerBloc>(context);
    final pointsBloc = BlocProvider.of<PointCounterBloc>(context);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.blueGrey, width: 3),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      width: 130,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Items/Fruits/AppleIcon.png',
                            height: 32,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 12.0),
                          Text(
                            "x ${pointsBloc.state.points ?? '0'}",
                            style: const TextStyle(
                                fontSize: 44
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 28),
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
                  ],
                ),
                const SizedBox(height: 20),
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
    game.pointCounterBloc.add(ResetPointCounterEvent());
    game.overlays.remove(game.hudOverlayIdentifier);
    game.overlays.remove(game.flagMenuOverlayIdentifier);
    game.overlays.add(game.mainMenuOverlayIdentifier);
  }

  void _restartGame() {
    game.player.hasReachedCheckpoint = false;
    game.paused = false;

    game.removeAll(game.children);
    game.player.hasRespawned = true;

    _loadLevel();

    game.pointCounterBloc.add(ResetPointCounterEvent());
    game.gameHasReseted = true;
    game.chronometerBloc.add(RunningChronometerEvent());
    game.overlays.remove(game.flagMenuOverlayIdentifier);
  }

  void _loadLevel() {

    Level world = Level(
      levelName: game.levelNames[game.currentLevelIndex],
      player: game.player,
    );

    game.cam = CameraComponent.withFixedResolution(
      world: world,
      width: 320,
      height: 180,
    );
    game.cam.follow(game.player, maxSpeed: game.cameraSpeed, snap: true);

    game.add(FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<ChronometerBloc, ChronometerState>(
            create: () => ChronometerBloc(),
          ),
          FlameBlocProvider<PointCounterBloc, PointCounterState>(
            create: () => PointCounterBloc(),
          ),
        ],
        children: [game.cam, world]
    ),
    );

/*    game.add(FlameBlocProvider.value(
      value: game.chronometerBloc,
      children: [game.cam, world],
    ));*/

    game.addJoystick();
    game.add(JumpButton());
    game.add(DownButton());
    game.add(DashButton());
    game.add(PauseButton());

    game.player.hasReachedCheckpoint = false;
  }
}