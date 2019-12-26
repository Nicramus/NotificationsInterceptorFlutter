import 'dart:ui';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:launcher_assist/launcher_assist.dart';
import 'package:logging/logging.dart';

class ApplicationsList extends StatelessWidget {
  final Logger log = new Logger('ApplicationsList');

  //TODO on web return mock
  //doesn't have icon
  Future<List<Application>> apps =
      InstalledApplicationsProvider().getInstalledApplications();

  ApplicationsList() {
    LauncherAssist.getAllApps().then((apps) {
      final List<dynamic> list = apps;
      final dynamic dy = list.first;

      debugPrint("aaaa");
      Map<dynamic, dynamic> map = new Map<dynamic, dynamic>.from(dy);
      print(map);
      log.fine('Apps list: $map');
//      map.forEach((key, value) => {
//        log.fine('key: $key' + ' value: $value');
//        log.fine('a');
//      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = "Applications list";

    log.fine('Here are the context: $context');

    return FutureBuilder(
      builder: (BuildContext context,
          AsyncSnapshot<List<Application>> applicationList) {
        return ListView.builder(
          itemCount: applicationList.data.length,
          itemBuilder: (context, index) {
            final item = applicationList.data[index];
            ApplicationWithIcon itemWithIcon;
            print("aaa sraka");
            //LauncherAssist.getAllApps()
            if (item is ApplicationWithIcon) {
              itemWithIcon = item;
              print("printed item with icon");
              print(itemWithIcon.icon);
            } else {
              print("not printed");
            }

            //print(Image.memory(itemWithIcon.icon));
            return ListTile(
                leading: new CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: new Image(
                      image: new AssetImage(
                          itemWithIcon?.icon ?? "icons/ic_launcher.png")),
                ),
                title: Text(item.appName),
                subtitle: Text(item.apkFilePath));
          },
        );
      },
      future: InstalledApplicationsProvider().getInstalledApplications(),
    );
  }
}

//TODO
class InstalledApplicationsProvider {
  Future<List<Application>> getInstalledApplications() {
    //if(kIsWeb)
    return DeviceApps.getInstalledApplications();
  }
}

//class InstalledApplicationsProvider2 {
//  Future<dynamic> getInstalledApplications() {
//    //if(kIsWeb)
//    return LauncherAssist.getAllApps();
//  }
//}
