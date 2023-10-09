import 'dart:async';

import 'package:flame/components.dart';
import 'package:time_beater/time_beater.dart';

class SecretWall extends SpriteComponent with HasGameRef<TimeBeater> {
  String side;

 SecretWall({
    this.side = 'middle',
    position,
    size,
  }) : super(
    position: position,
    size: size,
  );

  @override
  FutureOr<void> onLoad() {
    priority = 2;

    switch (side) {
      case 'left':
        sprite = Sprite(game.images.fromCache('Terrain/OverterrainLeft.png'));
        break;
      case'right':
        sprite = Sprite(game.images.fromCache('Terrain/OverterrainRight.png'));
        break;
      default:
        sprite = Sprite(game.images.fromCache('Terrain/Overterrain.png'));
        break;
    }

    return super.onLoad();
  }

}