import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/NewTask.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

class AppListView extends StatefulWidget {
  @override
  _ListViewState createState() => _ListViewState();
}

class _ListViewState extends State<AppListView> {
  String email;

  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email');
    });
  }

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn Gsignin = new GoogleSignIn();
    TextEditingController _notefield = new TextEditingController();
    void showAddNote() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                width: MediaQuery.of(context).size.width / 1.3,
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _notefield,
                      maxLines: 4,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      )),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.white,
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          CollectionReference users = FirebaseFirestore.instance
                              .collection('Users')
                              .doc(FirebaseAuth.instance.currentUser.uid)
                              .collection('Notes');
                          users
                              .add({'Note': _notefield.text})
                              .then((value) => print('User Document Added'))
                              .catchError((err) => print('$err'));
                          print(_notefield.text);
                        },
                        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                        child: Text(
                          'AddNote',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }

    int i = 0;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewTask(), fullscreenDialog: true),
          );
          //showAddNote();
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Text('user:' + FirebaseAuth.instance.currentUser.displayName),
          RaisedButton(
              child: Icon(FontAwesomeIcons.signOutAlt),
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.remove('email');
                Gsignin.signOut();
                Navigator.pop(context);
              }),
          Expanded(
            child: Container(
              height: WidgetsBinding.instance.window.physicalSize.height,
              width: WidgetsBinding.instance.window.physicalSize.width,
              //height: MediaQuery.of(context).size.height,
              //width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('todolist')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView(
                      children: snapshot.data.docs.map((document) {
                        i++;
                        return Padding(
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 1.0),
                            child: SwipeActionCell(
                              key: ObjectKey(document.data()['Taskname']),

                              ///this key is necessary
                              trailingActions: <SwipeAction>[
                                SwipeAction(
                                    title: "delete",
                                    onTap: (CompletionHandler handler) {
                                      CollectionReference todos =
                                          FirebaseFirestore.instance
                                              .collection('todolist');
                                      todos
                                          .doc(document.id)
                                          .delete()
                                          .then(
                                              (value) => print("Task Deleted"))
                                          .catchError((err) => print("$err"));
                                    },
                                    color: Colors.red),
                              ],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(document.data()['Taskname'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 40)),
                              ),
                            ));
                      }).toList(),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
