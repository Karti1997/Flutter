import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var email = preferences.get('email');
  //print("***********main" + email);
  if (email == null) {
    print("No User");
    runApp(MyApp());
  } else if (email != null) {
    print('User');
    runApp(page1(
      email: email,
    ));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class page1 extends StatefulWidget {
  page1({Key key, this.email}) : super(key: key);
  final String email;
  @override
  _page1State createState() => _page1State();
}

class _page1State extends State<page1> {
  @override
  Widget build(BuildContext context) {
    return new Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.remove('email');
                runApp(MyApp());
              },
              child: Icon(FontAwesomeIcons.signOutAlt),
            ),
            Container(
                color: Colors.white,
                child: Center(
                  child: Text(
                    'User' + widget.email,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        backgroundColor: Colors.white),
                  ),
                ))
          ],
        ));
  }
}
