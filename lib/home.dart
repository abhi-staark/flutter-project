import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app2/add_task.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = '';
  @override
  void initState() {
    getuid();
    super.initState();
  }

  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final Firebaseuser = await auth.currentUser;
    setState(() {
      uid = Firebaseuser!.uid;
    });

    ;
  }

  @override
  Widget build(BuildContext context) {
    //String? uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('TO DO LIST'),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),

      //---------------------------------------------------------------------------------------------
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context)
            .size
            .height, //body sets to the actual height of the app ui available
        width: MediaQuery.of(context)
            .size
            .width, //body sets to the actual width of the app ui available
        color: Colors.white,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                .doc(uid)
                .collection('mytasks')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10)),
                      height: 60,
                      //color: Colors.blue,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Text(
                                        docs[index]['title'],
                                        style: TextStyle(fontSize: 20),
                                      )),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    //child: Text(DateFormat.yMd()
                                    //.add_jm()
                                    //.format(time))
                                  )
                                ]),
                            Container(
                                child: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                    ),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('tasks')
                                          .doc(uid)
                                          .collection('mytasks')
                                          .doc(docs[index]['time'])
                                          .delete();
                                    }))
                          ]),
                      //child: Column(children: [Text(docs[index]['title'])]),
                    );
                  },
                );
              }
            }),
      ),

      //-----------------------------------------------------------------------------------------
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTask(),
              ));
        },
      ),
    );
  }
}
