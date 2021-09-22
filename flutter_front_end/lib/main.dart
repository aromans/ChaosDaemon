import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_front_end/system_overview/widgets/container_popup/container_information_screen.dart';
import 'package:flutter_front_end/system_overview/widgets/container_popup/log_model.dart';
import 'package:flutter_front_end/system_overview/widgets/container_popup/log_set.dart';
import 'package:flutter_front_end/widgets/expandable_panel_vert.dart';
import 'package:flutter_front_end/widgets/log_window.dart';
import 'package:flutter_front_end/widgets/panel_icon_widget.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

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
        ),
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

  final String title;
  final Socket? channel;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? command = "";

  Map<String, Map> existingContainers = Map<String, Map>();

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
    ChatMessage(messageContent: "This is a log #1", messageType: "HAProxy"),
    ChatMessage(messageContent: "This is a second log #2", messageType: "Solr"),
    ChatMessage(
        messageContent:
            "This is a very slightly ever so slightly longer log #3",
        messageType: "FMV"),
    ChatMessage(
        messageContent: "This is another short log #4", messageType: "HAProxy"),
    ChatMessage(messageContent: "Shorter log #5", messageType: "HAProxy"),
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

  void idkDoStuff() async {
    var client = http.Client();

    Map clientResponse;

    try {
      var response = await client.post(
          Uri.http("127.0.0.1:8080", "/api/v1.0/containers/docker"));

      print("--- IDK DO STUFF");
      // print(response.body);
      clientResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } finally {
    }


    if (clientResponse.containsKey("subcontainers")) {
      var subContainerList = clientResponse["subcontainers"].toList();

      for (int i = 0; i < (subContainerList as List).length; ++i) {
        try {

          String suffix = subContainerList[i]["name"].toString();

          var response = await client.post(
            Uri.http("127.0.0.1:8080", "/api/v1.0/containers$suffix"));

          Map postResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

          String key = postResponse["aliases"][0];

          existingContainers[key] = postResponse;

        } finally {
        }
      }
    }

    client.close();

    List<String> containerNames = existingContainers.keys.toList();
    

    containerNames.forEach((element) { SystemContainerSet.createContainer(element, existingContainers[element]!["stats"]);});
  }

  @override
  void initState() {
    idkDoStuff();
    super.initState();
  }

  String serverConnection() {
    // if (serverSocket?.isEmpty == false) {
    return "OK";
    //}
    //return "NOT CONNECTED";
  }

  @override
  Widget build(BuildContext context) {

    print(SystemContainerSet.itemCount);

    BoxDecoration scenarioPanelBoxDecoration = BoxDecoration(
      color: Color.fromARGB(255, 19, 21, 22),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(0)),
    );

    PanelIconWidget logWindow = PanelIconWidget(
      name: 'Log Window',
      icon: Icon(CupertinoIcons.tray_arrow_up),
      widget: GestureDetector(child: LogWindow(messages: messages)),
    );

    PanelIconWidget scenarioWindow = PanelIconWidget(
      name: 'Scenario Window',
      icon: Icon(CupertinoIcons.tray_arrow_down),
      widget: GestureDetector(child: ScenarioWindow()),
    );

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 61),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /* SCENARIO WINDOW (LEFT SIDE) */
            Container(
              margin: EdgeInsets.all(0),
              alignment: Alignment.centerLeft,
              child: ExpandablePanelVert(
                leftSide: true,
                maxWidth: 400,
                panelColor: Color.fromARGB(255, 46, 40, 54),
                mainWidget: scenarioWindow,
              ),
            ),

            /* SYSTEM OVERVIEW (MIDDLE) */
            Expanded(
              child: SystemStatusWindow(),
            ),

            /* LOG VIEW WINDOW (RIGHT SIDE) */
            Container(
              margin: EdgeInsets.all(0),
              alignment: Alignment.centerLeft,
              child: ExpandablePanelVert(
                leftSide: false,
                maxWidth: 400,
                panelColor: Color.fromARGB(255, 46, 40, 54),
                mainWidget: logWindow,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: StatusBar(serverConnection(), "OK"),
    );
  }

  @override
  void dispose() {
    widget.channel?.close();
    super.dispose();
  }
}

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

// void _sendMessage() {
//   String message = this.command ?? "";
//   print("Message: " + message);
//   widget.channel?.write(message);
//   this.command = "";
// }

// floatingActionButton: Row(
//   children: [
//     FloatingActionButton(
//       onPressed: _sendMessage,
//       tooltip: 'Send Message',
//       child: Icon(Icons.send),
//     ),
//   ],
// ) // This trailing comma makes auto-formatting nicer for build methods.
