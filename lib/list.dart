import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/application_preferences.dart';
import 'package:launcher_assist/launcher_assist.dart';
import 'package:logging/logging.dart';

import 'package:flutter/services.dart' show rootBundle;

class ApplicationsList extends StatelessWidget {
  final Logger log = new Logger('ApplicationsList');

  @override
  Widget build(BuildContext context) {
    String title = "Applications list";
    log.fine('Here are the context: $context');
    return FutureBuilder(
      builder: (BuildContext context,
          AsyncSnapshot<List<InstalledApplication>> applicationList) {
        return ListView.builder(
          itemCount: applicationList.data.length,
          itemBuilder: (context, index) {
            InstalledApplication item = applicationList.data[index];
            return ListTile(
                onTap: () => onTapped(context, item),
                leading: new CircleAvatar(
                  //backgroundColor: Colors.blue,
                  child: new Image.memory(item.icon),
                ),
                title: Text(item.appName),
                subtitle: Text(item.packageName));

          },
        );
      },
      future: LauncherAssistProvider().getInstalledApplications(),
    );
  }
}

void onTapped(BuildContext context, InstalledApplication installedApplication) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ApplicationPreferences()),
  );
}

class LauncherAssistProvider {

  LauncherAssistWrapper las = kIsWeb ? LauncherAssistWrapperMock() : LauncherAssistWrapperAndroidImpl();

  LauncherAssistProvider() {
    print(las);
  }

  Future<List<InstalledApplication>> getInstalledApplications() async {
    return las.getInstalledApplications();
  }
}

abstract class LauncherAssistWrapper {
  Future<List<InstalledApplication>> getInstalledApplications();
}

/**
 * Used to simulate installed apps on web
 */
class LauncherAssistWrapperMock extends LauncherAssistWrapper {
  Future<List<InstalledApplication>> getInstalledApplications() async {
    String appName = "Chrome";
    String packageName = "com.google.chrome";
    Uint8List iconByteArray =  Uint8List(3);
    var iconByteData = await rootBundle.load("/assets/icons/chrome-512.png");
    Uint8List iconUint8List = iconByteData.buffer.asUint8List(iconByteData.offsetInBytes, iconByteData.lengthInBytes);
    InstalledApplication ia = InstalledApplication(appName, packageName, iconUint8List);
    List<InstalledApplication> list = List<InstalledApplication>();
    list.add(ia);

    return list;
  }
}

/**
 * Used to wrap the map from launcher assist, and return user friendly object
 */
class LauncherAssistWrapperAndroidImpl extends LauncherAssistWrapper {
  Future<List<InstalledApplication>> getInstalledApplications() async {
    List<InstalledApplication> list = List<InstalledApplication>();
    List<dynamic> launcherAssistResult = await LauncherAssist.getAllApps();

    for(var application in launcherAssistResult) {
      Map<dynamic, dynamic> map = new Map<dynamic, dynamic>.from(application);
      InstalledApplication ia = InstalledApplication(map['label'], map['package'], map['icon']);
      list.add(ia);
    }
    return list;
  }
}

/**
 * contains basic data about installed application in the system
 */
class InstalledApplication {
  String appName;
  String packageName;
  Uint8List icon; //byte[]

  InstalledApplication(this.appName, this.packageName, this.icon);

  @override
  String toString() {
    return 'App name: $appName, Package name: $packageName';
  }
}

