import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  void _submitAuthForm(
    String email,
    String userName,
    File? image,
    String userPassword,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      if (isLogin) {
        //Firebase login authentication
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: userPassword);
      } else {
        //Firebase Signup authentication
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: userPassword);

        //Firebase storage
        final ref = _storage.ref().child('user_image').child(authResult.user!.uid + '.jpg');
        ref.putFile(image!).whenComplete(() async{
          var url = await ref.getDownloadURL();
          //Firebase Firestore
          _firestore.collection('users').doc(authResult.user!.uid).set({
            'username': userName,
            'email': email,
            'imageUrl': url
          });
        });
      }
    } on FirebaseAuthException catch (e) {
      var msg = 'An error occurred, Please check your credentials';
      if (e.message != null) {
        msg = e.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ),
      );
    } catch (error) {
      print('Printing error');
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm),
    );
  }
}
