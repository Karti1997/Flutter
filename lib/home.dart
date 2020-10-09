import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/tasks.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController emailInputController = new TextEditingController();
  TextEditingController pwdInputController = new TextEditingController();
  void showReset() {
    TextEditingController emailresetController = new TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: emailresetController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        hintText: 'example@gmail.com',
                        hintStyle: TextStyle(color: Colors.black),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.white,
                    child: MaterialButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await Firebase.initializeApp();
                        FirebaseAuth.instance.sendPasswordResetEmail(
                            email: emailresetController.text);
                      },
                      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                      child: Text(
                        'Reset',
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

  void _signIn() async {
    String username;
    final GoogleSignIn _googleSignIn = new GoogleSignIn();
    final GoogleSignInAccount googleuser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleauth =
        await googleuser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleauth.accessToken, idToken: googleauth.idToken);

    await Firebase.initializeApp();
    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (user != null) {
      username = user.additionalUserInfo.profile.values.elementAt(0);
    } else {
      username = null;
    }
    print(username);
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new AppListView()));
  }

  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      controller: emailInputController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.blueGrey,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        hintText: 'example@gmail.com',
        hintStyle: TextStyle(
          color: Colors.blueGrey,
        ),
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.white),
      ),
    );
    final password = Column(
      children: [
        TextFormField(
          controller: pwdInputController,
          obscureText: true,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.blueGrey,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            hintStyle: TextStyle(
              color: Colors.blueGrey,
            ),
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(2.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MaterialButton(
              onPressed: () {
                showReset();
              },
              child: Text(
                'ForgotPassword',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        )
      ],
    );
    final login = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white,
      child: MaterialButton(
        onPressed: () async {
          await Firebase.initializeApp();
          UserCredential user = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: emailInputController.text,
                  password: pwdInputController.text);
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString('email', emailInputController.text);
          var em = preferences.getString('email');
          print("Shared" + em);
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new AppListView()));
        },
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text(
          'Login',
          style: TextStyle(
              fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
    final register = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white,
      child: MaterialButton(
        onPressed: () async {
          await Firebase.initializeApp();
          UserCredential user = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: emailInputController.text,
                  password: pwdInputController.text);
          CollectionReference users =
              FirebaseFirestore.instance.collection('users');
          users
              .doc(FirebaseAuth.instance.currentUser.uid)
              .set({'Email': emailInputController.text})
              .then((value) => print("User Document Added"))
              .catchError((err) => print("Failed to add user: $err"));
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new AppListView()));
        },
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text(
          'Register',
          style: TextStyle(
              fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              email,
              password,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[login, register],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          color: Color(0xffffffff),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.google),
                              SizedBox(
                                width: 10.0,
                              ),
                            ],
                          ),
                          onPressed: _signIn),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.chat_bubble),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
