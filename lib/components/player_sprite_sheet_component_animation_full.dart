import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';

import 'package:sprite_07/utils/create_animation_by_limit.dart';

class PlayerSpriteSheetComponentAnimationFull extends SpriteAnimationComponent with HasGameReference, KeyboardHandler, TapCallbacks {
  // Variabel untuk ukuran layar
  late double screenWidth;
  late double screenHeight;

  // Posisi tengah layar
  late double centerX;
  late double centerY;

  // Ukuran tiap frame dalam spritesheet (per tile)
  final double spriteSheetWidth = 680;
  final double spriteSheetHeight = 472;

  // Kumpulan animasi
  late SpriteAnimation deadAnimation;
  late SpriteAnimation idleAnimation;
  late SpriteAnimation jumpAnimation;
  late SpriteAnimation runAnimation;
  late SpriteAnimation walkAnimation;

  // Variabel pergerakan
  final double moveSpeed = 200.0; // Pixels per second
  bool isMovingLeft = false;
  bool isMovingRight = false;

  // Untuk mengatur animasi yang aktif
  int currentAnimationIndex = 0;
  final List<SpriteAnimation> animations = [];

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load gambar spritesheet
    final spriteImages = await Flame.images.load('dinofull.png');

    // Buat spritesheet dengan ukuran tiap frame
    final spriteSheet = SpriteSheet(
      image: spriteImages,
      srcSize: Vector2(spriteSheetWidth, spriteSheetHeight),
    );

    // Membuat berbagai animasi dari spritesheet
    deadAnimation = spriteSheet.createAnimationByLimit(xInit: 0, yInit: 0, step: 8, sizeX: 5, stepTime: .08);
    idleAnimation = spriteSheet.createAnimationByLimit(xInit: 1, yInit: 2, step: 10, sizeX: 5, stepTime: .08);
    jumpAnimation = spriteSheet.createAnimationByLimit(xInit: 3, yInit: 0, step: 12, sizeX: 5, stepTime: .08);
    runAnimation = spriteSheet.createAnimationByLimit(xInit: 5, yInit: 0, step: 8, sizeX: 5, stepTime: .08);
    walkAnimation = spriteSheet.createAnimationByLimit(xInit: 6, yInit: 2, step: 10, sizeX: 5, stepTime: .08);

    // Masukkan semua animasi ke dalam list
    animations.addAll([jumpAnimation, walkAnimation, deadAnimation, idleAnimation, runAnimation]);

    // Set animasi awal aplikasi di jalankan (LONCAT)
    animation = jumpAnimation;

    // Ambil ukuran layar dari HasGameReference
    screenWidth = game.size.x;
    screenHeight = game.size.y;

    // Hitung posisi tengah
    centerX = (screenWidth / 2) - (spriteSheetWidth / 2);
    centerY = (screenHeight / 2) - (spriteSheetHeight / 2);

    // Set posisi awal player di tengah layar
    position = Vector2(centerX, centerY);
  }

  // HANDLER UNTUK KEYBOARD INPUT KIRI KANAN
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Jika tombol arah kiri ditekan
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      isMovingLeft = true;

    // Jika tombol arah kanan ditekan
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      isMovingRight = true;

    // Jika tidak ada tombol ditekan
    } else {
      isMovingLeft = false;
      isMovingRight = false;
    }
    return false; // return false agar event bisa dilanjutkan ke handler lain
  }

  // UPDATE PER FRAME (DIJALANKAN TIAP FRAME GAME BERJALAN)
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

  // HANDLER UNTUK TAP PADA LAYAR
  @override
  bool onTapDown(TapDownEvent event) {
    // Setiap kali di-tap, ganti animasi berikutnya
    currentAnimationIndex = (currentAnimationIndex + 1) % animations.length;
    animation = animations[currentAnimationIndex];
    return true; // event tap dianggap sudah dipakai
  }
}