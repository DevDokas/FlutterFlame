import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:time_beater/blocs/chronometer_bloc.dart';
import 'package:time_beater/time_beater.dart';

class PauseButton extends SpriteComponent
    with HasGameRef<TimeBeater>,
        TapCallbacks {

  PauseButton();

  final margin = 32;
  final buttonSize = 64;

  final pauseOverlayIdentifier = 'PauseMenu';

  @override
  FutureOr<void> onLoad() {
    priority = 10;
    sprite = Sprite(game.images.fromCache('HUD/PauseButton.png'));
    position = Vector2(
      game.size.x - (margin * 8) - (buttonSize * 9),
      game.size.y- (margin * 4) - (buttonSize * 4),
    );

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.paused = true;
    game.overlays.add(pauseOverlayIdentifier);
    game.chronometerBloc.add(PauseChronometerEvent());
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.remove(this);
/*    Future.delayed(const Duration(milliseconds: 100), () {
      game.paused = true;
    });*/
    super.onTapUp(event);
  }
}