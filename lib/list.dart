import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class ApplicationsList extends StatelessWidget {
  //TODO on web return mock
  //doesn't have icon
  Future<List<Application>> apps = InstalledApplicationsProvider().getInstalledApplications();

  @override
  Widget build(BuildContext context) {
    String title = "Applications list";

    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<Application>> applicationList) {
        return ListView.builder(
          itemCount: applicationList.data.length,
          itemBuilder: (context, index) {
            final item = applicationList.data[index];
            ApplicationWithIcon itemWithIcon;
            if (item is ApplicationWithIcon) {
              itemWithIcon = item;
            }
            return ListTile(
              leading: new CircleAvatar(
                backgroundColor: Colors.blue,
                child: new Image(image: new AssetImage(itemWithIcon?.icon ?? "icons/ic_launcher.png")),
              ),
              title: Text(item.appName),
              subtitle: Text(item.apkFilePath)
            );
          },
        );
      },
      future: InstalledApplicationsProvider().getInstalledApplications(),
    );

  }
}


class InstalledApplicationsProvider {

  Future<List<Application>> getInstalledApplications() {
    //if(kIsWeb)
    return DeviceApps.getInstalledApplications();
  }

}