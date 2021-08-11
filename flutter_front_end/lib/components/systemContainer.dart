import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:touchable/touchable.dart';

import 'Vector.dart';

class SystemContainer {
  late Paint paint;
  late Offset position;
  late Size size;
  late String label;

  late final Offset middleRight;
  late final Offset middleLeft;

  SystemContainer(Paint paint, Vector pos, Vector size, String label) {
    this.paint = paint;
    this.position = Offset(pos.x, pos.y);
    this.size = Size(size.x, size.y);
    this.label = label;

    this.middleLeft = Offset(pos.x, pos.y + (size.y * 0.5));
    this.middleRight = Offset(pos.x + size.x, pos.y + (size.y * 0.5));
  }

  SystemContainer.override(Paint paint, Vector pos, Size size, String label) {
    this.paint = paint;
    this.position = Offset(pos.x, pos.y);
    this.size = size;
    this.label = label;
  }

  void Draw(TouchyCanvas canvas, ParagraphBuilder pb) {
    canvas.drawRect(
      position & size,
      paint,
    );

    pb.addText(label);
    Paragraph p = pb.build();
    p.layout(ParagraphConstraints(width: size.width));

    canvas.drawParagraph(
        p, Offset(position.dx, position.dy + (size.height * 0.25)));
  }

  void SetPosition(Vector pos) {
    this.position = Offset(pos.x, pos.y);
  }
}
