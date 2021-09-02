import 'dart:ui';
import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  final String label;
  final String value;

  StatItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: this.label + ': ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              )),
          TextSpan(
              text: this.value,
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
