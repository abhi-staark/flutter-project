import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;

//------------------------------Authentication

  startauthentication() async {
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (validity) {
      _formkey.currentState!.save();
      submitform(_email, _password, _username);
    }
  }

//---------------------------------form sub,ission

  submitform(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;
    try {
      if (isLoginPage) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = authResult.user!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'ussername': username, 'email': email});
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 19, top: 10, bottom: 10),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isLoginPage)
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          key: const ValueKey('username'),
                          validator: (String? x) {
                            if (x!.isEmpty) {
                              return 'username cant be empty';
                            }
                            return null;
                          },
                          onSaved: (x) {
                            _username = x as String;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide()),
                            labelText: 'Enter username',
                            //labelStyle:
                          ),
                        ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: const ValueKey('email'),
                        validator: (String? x) {
                          if (x!.isEmpty || !x.contains('@')) {
                            return 'Incorrect email';
                          }
                          return null;
                        },
                        onSaved: (x) {
                          _email = x as String;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide()),
                          labelText: 'Enter email',
                          //labelStyle:
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        key: const ValueKey('password'),
                        validator: (String? x) {
                          if (x!.isEmpty) {
                            return 'Incorrect password';
                          }
                          return null;
                        },
                        onSaved: (x) {
                          _password = x as String;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide()),
                          labelText: 'Enter password',
                          //labelStyle:
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: double.infinity,
                        height: 70,
                        child: ElevatedButton(
                          child: isLoginPage ? Text('Login') : Text('SignUp'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {
                            startauthentication();
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                isLoginPage = !isLoginPage;
                              });
                            },
                            child: isLoginPage
                                ? const Text('not  a member')
                                : const Text('already a member')),
                      )
                    ],
                  ),
                ))
          ],
        ));
  }
}
