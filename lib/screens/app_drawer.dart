import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppListScreen extends StatefulWidget {
  @override
  _AppListScreenState createState() => _AppListScreenState();
}

class _AppListScreenState extends State<AppListScreen> {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  List<String>? homeApps = [];
  List<AppInfo> installedApps = [];

  @override
  void initState() {
    super.initState();
    getAppPreferences();
  }

  void getAppPreferences() async {
    homeApps = await asyncPrefs.getStringList('homeApps');
    homeApps ??= [];
  }

  void loadInstalledApps() async {
    installedApps = await InstalledApps.getInstalledApps(false, true);
  }

  void toggleApp(AppInfo app) async {
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

  @override
  Widget build(BuildContext context) {
    getAppPreferences();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: FutureBuilder<List<AppInfo>>(
        future: InstalledApps.getInstalledApps(false, true),
        builder: (
          BuildContext buildContext,
          AsyncSnapshot<List<AppInfo>> snapshot,
        ) {
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData
                  ? _buildListView(snapshot.data ?? [])
                  : _buildError()
              : _buildProgressIndicator();
        },
      ),
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

  Widget _buildListView(List<AppInfo> apps) {
    return ListView.builder(
      itemCount: apps.length,
      itemBuilder: (context, index) => _buildListItem(context, apps[index]),
    );
  }

  Widget _buildListItem(BuildContext context, AppInfo app) {
    bool isChecked = homeApps!.contains('${app.name}:${app.packageName}');

    return Card(
      shadowColor: Colors.transparent,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.memory(app.icon!),
        ),
        trailing: Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              toggleApp(app);
            }),
        title: Text(app.name),
        onTap: () => InstalledApps.startApp(app.packageName),
        onLongPress: () => _uninstallApp(app),
      ),
    );
  }

  void _uninstallApp(AppInfo app) async {
    bool? uninstalled = await InstalledApps.uninstallApp(app.packageName);

    if (uninstalled != null && uninstalled) {
      await Future.delayed(Duration(milliseconds: 2000));

      setState(() {});
    }
  }

  Widget _buildProgressIndicator() {
    return Center(child: Text("Getting installed apps...."));
  }

  Widget _buildError() {
    return Center(
      child: Text("Error occurred while getting installed apps...."),
    );
  }
}
