import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' as fm;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' as fw;
import 'Vector.dart';

class SystemContainer extends fm.ChangeNotifier {
  late Paint paint;
  late Offset position;
  late Size size;
  late String label;

  late final Offset middleRight;
  late final Offset middleLeft;

  late Canvas canvas;
  late ParagraphBuilder pb;

  bool hovering = false;


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

  void isHovering() {
    this.hovering = true;
    notifyListeners();
  }

  void Draw(Canvas canvas, ParagraphBuilder pb, {hasShadow = false}) {
    this.canvas = canvas;
    this.pb = pb;
    const Radius r = Radius.circular(10.0);

    if (hasShadow) {
      canvas.drawRRect(
          fw.BorderRadius.all(r)
              .resolve(TextDirection.ltr)
              .toRRect(position & size),
          new Paint()
            ..style = PaintingStyle.stroke
            ..color = fm.Colors.green.withOpacity(1)
            ..strokeWidth = 1.0);
    } else {
      canvas.drawRRect(
          fw.BorderRadius.all(r)
              .resolve(TextDirection.ltr)
              .toRRect(position & size),
          new Paint()
            ..style = PaintingStyle.stroke
            ..color = fm.Colors.green.withOpacity(0.25)
            ..strokeWidth = 5.0);
    }

    pb.addText(label);
    Paragraph p = pb.build();
    pb.pop();
    pb.pushStyle(TextStyle(
        color: Color.fromARGB(255, 0, 0, 0),
        fontWeight: FontWeight.normal,
        fontSize: 14));
    p.layout(ParagraphConstraints(width: size.width));

    canvas.drawParagraph(
        p,
        Offset(position.dx + (size.width - p.maxIntrinsicWidth) * 0.5,
            position.dy + (size.height * 0.15)));

    pb.addText(
        'Uptime: 3.2hrs\nPackets S/R: 456/87\nPacket Loss: 4%\nCPU 1.2 Ghz\nMemory: 75% (3/4 Gib)');
    Paragraph p2 = pb.build();
    pb.pop();
    pb.pushStyle(TextStyle(color: Color.fromARGB(255, 0, 0, 0)));
    p2.layout(ParagraphConstraints(width: size.width));

    canvas.drawParagraph(
        p2,
        Offset(position.dx + (size.width * 0.05),
            position.dy + (size.height * 0.35)));
  }

  bool Selected(Offset pos) {
    return position.dx + size.width > pos.dx &&
        position.dx < pos.dx &&
        position.dy + size.height > pos.dy &&
        position.dy < pos.dy;
  }

  void SetPosition(Vector pos) {
    this.position = Offset(pos.x, pos.y);
  }
}
