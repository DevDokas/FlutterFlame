import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_flame/pixel_adventure.dart';

class Saw extends SpriteAnimationComponent with HasGameRef<PixelAdventure>{
  Saw({
    position,
    size,
  }) : super(
      position: position,
      size: size
  );
  static const double stepTime = 0.3;

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Traps/Saw/On (38x38).png'),
        SpriteAnimationData.sequenced(
            amount: 8,
            stepTime: stepTime,
            textureSize: Vector2.all(38),
        ),
    );
    return super.onLoad();
  }
}