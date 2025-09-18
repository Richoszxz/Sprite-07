import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'components/player_sprite_sheet_component_animation.dart';
import 'components/player_sprite_sheet_component_animation_full.dart';
import 'package:flutter/material.dart';

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