import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'Vector.dart';

class SystemContainer2 extends StatefulWidget {
  const SystemContainer2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SystemContainer2State();
  }
}

class SystemContainer2State extends State<SystemContainer2> {
  Color backgroundColor = Colors.blue;
  Color borderColor = Colors.blue;
  Color currentBorderColor = Colors.red.shade900;
  Color currentColor = Colors.red.shade900;
  Color nextBorderColor = Colors.yellow.shade800;
  Color nextColor = Colors.yellow.shade800;
  int numberOfClicks = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: <MouseRegion>[
      MouseRegion(
        onEnter: (PointerEnterEvent enterEvent) {
          print('hey!');
        },
        onExit: (PointerExitEvent exitEvent) {
          print('bye!');
        },
        child: GestureDetector(
          onTapUp: (TapUpDetails tapUpDetails) {
            this.numberOfClicks++;
            if (this.numberOfClicks % 2 == 0) {
              this.borderColor = Colors.blue;
            } else {
              this.borderColor = Colors.green.shade700;
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(width: 5.0, color: Colors.blue)),
            margin: const EdgeInsets.all(0.0),
            width: 175.0,
            height: 175.0,
            padding: EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      'SOLR 2',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <RichText>[
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: const <TextSpan>[
                                TextSpan(
                                    text: 'Memory: ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                    )),
                                TextSpan(
                                    text: '75%',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: const <TextSpan>[
                                TextSpan(
                                    text: 'Packets S/R: ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                    )),
                                TextSpan(
                                    text: '456/87',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: const <TextSpan>[
                                TextSpan(
                                    text: 'Packet Loss: ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                    )),
                                TextSpan(
                                    text: '4%',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: const <TextSpan>[
                                TextSpan(
                                    text: 'CPU: ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                    )),
                                TextSpan(
                                    text: '1.2 Ghz',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: const <TextSpan>[
                                TextSpan(
                                    text: 'Uptime: ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                    )),
                                TextSpan(
                                    text: '3.2 hrs',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      MouseRegion(
        child: Container(
            decoration: BoxDecoration(
                color: this.currentColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(width: 5.0, color: this.currentBorderColor)),
            margin: const EdgeInsets.all(1.0),
            width: 45,
            height: 175.0,
            child: RotatedBox(
                quarterTurns: 3,
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Current Scenario',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    )))),
      ),
      MouseRegion(
        child: Container(
            decoration: BoxDecoration(
                color: this.nextColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(width: 5.0, color: this.nextBorderColor)),
            margin: const EdgeInsets.all(1.0),
            width: 45,
            height: 175.0,
            child: RotatedBox(
                quarterTurns: 3,
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Next Scenario',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    )))),
      ),
    ]);
  }
}
