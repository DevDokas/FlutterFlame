import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:time_beater/components/pause_button.dart';
import 'package:time_beater/time_beater.dart';

class PlayButton extends SpriteComponent
    with HasGameRef<TimeBeater>,
        TapCallbacks {

  PlayButton();

  final margin = 32;
  final buttonSize = 64;

  final pauseOverlayIdentifier = 'PauseMenu';

  @override
  FutureOr<void> onLoad() {
    priority = 10;
    sprite = Sprite(game.images.fromCache('HUD/PlayButton.png'));
    position = Vector2(
      game.size.x - (margin * 8) - (buttonSize * 9),
      game.size.y- (margin * 4) - (buttonSize * 4),
    );

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.overlays.remove(pauseOverlayIdentifier);
    game.paused = false;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    //game.remove(this);
    game.add(PauseButton());
    super.onTapUp(event);
  }
}