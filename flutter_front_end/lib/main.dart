import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

// Custom files
import 'package:flutter_front_end/screens/SecondScreen.dart';
import 'package:flutter_front_end/components/logWindow.dart';
import 'package:flutter_front_end/components/scenarioWindow.dart';
import 'package:flutter_front_end/components/chatMessage.dart';
import 'package:flutter_front_end/components/statusBar.dart';

void main() async {
  // modify with your true address/port
  Socket sock = await Socket.connect('localhost', 3000);

  runApp(MyApp(sock));
}

class MyApp extends StatelessWidget {
  Socket? socket;

  MyApp(Socket s) {
    this.socket = s;
    _sendConnectionHeader(this.socket);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/': (context) => MyHomePage(title: "Flutter Home", channel: socket),
        '/scenarioCreator': (context) => SecondScreen(),
      },
    );
  }
}

void _sendConnectionHeader(Socket? socket) {
  String message = _compileHeader("Connection") + "";
  socket?.write(message);
}

String _compileHeader(String request) {
  String clientID = "ClientID: Flutter ";
  String requestType = "Request: " + request + " ";
  String header = clientID + requestType;
  return header;
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title, required this.channel})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final Socket? channel;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? command = "";

  List<ChatMessage> messages = [
    ChatMessage(messageContent: "This is a log #1", messageType: "HAProxy"),
    ChatMessage(messageContent: "This is a second log #2", messageType: "Solr"),
    ChatMessage(
        messageContent:
            "This is a very slightly ever so slightly longer log #3",
        messageType: "FMV"),
    ChatMessage(
        messageContent: "This is another short log #4", messageType: "HAProxy"),
    ChatMessage(messageContent: "Shorter log #5", messageType: "HAProxy"),
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color.fromARGB(255, 11, 213, 163),
        foregroundColor: Color.fromARGB(255, 11, 213, 163),
        toolbarHeight: 35,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /* SCENARIO WINDOW (LEFT SIDE) */
            Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height,
                child: scenarioWindow()),
            /* SOA-ESB STATUS WINDOW (MIDDLE) */
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height,
              color: Colors.amber,
            ),
            /* LOG VIEW WINDOW (RIGHT SIDE) */
            Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height,
                child: logWindow(messages: messages)),
            // TextFormField(
            //     onChanged: (String? value) {
            //       this.command = value;
            //     },
            //     decoration: InputDecoration(
            //       border: UnderlineInputBorder(),
            //       labelText: 'Send your command!',
            //     )),
          ],
        ),
      ),
      bottomNavigationBar: statusBar(),
      // floatingActionButton: Row(
      //   children: [
      //     FloatingActionButton(
      //       onPressed: _sendMessage,
      //       tooltip: 'Send Message',
      //       child: Icon(Icons.send),
      //     ),
      //     FloatingActionButton(
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           new MaterialPageRoute(
      //               builder: (context) => new SecondScreen()),
      //         );
      //       },
      //       tooltip: 'Go to next screen',
      //       child: Icon(Icons.access_alarm),
      //     ),
      //   ],
      // ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    String message = this.command ?? "";
    print("Message: " + message);
    widget.channel?.write(message);
    this.command = "";
  }

  @override
  void dispose() {
    widget.channel?.close();
    super.dispose();
  }
}
