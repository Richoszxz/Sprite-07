import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';

import 'package:sprite_07/utils/create_animation_by_limit.dart';

class PlayerSpriteSheetComponentAnimationFull extends SpriteAnimationComponent with HasGameReference, KeyboardHandler, TapCallbacks {
  late double screenWidth;
  late double screenHeight;

  late double centerX;
  late double centerY;

  final double spriteSheetWidth = 680;
  final double spriteSheetHeight = 472;

  late SpriteAnimation deadAnimation;
  late SpriteAnimation idleAnimation;
  late SpriteAnimation jumpAnimation;
  late SpriteAnimation runAnimation;
  late SpriteAnimation walkAnimation;

  // Movement variables
  final double moveSpeed = 200.0; // Pixels per second
  bool isMovingLeft = false;
  bool isMovingRight = false;

  // Animation state management
  int currentAnimationIndex = 0;
  final List<SpriteAnimation> animations = [];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final spriteImages = await Flame.images.load('dinofull.png');
    final spriteSheet = SpriteSheet(
      image: spriteImages,
      srcSize: Vector2(spriteSheetWidth, spriteSheetHeight),
    );

    // Initialize animations
    deadAnimation = spriteSheet.createAnimationByLimit(xInit: 0, yInit: 0, step: 8, sizeX: 5, stepTime: .08);
    idleAnimation = spriteSheet.createAnimationByLimit(xInit: 1, yInit: 2, step: 10, sizeX: 5, stepTime: .08);
    jumpAnimation = spriteSheet.createAnimationByLimit(xInit: 3, yInit: 0, step: 12, sizeX: 5, stepTime: .08);
    runAnimation = spriteSheet.createAnimationByLimit(xInit: 5, yInit: 0, step: 8, sizeX: 5, stepTime: .08);
    walkAnimation = spriteSheet.createAnimationByLimit(xInit: 6, yInit: 2, step: 10, sizeX: 5, stepTime: .08);

    // Add animations to list for cycling
    animations.addAll([jumpAnimation, walkAnimation, deadAnimation, idleAnimation, runAnimation]);

    // Set initial animation
    animation = jumpAnimation;

    screenWidth = game.size.x;
    screenHeight = game.size.y;

    centerX = (screenWidth / 2) - (spriteSheetWidth / 2);
    centerY = (screenHeight / 2) - (spriteSheetHeight / 2);

    position = Vector2(centerX, centerY);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      isMovingLeft = true;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      isMovingRight = true;
    } else {
      isMovingLeft = false;
      isMovingRight = false;
    }
    return false;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Mengatur pergerakan berdasarkan keyboard
    if (isMovingLeft) {
      scale.x = -1;
      animation = runAnimation;
      position.x -= 100 * dt; // Bergerak ke kiri
    } else if (isMovingRight) {
      scale.x = 1;
      animation = runAnimation;
      position.x += 100 * dt; // Bergerak ke kanan
    }
  }

  @override
  bool onTapDown(TapDownEvent event) {
    // Cycle through animations on tap
    currentAnimationIndex = (currentAnimationIndex + 1) % animations.length;
    animation = animations[currentAnimationIndex];
    return true;
  }
}