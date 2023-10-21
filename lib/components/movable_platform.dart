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
  final bool moveOnTouch;

  int moveDirection;
  int moveSpeed = 50;
  Vector2 velocity = Vector2.zero();
  MovablePlatform({
    this.isVertical = false,
    this.numOfPlatforms = 0,
    this.moveDirection = -1,
    this.moveOnTouch = false,
    this.moveSpeed = 50,
    this.offNeg = 0,
    this.offPos = 0,
    position,
    size,
  }) : super(
      position: position,
      size: size
  );
  static const tileSize = 16;

  double rangeNeg = 0;
  double rangePos = 0;
  String platformSprite = "";
  bool isPlatformMoving = false;
  late CustomHitbox customHitbox;

  @override
  FutureOr<void> onLoad() {
    priority = -1;

    if (moveOnTouch) {
      isPlatformMoving = false;
    } else if (!moveOnTouch) {
      isPlatformMoving = true;
    }

    if (numOfPlatforms == 2) {
      platformSprite = 'Terrain/Platform(2blocks).png';
      customHitbox = CustomHitbox(
          offsetX: 0,
          offsetY: 0,
          width: 16 * 2,
          height: 0.001
      );
    } else if (numOfPlatforms == 3) {
      platformSprite = 'Terrain/Platform(3blocks).png';
      customHitbox = CustomHitbox(
          offsetX: 0,
          offsetY: 0,
          width: 16 * 3,
          height: 0.001
      );
    } else if (numOfPlatforms == 4) {
      platformSprite = 'Terrain/Platform(4blocks).png';
      customHitbox = CustomHitbox(
          offsetX: 0,
          offsetY: 0,
          width: 16 * 4,
          height: 0.001
      );
    } else {
      platformSprite = 'Terrain/Platform(2blocks).png';
      customHitbox = CustomHitbox(
          offsetX: 0,
          offsetY: 0,
          width: 16 * 2,
          height: 0.001
      );
    }

    add(RectangleHitbox(
        position: Vector2(customHitbox.offsetX, customHitbox.offsetY),
        size: Vector2(customHitbox.width, customHitbox.height)
    ));
    //debugMode = true;

    if (isVertical) {
      rangePos = position.y + offPos * tileSize;
      rangeNeg = position.y - offNeg * tileSize;
    } else {
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offPos * tileSize;
    }

    sprite = Sprite(game.images.fromCache(platformSprite));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if(isPlatformMoving) {
      if(isVertical) {
        _moveVertically(dt);
      } else {
        _moveHorizontally(dt);
      }
    }

    super.update(dt);
  }

  void _moveVertically(double dt) {

    if (position.y <= rangeNeg) {
      moveDirection = 1;
    } else if (position.y >= rangePos) {
      moveDirection = -1;
    }

/*    if(position.y >= rangePos) {
      moveDirection = -1;
    } else if (position.y <= rangeNeg) {
      moveDirection = 1;
    }*/
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