import 'dart:async';
import 'package:flutter/material.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAppList extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<HomeAppList> {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  List<String>? homeApps = [];

  void getAppPreferences() async {
    homeApps = await asyncPrefs.getStringList('homeApps');
    homeApps ??= [];
  }

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
    getAppPreferences();

    if (homeApps!.isEmpty) {
      return Column(children: [
        Wrap(children: [
          Text(
            "Home app list is empty\nPlease check some apps in the app drawer",
            style: TextStyle(fontSize: 18, color: Colors.black),
            textAlign: TextAlign.center,
          )
        ])
      ]);
    } else {
      return Column(
        children: homeApps!
            .map((appName) => Padding(
                padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
                child: TextButton(
                  onPressed: () => InstalledApps.startApp(appName.split(':')[1]),
                  child: Text(
                    appName.split(':')[0],
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                )))
            .toList(),
      );
    }
  }
}
