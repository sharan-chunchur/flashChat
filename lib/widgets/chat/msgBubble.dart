import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MsgBubble extends StatelessWidget {
  final String message;
  final String username;
  final bool isMe;
  final Key? key;
  final String dp;

  MsgBubble(
      {required this.message,
      required this.username,
      required this.isMe,
      required this.key,
      required this.dp});

  final _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: isMe
            ? AlignmentDirectional.bottomEnd
            : AlignmentDirectional.bottomStart,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: isMe
                      ? Colors.grey[300]
                      : Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(!isMe ? 0 : 12),
                    topRight: Radius.circular(isMe ? 0 : 12),
                    bottomLeft: const Radius.circular(12),
                    bottomRight: const Radius.circular(12),
                  ),
                ),
                width: 250,
                padding:EdgeInsets.fromLTRB(isMe ? 16 : 36, 10, isMe ? 36 : 16, 10),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        username,
                        style: TextStyle(
                          color: isMe
                              ? Colors.black
                              : Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        color: isMe
                            ? Colors.black
                            : Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).disabledColor,
            backgroundImage: NetworkImage(dp),
          ),
        ]);
  }
}
