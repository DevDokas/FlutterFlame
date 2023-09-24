import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_flame/components/player.dart';
import 'package:flutter_flame/pixel_adventure.dart';

import 'custom_hitbox.dart';

class Checkpoint extends SpriteAnimationComponent with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Checkpoint({
    position,
    size,
  }) : super(
    position: position,
    size: size,
  );

  bool hasReachedCheckpoint = false;

  final hitbox = CustomHitbox(
      offsetX: 19,
      offsetY: 64-46,
      width: 10,
      height: 46
  );
  
  @override
  FutureOr<void> onLoad() {
    priority = -1;
    //debugMode = true;
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
      collisionType: CollisionType.passive,
    ));

    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
        SpriteAnimationData.sequenced(
            amount: 1,
            stepTime: 1,
            textureSize: Vector2.all(64)
        )
    );
    
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !hasReachedCheckpoint) {
      _reachedCheckpoint();
    }
    super.onCollision(intersectionPoints, other);
  }

  void _reachedCheckpoint() {
    hasReachedCheckpoint = true;
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'),
        SpriteAnimationData.sequenced(
            amount: 26,
            stepTime: 0.05,
            textureSize: Vector2.all(64),
            loop: false,
        )
    );
    Future.delayed(const Duration(milliseconds: 1300), () {
      animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png'),
          SpriteAnimationData.sequenced(
            amount: 10,
            stepTime: 0.05,
            textureSize: Vector2.all(64),
            loop: true,
          )
      );
    });
  }
}