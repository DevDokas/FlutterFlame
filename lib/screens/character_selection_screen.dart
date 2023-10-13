import 'package:carousel_slider/carousel_slider.dart';
import 'package:flame/camera.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:time_beater/blocs/chronometer_bloc.dart';
import 'package:time_beater/screens/hud_ingame_screen.dart';

import '../components/dash_button.dart';
import '../components/down_button.dart';
import '../components/jump_button.dart';
import '../components/level.dart';
import '../components/pause_button.dart';
import '../data/player_skins.dart';
import '../time_beater.dart';

class CharacterSelectionScreen extends StatelessWidget {
  final TimeBeater game;
  final HudIngame hudIngame;
  const CharacterSelectionScreen(this.game, {super.key, required this.hudIngame});

  void attChronometer(BuildContext context) {
    game.player.hasReachedCheckpoint = false;
    game.gameHasReseted = true;
    game.addJoystick();
    game.add(JumpButton());
    game.add(DownButton());
    game.add(DashButton());
    game.add(PauseButton());
    game.overlays.add(game.hudOverlayIdentifier);
    game.chronometerBloc.add(RunningChronometerEvent());
    game.player.position = game.player.startingPosition;
    game.overlays.remove(game.characterSelectionOverlayIdentifier);
    game.overlays.add(game.admobOverlayIdentifier);
    game.paused = false;
    game.isGameRunning = true;
  }

  void chooseCharacter(PlayerSkins playerSkins) {
    game.removeAll(game.children);

    switch (playerSkins) {
      case PlayerSkins.maskDude:
        game.player.character = 'Mask Dude';

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

        //game.addAll([game.cam, world]);
        game.add(FlameBlocProvider.value(
            value: game.chronometerBloc,
            children: [game.cam, world],
        ));
        break;
      case PlayerSkins.ninjaFrog:
        game.player.character = 'Ninja Frog';
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

        //game.addAll([game.cam, world]);
        game.add(FlameBlocProvider.value(
          value: game.chronometerBloc,
          children: [game.cam, world],
        ));
        break;
      case PlayerSkins.pinkMan:
        game.player.character = 'Pink Man';
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

        //game.addAll([game.cam, world]);
        game.add(FlameBlocProvider.value(
          value: game.chronometerBloc,
          children: [game.cam, world],
        ));
        break;
      case PlayerSkins.virtualGuy:
        game.player.character = 'Virtual Guy';
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

        //game.addAll([game.cam, world]);
        game.add(FlameBlocProvider.value(
          value: game.chronometerBloc,
          children: [game.cam, world],
        ));
        break;
      default:
        game.player.character = 'Ninja Frog';
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

        //game.addAll([game.cam, world]);
        game.add(FlameBlocProvider.value(
          value: game.chronometerBloc,
          children: [game.cam, world],
        ));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: PageStorageBucket(),
      child: Align(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: const Color(0xFF211F30),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: CarouselSlider(
                items: [
                  TextButton(
                    onPressed: () => {
                      chooseCharacter(PlayerSkins.maskDude),
                      attChronometer(context),
                    },
                    child: InkWell(
                      onTap: () => {
                        chooseCharacter(PlayerSkins.maskDude),
                        attChronometer(context),
                      },
                      child: Container(
                        height: double.infinity,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/Main Characters/Mask Dude/MaskDudeImage.png',
                                height: 200,
                              ),
                            ),
                            const Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Mask Dude",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => {
                      chooseCharacter(PlayerSkins.ninjaFrog),
                      attChronometer(context),
                    },
                    child: InkWell(
                      onTap: () => {
                        chooseCharacter(PlayerSkins.ninjaFrog),
                        attChronometer(context),
                      },
                      child: Container(
                        height: double.infinity,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/Main Characters/Ninja Frog/NinjaFrogImage.png',
                                height: 200,
                              ),
                            ),
                            const Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Ninja Frog",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => {
                      chooseCharacter(PlayerSkins.pinkMan),
                      attChronometer(context),
                    },
                    child: InkWell(
                      onTap: () => {
                        chooseCharacter(PlayerSkins.pinkMan),
                        attChronometer(context),
                      },
                      child: Container(
                        height: double.infinity,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/Main Characters/Pink Man/PinkManImage.png',
                                height: 200,
                              ),
                            ),
                            const Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Pink Man",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => {
                      chooseCharacter(PlayerSkins.virtualGuy),
                      attChronometer(context),
                    },
                    child: InkWell(
                      onTap: () => {
                        chooseCharacter(PlayerSkins.virtualGuy),
                        attChronometer(context),
                      },
                      child: Container(
                        height: double.infinity,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/Main Characters/Virtual Guy/VirtualGuyImage.png',
                                height: 200,
                              ),
                            ),
                            const Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Virtual Guy",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ], options: CarouselOptions(
                height: 800,  // Altura do carrossel
                enlargeCenterPage: true,  // Aumentar o item central
                autoPlay: false,  // Iniciar a reprodução automática
                autoPlayInterval: const Duration(seconds: 2),  // Intervalo de reprodução automática
                autoPlayCurve: Curves.fastOutSlowIn,  // Curva de animação da reprodução automática
                enableInfiniteScroll: true,  // Habilitar rolagem infinita
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}