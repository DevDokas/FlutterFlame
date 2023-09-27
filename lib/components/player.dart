import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flame/components/checkpoint.dart';
import 'package:flutter_flame/components/custom_hitbox.dart';
import 'package:flutter_flame/components/movable_platform.dart';
import 'package:flutter_flame/components/saw.dart';
import 'package:flutter_flame/components/spikes.dart';
import 'package:flutter_flame/components/utils.dart';
import 'package:flutter_flame/pixel_adventure.dart';

import 'collision_block.dart';
import 'fruit.dart';

enum PlayerState {
  idle,
  running,
  jumping,
  doubleJumping,
  falling,
  hit,
  appearing,
  finishedLevel,
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
  late final SpriteAnimation doubleJumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation disappearingAnimation;
  final double stepTime = 0.05;

  final double _gravity = 9.8;
  final double _jumpForce = 200;
  final double _terminalVelocity = 300;
  double horizontalMovement = 0;
  double moveSpeed = 100;
  int jumpsLeft = 2;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool isOnLeftWall = false;
  bool isOnRightWall = false;
  bool isOnAir = false;
  bool isGoingLeft = false;
  bool isGoingRight = false;
  bool isFacingLeftWall = false;
  bool isFacingRightWall = false;
  bool isFacingRight = false;
  bool isFacingLeft = false;
  bool isRunning = false;
  bool isGoingDown = false;
  bool hasDashed = false;
  bool hasJumped = false;
  bool hasJumpReseted = false;
  bool hasReachedCheckpoint = false;
  bool gotHit = false;
  List<CollisionBlock> collisionBlocks = [];
  CustomHitbox hitbox = CustomHitbox(
      offsetX: 10,
      offsetY: 4,
      width: 14,
      height: 28
  );
  double fixedDeltaTime = 1/60;
  double accumulatedTime = 0;

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
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      if(!gotHit && !hasReachedCheckpoint) {
        _updatePlayerState();
        _updatePlayerMovement(fixedDeltaTime);
        _checkHorizontalCollisions();
        _applyGravity(fixedDeltaTime);
        _checkVerticalCollisions();
      }

      accumulatedTime -= fixedDeltaTime;
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

    hasJumped = keysPressed.contains(LogicalKeyboardKey.arrowUp) || keysPressed.contains(LogicalKeyboardKey.keyW);

    hasDashed = keysPressed.contains(LogicalKeyboardKey.space);


    if (isLeftKeyPressed) {
      isGoingLeft = true;
      print("esquerda");
      print(isGoingLeft);
    } else {
      isGoingLeft = false;
      print("direita");
      print(isGoingRight);
    }
    if(isRightKeyPressed) {
      isGoingRight = true;
    } else {
      isGoingRight = false;
    }

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
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(!hasReachedCheckpoint) {
      if (other is Fruit) other.collidedWithPlayer();
      if (other is Saw) _respawn();
      if (other is Spikes) _respawn();
      if (other is Checkpoint) _reachedCheckpoint();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(!hasReachedCheckpoint) {
      if (other is MovablePlatform) {
        if (other.isVertical) {
          position.y = other.y - 32;

          if (hasJumped) {
            if (velocity.y < 0) {
              velocity.y = -_jumpForce * 2;
            } else {
              velocity.y = -_jumpForce;
            }
            position.y += velocity.y * fixedDeltaTime;
            isOnGround = false;
          }

          if (velocity.x < 0 && scale.x > 0 || velocity.x > 0 && scale.x < 0) {
            current = PlayerState.running;
          } else if(velocity.x == 0) {
            current = PlayerState.idle;
          }

        }
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation("Idle", 11, 32);

    runningAnimation = _spriteAnimation("Run", 12, 32);

    jumpingAnimation = _spriteAnimation("Jump", 1, 32);

    fallingAnimation = _spriteAnimation("Fall", 1, 32);

    hitAnimation = _spriteAnimation("Hit", 7, 32)..loop = false;

    appearingAnimation = _appearingAnimation();

    disappearingAnimation = _disappearingAnimation();

    doubleJumpingAnimation = _spriteAnimation("Double Jump", 6, 32);
    //list all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.appearing: appearingAnimation,
      PlayerState.finishedLevel: disappearingAnimation,
      PlayerState.doubleJumping: doubleJumpingAnimation,
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
      loop: false,
    ),
  );   
}

  SpriteAnimation _disappearingAnimation() {
    print("Appears");
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("Main Characters/Disappearing (96x96).png"), SpriteAnimationData.sequenced(
      amount: 7,
      stepTime: stepTime,
      textureSize: Vector2.all(96),
      loop: false,
    ),
    );
  }

  void _updatePlayerMovement(double dt) {

    if(!isOnGround && !isOnLeftWall || !isOnGround && !isOnRightWall) {
      isOnAir = true;
    }

    if(isOnGround) {
      jumpsLeft = 2;
      isOnAir = false;
      hasJumpReseted = true;
      if (hasJumped && hasJumpReseted) {
        jumpsLeft--;
        _playerJump(dt);
        hasJumpReseted = false;
        hasJumped = false;
        if(isOnGround) {
          hasJumped = false;
        }
      }
      if (isRunning) {
        position.x += velocity.x * 1.03 * dt;
      }
    } else if (!isOnGround){
      if (hasJumped) {
        if (jumpsLeft > 0) {
          _playerJump(dt);
          jumpsLeft = 0;
          hasJumpReseted = false;
        }
      }
      if (isRunning) {
        position.x += velocity.x * 1.03 * dt;
      }
    }

    if(isFacingLeftWall) {
      if (!isGoingLeft && isGoingRight && hasJumpReseted) {
        jumpsLeft = 1;
      }
      if(isOnLeftWall) {
        hasJumpReseted = true;
        if (hasJumped && jumpsLeft > 0 && hasJumpReseted) {
          _playerJump(dt);
          jumpsLeft--;
          hasJumpReseted = false;
        }
      }
    } else if(isFacingRightWall) {
      if (!isGoingRight && isGoingLeft && hasJumpReseted) {
        jumpsLeft = 1;
      }
      if(isOnRightWall) {
        hasJumpReseted = true;
        if (hasJumped && jumpsLeft > 0 && hasJumpReseted) {
          _playerJump(dt);
          jumpsLeft--;
          hasJumpReseted = false;
        }
      }
    }

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if(velocity.x < 0 && scale.x > 0) {
      isFacingLeft = true;
      isFacingRight = false;
      flipHorizontallyAroundCenter();
    } if (velocity.x > 0 && scale.x < 0) {
      isFacingLeft = false;
      isFacingRight = true;
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
            isOnRightWall = true;
            isFacingRightWall = true;
            isFacingLeftWall = false;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            isOnLeftWall = true;
            isFacingRightWall = false;
            isFacingLeftWall = true;
            break;
          }
        } else {
          isOnRightWall = false;
          isOnLeftWall = false;
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

  void _respawn() async {
    const duration = Duration(milliseconds: 350);
    const appearingDuration = Duration(milliseconds: 350);
    const canMoveDuration = Duration(milliseconds: 200);

    gotHit = true;
    current = PlayerState.hit;

    await animationTicker?.completed;
    animationTicker?.reset();

    scale.x = 1;
    position = startingPosition - Vector2.all(32);
    current = PlayerState.appearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    velocity = Vector2.zero();
    position = startingPosition;
    _updatePlayerState();
    Future.delayed(canMoveDuration, () {
      gotHit = false;
    });

  }

  void _reachedCheckpoint() {
    hasReachedCheckpoint = true;

    if(scale.x > 0){
      position = position - Vector2.all(32);
    } else if (scale.x < 0) {
      position = position + Vector2(32, -32);
    }

    current = PlayerState.finishedLevel;

    Future.delayed(const Duration(milliseconds: 350), (){
      hasReachedCheckpoint = false;
      position = Vector2.all(-640);

      Future.delayed(const Duration(seconds: 3), () {
        game.loadNextLevel();
      });
    });
  }

}