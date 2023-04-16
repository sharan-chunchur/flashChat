import 'package:flashchat/widgets/chat/messages.dart';
import 'package:flashchat/widgets/chat/new_message.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _fireStore = FirebaseFirestore.instance;

  final _firebaseAuth = FirebaseAuth.instance;

  void _initNotifications() async {
    final notifications = FirebaseMessaging.instance;
    final settings = await notifications.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }

    FirebaseMessaging.onMessage.listen((msg) {
      print("onMessage: ${msg.data}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      print("onMessageOpenedApp: $msg");
    });
  }

  @override
  void initState() {
    super.initState();

    _initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlashChat'),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Container(
                  child: Row(
                    children: const [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        height: 8,
                      ),
                      Text('logout'),
                    ],
                  ),
                ),
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                _firebaseAuth.signOut();
              }
            },
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Messages()),
          NewMessages(),
        ],
      ),

    );
  }
}
