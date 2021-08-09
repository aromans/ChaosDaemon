import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Second Screen!!"),
      ),
      body: new Text("Wub a lub a dub dub!"),
    );
  }
}
