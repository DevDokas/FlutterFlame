import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:time_beater/components/custom_hitbox.dart';
import 'package:time_beater/time_beater.dart';

import '../blocs/points_bloc.dart';

class Fruit extends SpriteAnimationComponent
    with HasGameRef<TimeBeater>, CollisionCallbacks{
  final String fruit;
  bool collected = false;
  Fruit({
    this.fruit = "Apple",
    position,
    size,
  }) : super(
      position: position,
      size: size
  );

  final double stepTime = 0.05;
  final hitbox = CustomHitbox(
      offsetX: 10,
      offsetY: 10,
      width: 12,
      height: 12
  );

  @override
  FutureOr<void> onLoad() {
    //debugMode = true;
    //priority = -1;

    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
      collisionType: CollisionType.passive,
    ));
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/$fruit.png'),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
    ),
    );
    return super.onLoad();
  }

  void collidedWithPlayer() async {
    if (!collected) {
      game.pointCounterBloc.add(AddPointCounterEvent());
      collected = true;
    }
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/Collected.png'),
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );
    await animationTicker?.completed;
    removeFromParent();
  }
}