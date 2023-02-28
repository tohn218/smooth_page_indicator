import 'package:flutter/material.dart';

import '../effects/expanding_dots_effect.dart';
import 'indicator_painter.dart';

class ExpandingDotsPainter extends BasicIndicatorPainter {
  final ExpandingDotsEffect effect;

  ExpandingDotsPainter({
    required double offset,
    required this.effect,
    required int count,
  }) : super(offset, count, effect);

  @override
  void paint(Canvas canvas, Size size) {
    final current = offset.floor();
    var drawingOffset = -effect.spacing;
    final dotOffset = offset - current;

    for (var i = 0; i < count; i++) {
      var color = effect.dotColor;
      final activeDotWidth = effect.dotWidth * effect.expansionFactor;
      final expansion =
          (dotOffset / 2 * ((activeDotWidth - effect.dotWidth) / .5));
      final xPos = drawingOffset + effect.spacing;
      var width = effect.dotWidth;
      if (i == current) {
        // ! Both a and b are non nullable
        color = Color.lerp(effect.activeDotColor, effect.dotColor, dotOffset)!;
        width = activeDotWidth - expansion;
      } else if (i - 1 == current || (i == 0 && offset > count - 1)) {
        width = effect.dotWidth + expansion;
        // ! Both a and b are non nullable
        color = Color.lerp(
            effect.activeDotColor, effect.dotColor, 1.0 - dotOffset)!;
      }
      final yPos = size.height / 2;
      final rRect = RRect.fromLTRBR(
        xPos,
        yPos - effect.dotHeight / 2,
        xPos + width,
        yPos + effect.dotHeight / 2,
        dotRadius,
      );
      drawingOffset = rRect.right;
      if(effect.isEnableDotColorGradient){
        canvas.drawRRect(rRect, dotPaint..shader = LinearGradient(
          end:Alignment.bottomCenter ,
          begin: Alignment.topCenter,
          colors: effect.gradient ?? <Color>[const Color(0xff2F6BC3), const Color(0xff1C8BDC), const Color(0xff01D4FE)],
        ).createShader(effect.rect ?? const Rect.fromLTWH(0.5, 0, 56, 8)));
      }else{
        canvas.drawRRect(rRect, dotPaint..color = color);
      }
    }
  }
}
