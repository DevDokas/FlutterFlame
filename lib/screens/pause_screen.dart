import 'package:flame/camera.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:time_beater/blocs/chronometer_bloc.dart';
import 'package:time_beater/blocs/points_bloc.dart';
import 'package:time_beater/components/movable_platform.dart';
import 'package:time_beater/config/ColorPallet.dart';
import 'package:time_beater/time_beater.dart';

import '../components/dash_button.dart';
import '../components/down_button.dart';
import '../components/jump_button.dart';
import '../components/level.dart';
import '../components/pause_button.dart';

class PauseScreen extends StatelessWidget {
  final TimeBeater game;

  PauseScreen(this.game, {super.key});

  MovablePlatform movablePlatform = MovablePlatform();
  void _resumeGame() {
    game.paused = false;
    game.chronometerBloc.add(RunningChronometerEvent());
    game.overlays.remove(game.pauseOverlayIdentifier);
    game.add(PauseButton());
  }

  void _restartGame() {
    game.pointCounterBloc.add(ResetPointCounterEvent());
    game.gameHasReseted = true;
    game.removeAll(game.children);
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

    game.addJoystick();
    game.add(JumpButton());
    game.add(DownButton());
    game.add(DashButton());
    game.add(PauseButton());
    game.overlays.remove(game.pauseOverlayIdentifier);
    game.paused = false;
    game.chronometerBloc.add(RunningChronometerEvent());
  }

  _backToMainMenu() {
    game.pointCounterBloc.add(ResetPointCounterEvent());
    game.overlays.remove(game.hudOverlayIdentifier);
    game.overlays.remove(game.pauseOverlayIdentifier);
    game.overlays.add(game.mainMenuOverlayIdentifier);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
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
            padding: const EdgeInsets.all(50),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                    onPressed: () => _resumeGame(),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(350.0, 50.0),
                      backgroundColor: ColorPallet().primaryButtonColor,
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
                      backgroundColor: ColorPallet().primaryButtonColor,
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
                      backgroundColor: ColorPallet().primaryButtonColor,
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