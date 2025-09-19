import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'components/player_sprite_sheet_component_animation.dart';
import 'components/player_sprite_sheet_component_animation_full.dart';
import 'package:flutter/material.dart';

// 'HasKeyboardHandlerComponents' mixin yang berfungsi mengaktifkan distribusi event keyboard ke semua komponen dalam game yang implement KeyboardHandler.
class MyGame extends FlameGame with HasKeyboardHandlerComponents {
  @override
  void onLoad() async {
    super.onLoad();
    add(PlayerSpriteSheetComponentAnimationFull());
  }
}

void main() async {
  runApp(GameWidget(game: MyGame()));
}