// import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page', channel: socket),
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
  String header = clientID + requestType + "\r\n\r\n";
  Uint8List headerUnits = Uint8List.fromList(header.codeUnits);

  print(headerUnits.lengthInBytes);

  int headerBytes = headerUnits.lengthInBytes;
  header = headerBytes.toString() + header;

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
  // final _socket = WebSocketChannel.connect(
  //   Uri.parse('ws://127.0.0.1:3000'),
  // );

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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextFormField(
                onChanged: (String? value) {
                  this.command = value;
                },
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Send your command!',
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send Message',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    String header = _compileHeader("Command");
    String message = header + (this.command ?? "");
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
