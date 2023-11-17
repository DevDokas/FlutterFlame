import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_beater/config/localstorage/localstorage_gameconfig.dart';
import 'package:time_beater/time_beater.dart';
import 'package:hive_flutter/adapters.dart';

import '../config/localstorage/localstorage_gamestate.dart';

class ConfigScreen extends StatefulWidget {
  final TimeBeater game;

  ConfigScreen(this.game, {Key? key}) : super(key: key);

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  int selectScreenLevel = 0;
  final _gamestateBox = Hive.box('gamestateBox');
  late LocalStorageGameConfig localStorageGameConfig;

  @override
  void initState() {
    super.initState();
    localStorageGameConfig = LocalStorageGameConfig(0);
  }

  void backToMainMenu() {
    widget.game.overlays.remove(widget.game.configScreenOverlayIdentifier);
    widget.game.overlays.add(widget.game.mainMenuOverlayIdentifier);
    widget.game.inMainMenu = true;
  }

  void selectScreenLevelBack() {
    setState(() {
      if (selectScreenLevel == 0) {
        selectScreenLevel = widget.game.levelNames.length - 1;
        localStorageGameConfig.menuScoreLevel = widget.game.levelNames.length - 1;
      } else {
        selectScreenLevel--;
        localStorageGameConfig.menuScoreLevel = selectScreenLevel;
      }
    });

    _gamestateBox.put(widget.game.localConfig, localStorageGameConfig);
  }

  void selectScreenLevelForward() {
    setState(() {
      if (selectScreenLevel == widget.game.levelNames.length - 1) {
        selectScreenLevel = 0;
        localStorageGameConfig.menuScoreLevel = 0;
      } else {
        selectScreenLevel++;
        localStorageGameConfig.menuScoreLevel = selectScreenLevel;
      }

      _gamestateBox.put(widget.game.localConfig, localStorageGameConfig);
    });
  }

  @override
  Widget build(BuildContext context) {
    var storagedValue = _gamestateBox.get(widget.game.localConfig);
    var storagedGameConfig = _gamestateBox.get(widget.game.localConfig);

    if (storagedGameConfig?.menuScoreLevel != null) {
      selectScreenLevel = storagedGameConfig?.menuScoreLevel;
    } else {
      selectScreenLevel = 0;
    }

    return Material(
      child: Align(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(50),
          decoration: BoxDecoration(
            color: const Color(0xFF211F30),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () => backToMainMenu(),
                  child: const Text("Voltar"),
                ),
              ),
              Container(
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Image.asset('assets/images/HUD/ArrowLeft.png'),
                      iconSize: 50,
                      onPressed: () {
                        selectScreenLevelBack();
                        print(storagedValue?.menuScoreLevel);
                      },
                    ),
                    Text(
                      widget.game.levelNames[selectScreenLevel],
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Image.asset('assets/images/HUD/ArrowRight.png'),
                      iconSize: 50,
                      onPressed: () {
                        selectScreenLevelForward();
                        print(storagedValue?.menuScoreLevel);
                      },
                    ),
                  ],
                ),
              )
              // ... outros widgets aqui
            ],
          ),
        ),
      ),
    );
  }
}