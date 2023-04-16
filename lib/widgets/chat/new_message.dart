import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({Key? key}) : super(key: key);

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _fireStore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  var _enteredMsg ='';
  var _controller = TextEditingController();


  void _sendMessage() async{
    print(_firebaseAuth.currentUser!.uid);
    FocusScope.of(context).unfocus();
    _controller.clear();
    final user = await _firebaseAuth.currentUser!;
    final userData = await _fireStore.collection('users').doc(user.uid).get();
    _fireStore.collection('chat').add({
      'text' : _enteredMsg,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username':userData['username'],
      'imageUrl':userData['imageUrl'],
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          CircleAvatar(

          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'New Message...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value){
                setState(() {
                  _enteredMsg =value;
                });
              },
            ),
          ),
          IconButton(onPressed: _enteredMsg.trim().isEmpty ? null : _sendMessage, icon: const Icon(Icons.send),color: Theme.of(context).primaryColor,),
        ],
      ),
    );
  }
}
