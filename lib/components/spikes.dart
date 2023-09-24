import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_flame/pixel_adventure.dart';

import 'custom_hitbox.dart';

class Spikes extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  Spikes({
    position,
    size,
  }) : super (
      position: position,
      size: size,
  );

  static const tileSize = 16;
  final hitbox = CustomHitbox(
      offsetX: 0,
      offsetY: 8,
      width: 16,
      height: 8
  );

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    //debugMode = true;
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
      collisionType: CollisionType.active,
    )
    );

    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Traps/Spikes/Idle.png'),
        SpriteAnimationData.sequenced(
            amount: 1, 
            stepTime: 1,
            textureSize: Vector2.all(16)
        )
    );
    return super.onLoad();
  }
}