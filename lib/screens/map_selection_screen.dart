import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_beater/data/game_levels.dart';
import 'package:time_beater/time_beater.dart';

class MapSelectionScreen extends StatelessWidget {
  final TimeBeater game;

  const MapSelectionScreen(this.game, {super.key});

  void chooseMap(GameLevels gameLevels) {
    switch(gameLevels) {
      case GameLevels.dreamRush:
        game.currentLevelIndex = 0;
        break;
      case GameLevels.forestRun:
        game.currentLevelIndex = 1;
        break;
      default:
        game.currentLevelIndex = 0;
        break;
    }

    game.overlays.remove(game.mapSelectionOverlayIdentifier);
    game.overlays.add(game.characterSelectionOverlayIdentifier);
    //game.currentLevelIndex = levelSelected;
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
                        chooseMap(GameLevels.dreamRush),
                      },
                      child: InkWell(
                        onTap: () => {
                          chooseMap(GameLevels.dreamRush),
                        },
                        child: Container(
                          height: double.infinity,
                          width: 350,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Image.asset(
                                  'assets/images/Levels/level01.png',
                                  height: 300,
                                ),
                              ),
                              const Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  "Level 01",
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
                        chooseMap(GameLevels.forestRun),
                      },
                      child: InkWell(
                        onTap: () => {
                          chooseMap(GameLevels.forestRun),
                        },
                        child: Container(
                          height: double.infinity,
                          width: 350,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Image.asset(
                                  'assets/images/Levels/level01.png',
                                  height: 300,
                                ),
                              ),
                              const Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  "Level 02",
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
                  ],
                  options: CarouselOptions(
                    height: 800,  // Altura do carrossel
                    enlargeCenterPage: true,  // Aumentar o item central
                    autoPlay: false,  // Iniciar a reprodução automática
                    autoPlayInterval: const Duration(seconds: 2),  // Intervalo de reprodução automática
                    autoPlayCurve: Curves.fastOutSlowIn,  // Curva de animação da reprodução automática
                    enableInfiniteScroll: true,  // Habilitar rolagem infinita
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

}