import 'dart:async';
import 'package:flutter/material.dart';

class HomeAppList extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<HomeAppList> {
  List<String> appList = ['App1', 'App2', 'App3', 'App4', 'App5', 'App6', 'App7', 'App8'];

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
    return Column(
      children: appList
          .map((appName) => Padding(padding: EdgeInsets.fromLTRB(0, 7, 0, 7), child: TextButton(
                onPressed: () => (),
                child: Text(appName, style: TextStyle(fontSize: 24, color: Colors.black),),
              )))
          .toList(),
    );
  }
}
