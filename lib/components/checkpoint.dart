import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:time_beater/components/player.dart';
import 'package:time_beater/time_beater.dart';

import 'custom_hitbox.dart';

class Checkpoint extends SpriteAnimationComponent with HasGameRef<TimeBeater>, CollisionCallbacks {
  int nextLevel;

  Checkpoint({
    this.nextLevel = 1,
    position,
    size,
  }) : super(
    position: position,
    size: size,
  );

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

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      _reachedCheckpoint();
      reachedCheckpoint();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _reachedCheckpoint() async {
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
  }

  void reachedCheckpoint() {
    Future.delayed(const Duration(seconds: 1));
    game.cam.stop();
  }
}