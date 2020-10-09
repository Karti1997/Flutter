import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewTask extends StatefulWidget {
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  String Taskname, Taskdetails, Taskdate, Tasktime;
  TextEditingController _tasknamecont,
      _taskdetailcont,
      _taskdatecont,
      _tasktimecont;
  @override
  void initState() {
    super.initState();
    _tasknamecont = new TextEditingController();
    _taskdetailcont = new TextEditingController();
    _taskdatecont = new TextEditingController();
    _tasktimecont = new TextEditingController();
  }

  int _mytasktype = 0;
  String taskval;
  void _handleTaskType(int value) {
    setState(() {
      _mytasktype = value;
      switch (value) {
        case 1:
          taskval = "travel";
          break;
        case 2:
          taskval = "party";
          break;
        case 3:
          taskval = "gym";
          break;
        case 4:
          taskval = "shopping";
          break;
        case 5:
          taskval = "others";
          break;
      }
    });
  }

  createData() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('todolist').doc(taskval);
    Map<String, dynamic> tasks = {
      'Taskname': _tasknamecont.text,
      'Taskdetails': _taskdetailcont.text,
      'Taskdate': _taskdatecont.text,
      'Tasktime': _tasktimecont.text,
      'Tasktype': taskval
    };
    ds.set(tasks).whenComplete(() => print('Task Created'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(children: <Widget>[
          AppBar(
            title: Text('Add Tasks here'),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 80,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    /*onChanged: (String name) {
                      setTaskname(name);
                    },*/
                    controller: _tasknamecont,
                    decoration: InputDecoration(labelText: "Task: "),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    controller: _taskdetailcont,
                    decoration: InputDecoration(labelText: "Details: "),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    controller: _taskdatecont,
                    decoration: InputDecoration(labelText: "Date: "),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    controller: _tasktimecont,
                    decoration: InputDecoration(labelText: "Time: "),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Text(
                    'Select task type',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Radio(
                          value: 1,
                          groupValue: _mytasktype,
                          onChanged: _handleTaskType,
                          activeColor: Colors.blue,
                        ),
                        Text('Travel', style: TextStyle(fontSize: 16.0)),
                        Radio(
                          value: 2,
                          groupValue: _mytasktype,
                          onChanged: _handleTaskType,
                          activeColor: Colors.blue,
                        ),
                        Text('Party', style: TextStyle(fontSize: 16.0)),
                        Radio(
                          value: 3,
                          groupValue: _mytasktype,
                          onChanged: _handleTaskType,
                          activeColor: Colors.blue,
                        ),
                        Text('Gym', style: TextStyle(fontSize: 16.0)),
                        Radio(
                          value: 4,
                          groupValue: _mytasktype,
                          onChanged: _handleTaskType,
                          activeColor: Colors.blue,
                        ),
                        Text('Shopping', style: TextStyle(fontSize: 16.0))
                      ],
                    )
                  ],
                ),
                RaisedButton(
                  color: Colors.teal,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                RaisedButton(
                  color: Colors.teal,
                  onPressed: () {
                    createData();
                    print('Data Created');
                  },
                  child: Text(
                    'Donate',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          )
        ]));
  }
}
