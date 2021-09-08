import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_front_end/widgets/expandable_panel_vert.dart';
import 'package:flutter_front_end/widgets/expanded_panel_1.dart';
import 'package:flutter_front_end/widgets/expanded_panel_stat_system.dart';
import 'package:flutter_front_end/widgets/log_window.dart';
import 'package:provider/provider.dart';

// Custom files
import 'package:flutter_front_end/screens/second_screen.dart';
import 'package:flutter_front_end/widgets/chat_message.dart';
import 'package:flutter_front_end/widgets/status_bar.dart';
import 'package:flutter_front_end/system_overview/system_status_window.dart';
import 'package:flutter_front_end/models/dark_mode_status.dart';
import 'package:flutter_front_end/widgets/scenario_window.dart';
import 'system_overview/models/system_container_set.dart';
import 'package:window_size/window_size.dart';

void main() async {
  // modify with your true address/port
  WidgetsFlutterBinding.ensureInitialized();

  SystemContainerSet systemContainers = SystemContainerSet();

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
    const Color textColor = Color.fromARGB(255, 240, 239, 244);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DarkModeStatus(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'SF-Pro-Text',
          textTheme: const TextTheme(
            bodyText1: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'SF-Pro-Text'),
            bodyText2: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'SF-Pro-Text'),
            headline1: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF-Pro-Rounded'),
            headline2: TextStyle(
                color: textColor,
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
    BoxDecoration scenarioPanelBoxDecoration = BoxDecoration(
      color: Color.fromARGB(255, 19, 21, 22),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(0)),
    );

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 61),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /* SCENARIO WINDOW (LEFT SIDE) */
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.2 - 7,
            //   height: MediaQuery.of(context).size.height,
            //   child: ScenarioWindow(),
            //   /* SOA-ESB STATUS WINDOW (MIDDLE) */
            // ),
            Container(
              margin: EdgeInsets.all(0),
              alignment: Alignment.centerLeft,
              child: ExpandablePanelVert(true, 250, Color.fromARGB(255, 46, 40, 54)),
            ),
            // VerticalDivider(
            //   thickness: 5,
            //   color: Colors.grey.shade900,
            //   width: 5,
            // ),
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.6,
            //   height: MediaQuery.of(context).size.height,
            //   color: Colors.grey.shade200,
            //   child: SystemStatusWindow(),
            // ),
            Expanded(
              child: SystemStatusWindow(),
            ),
            /* LOG VIEW WINDOW (RIGHT SIDE) */
            // VerticalDivider(
            //   thickness: 5,
            //   color: Colors.grey.shade900,
            //   width: 5,
            // ),
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.2 - 7,
            //   height: MediaQuery.of(context).size.height,
            //   child: LogWindow(messages: messages),
            //   // TextFormField(
            //   //     onChanged: (String? value) {
            //   //       this.command = value;
            //   //     },
            //   //     decoration: InputDecoration(
            //   //       border: UnderlineInputBorder(),
            //   //       labelText: 'Send your command!',
            //   //     )),
            // ),
            Container(
              margin: EdgeInsets.all(0),
              alignment: Alignment.centerLeft,
              child: ExpandablePanelVert(false, 250, Color.fromARGB(255, 46, 40, 54)),
            ),
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
