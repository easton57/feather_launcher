import 'dart:async';
import 'package:flutter/material.dart';

class HomeAppList extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<HomeAppList> {
  List<String> appList = [];

  void _updateList() {
    setState(() {
      appList = appList;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateList(); // initial update
    Timer.periodic(Duration(seconds: 1), (timer) => _updateList());
  }

  @override
  Widget build(BuildContext context) {
    if (appList.isEmpty) {
      return Column(children: [
        Wrap(children: [
          Text("Home app list is empty\nPlease check some apps in the app drawer",
              style: TextStyle(fontSize: 18, color: Colors.black), textAlign: TextAlign.center,)
        ])
      ]);
    } else {
      return Column(
        children: appList
            .map((appName) => Padding(
                padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
                child: TextButton(
                  onPressed: () => (),
                  child: Text(
                    appName,
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                )))
            .toList(),
      );
    }
  }
}
