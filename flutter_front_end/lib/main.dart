import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

// Custom files
import 'package:flutter_front_end/screens/second_screen.dart';
import 'package:flutter_front_end/widgets/chat_message.dart';
import 'package:flutter_front_end/widgets/status_bar.dart';
import 'package:flutter_front_end/screens/system_status_window.dart';
import 'package:flutter_front_end/models/dark_mode_status.dart';
import './models/system_containers.dart';
import 'package:window_size/window_size.dart';

void main() async {
  // modify with your true address/port
  WidgetsFlutterBinding.ensureInitialized();

  setWindowMinSize(const Size(475, 500));

  Socket sock = await Socket.connect('localhost', 3000);

  runApp(DiagnosticLens(sock));
}
//ignore: must_be_immutable
class DiagnosticLens extends StatelessWidget {
  Socket? socket;

  DiagnosticLens(Socket s) {
    this.socket = s;
    _sendConnectionHeader(this.socket);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SystemContainers(),
        ),
        ChangeNotifierProvider(create: (_) => DarkModeStatus(),)
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'SF-Pro-Text',
          textTheme: const TextTheme(
            bodyText1: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'SF-Pro-Text'),
            bodyText2: TextStyle(
                color: Color.fromARGB(180, 255, 255, 255),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'SF-Pro-Text'),
            headline1: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF-Pro-Rounded'),
            headline2: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF-Pro-Display'),
          ),
        ),
        routes: <String, WidgetBuilder>{
          '/': (context) => MyHomePage(title: "Flutter Home", channel: socket),
          '/scenarioCreator': (context) => SecondScreen(),
        },
      ),
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
  String? command = "";
  //Socket? serverSocket;

  //_MyHomePageState(this.serverSocket) {}

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


  String serverConnection() {
    // if (serverSocket?.isEmpty == false) {
    return "OK";
    //}
    //return "NOT CONNECTED";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /* SCENARIO WINDOW (LEFT SIDE) */
            // Expanded(
            //   child: Container(
            //       //width: MediaQuery.of(context).size.width * 0.25 - 10,
            //       //height: MediaQuery.of(context).size.height,
            //       child: scenarioWindow()),
            //   /* SOA-ESB STATUS WINDOW (MIDDLE) */
            // ),
            // VerticalDivider(
            //   thickness: 5,
            //   color: Colors.grey.shade900,
            //   width: 5,
            // ),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height,
              color: Colors.grey.shade200,
              child: SystemStatusWindow(),
            ),
            /* LOG VIEW WINDOW (RIGHT SIDE) */
            // VerticalDivider(
            //   thickness: 5,
            //   color: Colors.grey.shade900,
            //   width: 5,
            // ),
            // Expanded(
            //   child: Container(
            //       //width: MediaQuery.of(context).size.width * 0.25 - 10,
            //       //height: MediaQuery.of(context).size.height,
            //       child: logWindow(messages: messages)),
            // TextFormField(
            //     onChanged: (String? value) {
            //       this.command = value;
            //     },
            //     decoration: InputDecoration(
            //       border: UnderlineInputBorder(),
            //       labelText: 'Send your command!',
            //     )),
            // )
          ],
        ),
      ),
      bottomNavigationBar: StatusBar(serverConnection(), "OK"),
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

  // void _sendMessage() {
  //   String message = this.command ?? "";
  //   print("Message: " + message);
  //   widget.channel?.write(message);
  //   this.command = "";
  // }

  @override
  void dispose() {
    widget.channel?.close();
    super.dispose();
  }
}
