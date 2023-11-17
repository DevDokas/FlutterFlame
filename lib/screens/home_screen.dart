import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../config/localstorage/localstorage_gamestate.dart';
import '../time_beater.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final TimeBeater game;

  HomeScreen(this.game, {Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectScreenLevel = 0;

  void startGame() {
    widget.game.overlays.remove(widget.game.mainMenuOverlayIdentifier);
    widget.game.overlays.add(widget.game.mapSelectionOverlayIdentifier);
    widget.game.inMainMenu = false;
    widget.game.inCharacterSelection = true;
  }

  void openConfigScreen() {
    widget.game.overlays.remove(widget.game.mainMenuOverlayIdentifier);
    widget.game.overlays.add(widget.game.configScreenOverlayIdentifier);
  }

  @override
  Widget build(BuildContext context) {
    final _gamestateBox = Hive.box('gamestateBox');
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    var storagedValue = _gamestateBox.get(widget.game.localStorage);
    var storagedGameConfig = _gamestateBox.get(widget.game.localConfig);

    String? timeStoragedValue;
    int? collectedStoragedValue;

    storagedGameConfig?.menuScoreLevel != null ? selectScreenLevel = storagedGameConfig?.menuScoreLevel : selectScreenLevel = 0;

    storagedValue?[selectScreenLevel].bestTime != null
        ? {
      timeStoragedValue = storagedValue?[selectScreenLevel].bestTime,
      collectedStoragedValue =
          storagedValue?[selectScreenLevel].bestCollect
    }
        : {
      timeStoragedValue = null,
      collectedStoragedValue = null
    };

    return Align(
      child: Stack(
        children: [
          Image.asset(
            'assets/images/HUD/MainMenu.png',
            fit: BoxFit.cover,
            width: screenWidth,
            height: screenHeight,
            alignment: Alignment.center,
          ),
          Container(
            height: screenHeight,
            width: screenWidth,
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
                  ),
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () => openConfigScreen(),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(350.0, 50.0),
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    "Configurações",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 25,
              bottom: 25,
              right: 50,
              left: 50,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Image.asset(
                      collectedStoragedValue != null
                          ? 'assets/images/Items/Fruits/AppleIcon.png'
                          : 'assets/images/Blank.png',
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      "${collectedStoragedValue ?? ''}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24.0),
                Row(
                  children: [
                    Image.asset(
                      timeStoragedValue != null
                          ? 'assets/images/Items/Clock.png'
                          : 'assets/images/Blank.png',
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      timeStoragedValue ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}