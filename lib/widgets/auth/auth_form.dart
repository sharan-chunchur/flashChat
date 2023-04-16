import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flashchat/pickers/user_image_picker.dart';


class AuthForm extends StatefulWidget {
  final Function submitAuthForm;

  AuthForm(this.submitAuthForm);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var isloginMode = true;
  var _isLoading = false;
  var userEmail = '';
  var userName = '';
  var userPassword = '';
  File? _pickedImage;

  void _imagePickFunc(File? image){
    _pickedImage = image;
  }

  Future<void> _trySubmit() async {
    setState(() {
      _isLoading = true;
    });
    if(_pickedImage == null && !isloginMode){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please upload image'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
    }
    await widget.submitAuthForm(userEmail, userName, _pickedImage, userPassword, isloginMode, context);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isloginMode)UserImagePicker(_imagePickFunc),
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter valid mail';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: 'Email address'),
                    onSaved: (value) {
                      userEmail = value!;
                    },
                  ),
                  if (!isloginMode)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Atleast 5 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Username'),
                      onSaved: (value) {
                        userName = value!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Weak Password';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    onSaved: (value) {
                      userPassword = value!;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _trySubmit,
                          child: Text(isloginMode ? 'Login' : 'SignUp'),
                        ),
                  if (!_isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isloginMode = !isloginMode;
                        });
                      },
                      child: Text(isloginMode
                          ? 'Create new account'
                          : 'Already have an account? sign in'),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
