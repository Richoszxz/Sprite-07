import 'package:flame/sprite.dart';
import 'package:flame/components.dart';

extension CreateAnimationByLimit on SpriteSheet {
  SpriteAnimation createAnimationByLimit({
    required int xInit, // kolom awal
    required int yInit, // baris awal
    required int step,   // jumlah langkah/frame
    required int sizeX, // jumlah kolom dalam sprite sheet
    required double stepTime, // kecepatan animasi
    bool loop = true,
  }) {
    final List<Sprite> spriteList = [];

    int x = xInit;
    int y = yInit - 1;

    for (var i = 0; i < step; i++) {
      if(y >= sizeX) {
        y=0;
        x++;
      } else {
        y++;
      }

      spriteList.add(getSprite(x,y));
    }
    return SpriteAnimation.spriteList(spriteList, stepTime: stepTime, loop: loop);
  }
}