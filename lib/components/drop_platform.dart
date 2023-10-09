import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:time_beater/time_beater.dart';

import 'custom_hitbox.dart';

class DropPlatform extends SpriteComponent with HasGameRef<TimeBeater>{
  final int numOfPlatforms;
  final double offNeg;
  final double offPos;
  Vector2 velocity = Vector2.zero();
  DropPlatform({
    this.numOfPlatforms = 0,
    this.offNeg = 0,
    this.offPos = 0,
    position,
    size,
  }) : super(
      position: position,
      size: size
  );
  static const tileSize = 16;
  static const moveSpeed = 500;

  Vector2 initialPosition = Vector2.zero();
  double moveDirection = 0;
  double rangeNeg = 0;
  double rangePos = 0;
  bool hasPlayerTouched = false;
  String platformSprite = "";

  CustomHitbox hitbox = CustomHitbox(
      offsetX: 0,
      offsetY: 0,
      width: 16,
      height: 16
  );

  @override
  FutureOr<void> onLoad() {
    priority = -1;

    add(RectangleHitbox());
    //debugMode = true;

    initialPosition = Vector2(position.x, position.y);

    rangeNeg = position.y - offNeg * tileSize;
    rangePos = position.y + offPos * tileSize;


    if (numOfPlatforms == 2) {
      platformSprite = 'Terrain/Platform(2blocks).png';
    } else if (numOfPlatforms == 3) {
      platformSprite = 'Terrain/Platform(3blocks).png';
    } else if (numOfPlatforms == 4) {
      platformSprite = 'Terrain/Platform(4blocks).png';
    } else {
      platformSprite = 'Terrain/Platform(2blocks).png';
    }

    sprite = Sprite(game.images.fromCache(platformSprite));
    return super.onLoad();
  }

  @override
  void update(double dt) {

    if (hasPlayerTouched) {
      _moveVertically(dt);
    }

    super.update(dt);
  }

  void _moveVertically(double dt) {

    if (offPos > 0 && offNeg == 0) {

      if (position.y <= rangeNeg) {
        moveDirection = 1;
      } else if (position.y >= rangePos)  {
        position = initialPosition;
        hasPlayerTouched = false;
      }

      position.y += moveDirection * moveSpeed * dt;
    } else if (offNeg > 0 && offPos == 0) {
      // TODO: implementar plataforma que sobe de uma vez
      position.y += moveDirection * moveSpeed * dt;
    }

  }
}