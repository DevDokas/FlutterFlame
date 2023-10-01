import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:time_beater/time_beater.dart';

class DownButton extends SpriteComponent
    with HasGameRef<TimeBeater>,
        TapCallbacks {

  DownButton();

  final margin = 32;
  final buttonSize = 64;

  @override
  FutureOr<void> onLoad() {
    priority = 10;
    sprite = Sprite(game.images.fromCache('HUD/DownButton.png'));
    position = Vector2(
      game.size.x - margin - buttonSize,
      game.size.y - margin - buttonSize,
    );

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.isGoingDown = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.isGoingDown = false;
    super.onTapUp(event);
  }
}