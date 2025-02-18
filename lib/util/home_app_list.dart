import 'dart:async';
import 'package:flutter/material.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAppList extends StatefulWidget {
  const HomeAppList({super.key});

  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeAppList> {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  List<String>? homeApps = [];

  @override
  void initState() {
    super.initState();
    getAppPreferences();
    Timer.periodic(Duration(seconds: 1), (timer) => _updateList());
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () =>
                      InstalledApps.startApp(appName.split(':')[1]),
                  child: Text(
                    appName.split(':')[0],
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                )))
            .toList(),
      );
    }
  }

  void getAppPreferences() async {
    homeApps = await asyncPrefs.getStringList('homeApps');
    homeApps ??= [];
  }

  void _updateList() {
    setState(() {
      getAppPreferences();
    });
  }
}
