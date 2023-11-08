import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:time_beater/blocs/chronometer_bloc.dart';
import 'package:time_beater/blocs/points_bloc.dart';
import 'package:time_beater/components/player.dart';
import 'package:time_beater/components/level.dart';

import 'data/player_data.dart';

class TimeBeater extends FlameGame
    with HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  TimeBeater({super.children, super.world, super.camera, super.oldCamera, required this.chronometerBloc, required this.pointCounterBloc});


  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  late PlayerData playerData;
  Player player = Player();


  late JoystickComponent joystick;

  //Ads
  String admobOverlayIdentifier = 'AdmobBanner';

  //HUD Layout
  String hudOverlayIdentifier = 'HUDScreen';

  //MainMenu
  String mainMenuOverlayIdentifier = 'MainMenu';
  bool inMainMenu = true;

  //FlagMenu
  String flagMenuOverlayIdentifier = 'FlagMenu';
  bool inFlagMenu = false;

  //PauseMenu
  String pauseOverlayIdentifier = 'PauseMenu';
  bool inPauseMenu = false;

  //MapSelection
  String mapSelectionOverlayIdentifier = 'MapSelection';
  bool inMapSelection = false;

  //CharacterSelection
  String characterSelectionOverlayIdentifier = 'CharacterSelection';
  bool inCharacterSelection = false;

  //LoadingScreen
  String loadingScreenOverlayIdentifier = 'LoadScreen';
  bool inLoadScreen = false;

  bool isGameRunning = false;

  // False = Keyboard || True = Touch
  bool showControls = true;
  bool gameHasReseted = false;

  //Cam variable
  double cameraSpeed = 100; //controls how much smoothness you want

  //Bloc Chronometer
  ChronometerBloc chronometerBloc;
  PointCounterBloc pointCounterBloc;

  List<String> levelNames = [
    "DreamRush",
    "ForestRun",
  ];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async{
    priority = 1;

    await images.loadAllImages();

    overlays.add(hudOverlayIdentifier);

    if (inMainMenu) {
      overlays.add(mainMenuOverlayIdentifier);
      paused = true;
    }

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
      final random = Random();
      int randomNum = random.nextInt(1002) + 1000 - 1;
      print(randomNum);
      currentLevelIndex++;
      _loadLevel();
      Future.delayed(Duration(milliseconds: randomNum), () {
        overlays.remove(loadingScreenOverlayIdentifier);
      });
    } else {
      //no more levels
    }
  }

  void _loadLevel() {
    if (player.parent != null) {
      removeAll(children);
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
}
