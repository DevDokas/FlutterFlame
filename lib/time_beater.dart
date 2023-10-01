import 'dart:async';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/painting.dart';
import 'package:time_beater/components/dash_button.dart';
import 'package:time_beater/components/down_button.dart';
import 'package:time_beater/components/jump_button.dart';
import 'package:time_beater/components/pause_button.dart';
import 'package:time_beater/components/player.dart';
import 'package:time_beater/components/level.dart';

class TimeBeater extends FlameGame
    with HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {

  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  Player player = Player(character: "Ninja Frog");

  late JoystickComponent joystick;

  //Ads
  String admobOverlayIdentifier = 'AdmobBanner';

  //MainMenu
  String mainMenuOverlayIdentifier = 'MainMenu';
  bool inMainMenu = true;

  // False = Keyboard || True = Touch
  bool showControls = true;

  //Cam variable
  double cameraSpeed = 100; //controls how much smoothness you want

  List<String> levelNames = [
    "Level-01",
    "Level-02",
  ];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async{
    //load all images into cache
    await images.loadAllImages();

    _loadLevel();

    // TODO: trocar o jogo paused para nao iniciado, iniciando ao sair do menu
    if (inMainMenu) {
      overlays.add(mainMenuOverlayIdentifier);
      paused = true;
    }



    _addTouchControls();

    return super.onLoad();
  }

  @override
  void update(double dt) {

    if (showControls) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 10,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache("HUD/Knob.png"),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache("HUD/Joystick.png"),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 64),
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        //idle
        player.horizontalMovement = 0;
        break;
    }
  }

  loadNextLevel() {
    if(currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      //no more levels
    }
  }

  void _loadLevel() {
    if (player.parent != null) {
      removeAll(children);
      _addTouchControls();
    }

    Future.delayed(const Duration(seconds: 1), () {

      Level world = Level(
        levelName: levelNames[currentLevelIndex],
        player: player,
      );

      cam = CameraComponent.withFixedResolution(
        world: world,
        width: 320,
        height: 180,
      );

      cam.follow(player, maxSpeed: cameraSpeed, snap: true);

      addAll([cam, world]);

    });
  }

  _addTouchControls() {
    if (showControls) {
      addJoystick();
      add(JumpButton());
      add(DownButton());
      add(DashButton());
      add(PauseButton());
    }
  }
}