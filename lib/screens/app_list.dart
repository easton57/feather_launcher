import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

// TODO: Add to homescreen check box (limit of 8 apps total, 4 custom apps, tbd)

class AppListScreen extends StatefulWidget {
  @override
  _AppListScreenState createState() => _AppListScreenState();
}

class _AppListScreenState extends State<AppListScreen> {
  Map<String, bool> _checkedApps = {};

  void toggleApp(String packageName) {
    if (_checkedApps.length == 8) {

    }

    setState(() {
      if (_checkedApps.containsKey(packageName)) {
        _checkedApps[packageName] = false;
      } else {
        _checkedApps[packageName] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: FutureBuilder<List<AppInfo>>(
        future: InstalledApps.getInstalledApps(true, true),
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
    bool isChecked = _checkedApps.containsKey(app.packageName)
        ? _checkedApps[app.packageName]!
        : false;

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
              toggleApp(app.packageName);
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
