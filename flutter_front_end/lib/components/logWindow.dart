import 'package:flutter/material.dart';
import 'package:flutter_front_end/components/chatMessage.dart';

class logWindow extends StatelessWidget {
  logWindow({required this.messages});

  List<ChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView.builder(
          itemCount: messages.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        messages[index].messageType,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, right: 16, left: 6),
                        child: Text(
                          messages[index].messageContent,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
