import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerAppList extends StatefulWidget {
  const DrawerAppList({super.key});

  @override
  _AppListState createState() => _AppListState();
}

class _AppListState extends State<DrawerAppList> {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  List<String>? homeApps = [];
  List<AppInfo> installedApps = [];

  @override
  void initState() {
    super.initState();
    getAppPreferences();
    loadInstalledApps();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: installedApps
          .map((app) => Padding(
              padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
              child: TextButton(
                onPressed: () => InstalledApps.startApp(app.packageName),
                child: Text(
                  app.name,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              )))
          .toList(),
    );
  }

  void getAppPreferences() async {
    homeApps = await asyncPrefs.getStringList('homeApps');
    homeApps ??= [];
  }

  void loadInstalledApps() async {
    installedApps = await InstalledApps.getInstalledApps(false, true);
  }

  void toggleApp(AppInfo app) {
    if (homeApps?.length == 8) {
      // Pop up warning thing
      return;
    }

    String appName = '${app.name}:${app.packageName}';

    setState(() {
      if (homeApps!.contains(app.packageName)) {
        homeApps!.remove(appName);
      } else {
        homeApps!.add(appName);
      }
    });

    // Write to settings
    asyncPrefs.setStringList('homeApps', homeApps!);
  }
}
