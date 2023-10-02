import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:time_beater/time_beater.dart';

class DashButton extends SpriteComponent
    with HasGameRef<TimeBeater>,
        TapCallbacks {

  DashButton();

  final margin = 32;
  final buttonSize = 64;

  @override
  FutureOr<void> onLoad() {
    priority = 10;
    sprite = Sprite(game.images.fromCache('HUD/DashButton.png'));
    position = Vector2(
      game.size.x - margin - buttonSize,
      game.size.y- (margin * 4) - (buttonSize * 4),
    );

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.isRunning = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.isRunning = false;
    super.onTapUp(event);
  }
}