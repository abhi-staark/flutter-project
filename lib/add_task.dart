//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTask extends StatefulWidget {
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  //-----------------Adding Task to firebase------------------------------------
  addtasktofirebase() async {
    //one user should not see the task of other user
    //solution: get unique id on each user
    FirebaseAuth auth = FirebaseAuth.instance;
    final firebaseuser = await auth.currentUser;
    String uid = firebaseuser!.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time.toString())
        .set({
      'title': titleController.text,
      'description': descriptionController.text,
      'time': time.toString(),
      'timestamp': time
    });
    //fluttertoast just a popup mesaage
    Fluttertoast.showToast(msg: 'Data Added');
  }

//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar:
            AppBar(title: const Text('New Task'), backgroundColor: Colors.red),
        body: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                //-----------------------------------------------------------
                const SizedBox(height: 10.0),
                Container(
                    child: Column(
                  children: [
                    Container(
                      child: TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                            labelText: 'enter description',
                            border: OutlineInputBorder()),
                      ),
                    ),
                    //---------------------------------------------------------
                    const SizedBox(height: 10),
                    Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.white;
                            }
                            return Theme.of(context).primaryColor;
                          })),
                          child: const Text(
                            'Add task',
                            selectionColor: Colors.white,
                          ),
                          onPressed: () {
                            //task addition along with time of addition of task
                            addtasktofirebase();
                          },
                        ))
                  ],
                )),
              ],
            )));
  }
}
