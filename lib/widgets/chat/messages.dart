import 'msgBubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  final _fireStore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.value(_firebaseAuth.currentUser),
        builder: (ctx, futureSnapShot) {
          return StreamBuilder(
            stream: _fireStore
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (ctx, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = snapshots.data!.docs;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs!.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: MsgBubble(
                        message: chatDocs[index]['text'],
                        username: chatDocs[index]['username'],
                        isMe: chatDocs[index]['userId'] ==
                            futureSnapShot.data!.uid,
                        dp: chatDocs[index]['imageUrl'],
                        key: ValueKey(chatDocs[index].id),
                      ),
                    ),
                  );
                },
              );
            },
          );
        });
  }
}
