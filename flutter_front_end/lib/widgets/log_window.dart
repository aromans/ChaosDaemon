import 'package:flutter/material.dart';
import 'package:flutter_front_end/widgets/chat_message.dart';

//ignore: must_be_immutable
class LogWindow extends StatelessWidget {
  LogWindow({required this.messages});

  List<ChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: messages.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    messages[index].messageType,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Color.fromARGB(255, 88, 176, 156),
                    ),
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, right: 16, left: 6),
                    child: Text(
                      messages[index].messageContent,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
