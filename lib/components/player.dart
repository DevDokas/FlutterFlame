import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flame/components/custom_hitbox.dart';
import 'package:flutter_flame/components/saw.dart';
import 'package:flutter_flame/components/utils.dart';
import 'package:flutter_flame/pixel_adventure.dart';

import 'collision_block.dart';
import 'fruit.dart';

enum PlayerState {
  idle,
  running,
  jumping,
  falling,
  hit,
  appearing,
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler, CollisionCallbacks {
  String character;
  Player({
    position,
    this.character = 'Ninja Frog',
  }) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;
  final double stepTime = 0.05;

  final double _gravity = 9.8;
  final double _jumpForce = 180;
  final double _terminalVelocity = 300;
  double horizontalMovement = 0;
  double moveSpeed = 100;
  int jumpsLeft = 2;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool isOnWall = false;
  bool isRunning = false;
  bool isGoingDown = false;
  bool hasJumped = false;
  bool gotHit = false;
  List<CollisionBlock> collisionBlocks = [];
  CustomHitbox hitbox = CustomHitbox(
      offsetX: 10,
      offsetY: 4,
      width: 14,
      height: 28
  );

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    //debugMode = true;

    startingPosition = Vector2(position.x, position.y);

    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height)
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if(!gotHit) {
      _updatePlayerState();
      _updatePlayerMovement(dt);
      _checkHorizontalCollisions();
      _applyGravity(dt);
      _checkVerticalCollisions();
    }
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    isGoingDown = false;
    final isShiftKeyPressed = keysPressed.contains(LogicalKeyboardKey.shiftLeft) ||
      keysPressed.contains(LogicalKeyboardKey.shiftRight);
    final isDownKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyS) ||
      keysPressed.contains(LogicalKeyboardKey.arrowDown);
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
      keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
      keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space) || keysPressed.contains(LogicalKeyboardKey.arrowUp) || keysPressed.contains(LogicalKeyboardKey.keyW);

    if (isDownKeyPressed) {
      isGoingDown = true;
    } else {
      isGoingDown = false;
    }

    if (isShiftKeyPressed) {
      isRunning = true;
    } else {
      isRunning = false;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Fruit) {
      other.collidedWithPlayer();
    }
    if (other is Saw) {
      _respawn();
      //other.collidedWithPlayer();
    }
    super.onCollision(intersectionPoints, other);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation("Idle", 11, 32);

    runningAnimation = _spriteAnimation("Run", 12, 32);

    jumpingAnimation = _spriteAnimation("Jump", 1, 32);

    fallingAnimation = _spriteAnimation("Fall", 1, 32);

    hitAnimation = _spriteAnimation("Hit", 7, 32);

    appearingAnimation = _appearingAnimation();
    //list all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.appearing: appearingAnimation,
    };

    //set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String spriteAnimation, int amount, double size ) {
      return SpriteAnimation.fromFrameData(
      game.images.fromCache("Main Characters/$character/$spriteAnimation (32x32).png"), SpriteAnimationData.sequenced(
      amount: amount,
      stepTime: stepTime,
      textureSize: Vector2.all(size),
      ),
  );
}

  SpriteAnimation _appearingAnimation() {
    print("Appears");
    return SpriteAnimation.fromFrameData(
    game.images.fromCache("Main Characters/Appearing (96x96).png"), SpriteAnimationData.sequenced(
    amount: 7,
    stepTime: stepTime,
    textureSize: Vector2.all(96),
    ),
  );   
}

  void _updatePlayerMovement(double dt) {

    if(isOnGround) {
      jumpsLeft = 2;
      if (hasJumped) {
        _playerJump(dt);
        hasJumped = false;
      }
      if (isRunning) {
        position.x += velocity.x * 1.03 * dt;
      }
    } else {
      if (hasJumped) {
        if (jumpsLeft > 0) {
          _playerJump(dt);
          jumpsLeft = 0;
        }
      }
    }

    if(isOnWall) {
      jumpsLeft = 0;
      if (jumpsLeft > 0 && hasJumped) {
        _playerJump(dt);
      }
      jumpsLeft = 1;
    }





    /*if (velocity.y > _gravity) {
      isOnGround = false;
    }*/

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if(velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if(velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    //check if falling set to falling
    if (velocity.y > 0) {
      playerState = PlayerState.falling;
    }

    if(velocity.y < 0) {
      playerState = PlayerState.jumping;
    }

    current = playerState;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      // handle collisions
      if (!block.isPlatform) {
        if(checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            isOnWall = true;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            isOnWall = true;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if(block.isPlatform) {
        if(checkCollision(this, block)) {
          if (!isGoingDown) {
            if (velocity.y > 0) {
              velocity.y = 0;
              position.y = block.y - hitbox.height - hitbox.offsetY;
              isOnGround = true;
              break;
            }
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if(velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }

  void _respawn() {
    gotHit = true;
    current = PlayerState.hit;

    const duration = Duration(milliseconds: 350);
    const appearingDuration = Duration(milliseconds: 350);
    const canMoveDuration = Duration(milliseconds: 200);

    Future.delayed(duration, () {
      scale.x = 1;
      position = startingPosition - Vector2.all(32);
      current = PlayerState.appearing;
      Future.delayed(appearingDuration, () {
        velocity = Vector2.zero();
        position = startingPosition;
        _updatePlayerState();
        Future.delayed(canMoveDuration, () {
          gotHit = false;
        });
      });
    });
  }
}