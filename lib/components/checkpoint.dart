import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:time_beater/components/player.dart';
import 'package:time_beater/time_beater.dart';

import 'custom_hitbox.dart';

class Checkpoint extends SpriteAnimationComponent with HasGameRef<TimeBeater>, CollisionCallbacks {
  int? nextLevel;
  bool isFinal;

  Checkpoint({
    this.nextLevel,
    this.isFinal = true,
    position,
    size,
  }) : super(
    position: position,
    size: size,
  );

  bool hasCollided = false;
  late CustomHitbox hitbox;
  
  @override
  FutureOr<void> onLoad() {
    priority = -1;
    //debugMode = true;

    if(isFinal){
      hitbox = CustomHitbox(
          offsetX: 19,
          offsetY: 18,
          width: 10,
          height: 46
      );

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
    } else if (!isFinal) {
      hitbox = CustomHitbox(
          offsetX: 19,
          offsetY: 18,
          width: 10,
          height: 46
      );

      add(RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ));

      animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('Items/Checkpoints/Start/Start (Idle).png'),
          SpriteAnimationData.sequenced(
              amount: 1,
              stepTime: 1,
              textureSize: Vector2.all(64)
          )
      );
    }
    
    return super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      _reachedCheckpoint();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _reachedCheckpoint() async {
    if (isFinal) {
      animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'),
          SpriteAnimationData.sequenced(
            amount: 26,
            stepTime: 0.05,
            textureSize: Vector2.all(64),
            loop: false,
          )
      );

      await animationTicker?.completed;

      animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png'),
          SpriteAnimationData.sequenced(
            amount: 10,
            stepTime: 0.05,
            textureSize: Vector2.all(64),
            loop: true,
          )
      );
    } else if (!isFinal && !hasCollided) {
      animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('Items/Checkpoints/Start/Start (Moving) (64x64).png'),
          SpriteAnimationData.sequenced(
            amount: 17,
            stepTime: 0.05,
            textureSize: Vector2.all(64),
            loop: false,
          )
      );
    }
  }
}