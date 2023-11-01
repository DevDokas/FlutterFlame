import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_beater/blocs/chronometer_bloc.dart';
import 'package:time_beater/components/player.dart';
import 'package:time_beater/time_beater.dart';

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
    // 1. Resetar variáveis e estados necessários
    game.player.hasReachedCheckpoint = false;
    game.paused = false;
    game.overlays.remove(game.flagMenuOverlayIdentifier);

    // 4. Remover todos os elementos do jogo (se necessário)
    game.removeAll(game.children);
    game.player.hasRespawned = true;

    // 5. Carregar o nível novamente
    _loadLevel();

    // 6. Reiniciar o cronômetro e outras lógicas do jogo, se necessário
    game.overlays.remove(game.hudOverlayIdentifier);
    game.chronometerBloc.add(ResetChronometerEvent());
    Future.delayed(const Duration(milliseconds: 10), () {
      game.overlays.add(game.hudOverlayIdentifier);
    });
    game.chronometerBloc.add(RunningChronometerEvent());
  }

  void _loadLevel() {
    // 6. Criar o nível do jogo novamente

    Level world = Level(
      levelName: game.levelNames[game.currentLevelIndex],
      player: game.player,
    );

    // 7. Configurar a câmera para seguir o jogador
    game.cam = CameraComponent.withFixedResolution(
      world: world,
      width: 320,
      height: 180,
    );
    game.cam.follow(game.player, maxSpeed: game.cameraSpeed, snap: true);

    // 8. Adicionar os componentes ao jogo
    game.add(FlameBlocProvider.value(
      value: game.chronometerBloc,
      children: [game.cam, world],
    ));

    game.addJoystick();
    game.add(JumpButton());
    game.add(DownButton());
    game.add(DashButton());
    game.add(PauseButton());

    // 9. Configurar o estado inicial do jogador
    game.player.current = PlayerState.idle;
    game.player.scale.x = 1;
    game.player.hasReachedCheckpoint = false;

    // 10. Remover overlays e outros elementos visuais, se necessário
    game.overlays.remove(game.pauseOverlayIdentifier);
  }
}