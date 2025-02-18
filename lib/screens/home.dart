import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feather_launcher/util/clock.dart';
import 'package:feather_launcher/util/home_app_list.dart';
import 'package:feather_launcher/screens/app_drawer.dart';

// TODO: Have a black and white color option and transparent background option
// TODO: Swap settings and app drawer icons in settings

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 90, 0, 0),
              child: Clock(),
            ),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding: EdgeInsets.fromLTRB(0, 250, 0, 0),
              child: Row(
                children: [HomeAppList()],
              ))
        ]),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 30),
            child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AppListScreen())),
                  tooltip: "Open app library",
                  icon: const Icon(Icons.apps)),
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 30),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AppListScreen())),
                  tooltip: "Open settings",
                  icon: const Icon(Icons.settings)),
            )),
      ]),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.dark),
      toolbarHeight: 0,
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
    );
  }
}
