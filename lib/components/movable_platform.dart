import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:time_beater/time_beater.dart';

import 'custom_hitbox.dart';

class MovablePlatform extends SpriteComponent with HasGameRef<TimeBeater>{
  final bool isVertical;
  final int numOfPlatforms;
  final double offNeg;
  final double offPos;
  Vector2 velocity = Vector2.zero();
  MovablePlatform({
    this.isVertical = false,
    this.numOfPlatforms = 0,
    this.offNeg = 0,
    this.offPos = 0,
    position,
    size,
  }) : super(
      position: position,
      size: size
  );
  static const moveSpeed = 50;
  static const tileSize = 16;

  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;
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

    if (isVertical) {
      rangeNeg = position.y - offNeg * tileSize;
      rangePos = position.y + offPos * tileSize;
    } else {
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offPos * tileSize;
    }

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
    if(isVertical) {
      _moveVertically(dt);
    } else {
      _moveHorizontally(dt);
    }

    super.update(dt);
  }

  void _moveVertically(double dt) {
    if(position.y >= rangePos) {
      moveDirection = -1;
    } else if (position.y <= rangeNeg) {
      moveDirection = 1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }

  void _moveHorizontally(double dt) {
    if(position.x >= rangePos) {
      velocity.x = -moveSpeed.toDouble();
      moveDirection = -1;
    } else if (position.x <= rangeNeg) {
      velocity.x = moveSpeed.toDouble();
      moveDirection = 1;
    }
    position.x += velocity.x * dt;
  }
}