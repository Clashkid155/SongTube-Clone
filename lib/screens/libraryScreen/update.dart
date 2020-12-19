// Internal
import 'package:flutter/material.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:songtube/internal/models/updateDetails.dart';
import 'package:songtube/internal/updateChecker.dart';

// Packages
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';

double _value = 0;

void onClickInstallApk(String apk, package) async {
  if (await Permission.storage.isGranted) {
    InstallPlugin.installApk(apk, package).then((result) {
      print('install apk $result');
    }).catchError((error) {
      print('install apk error: $error');
    });
  } else {
    print('Permission request fail!');
  }
}

void check(
    {String path,
    void Function(int, int) showDownloadProgress,
    package}) async {
  final Dio client = Dio();

  final UpdateDetails arch = await getLatestRelease();
  AndroidDeviceInfo deviceinfo = await DeviceInfoPlugin().androidInfo;
  List<String> arm32 = ["armeabi", "armeabi-v7a"];
  List<String> arm64 = ["arm64-v8a"];
  List<String> x86 = ["x86"];

  String apkpath;
  print(deviceinfo.supportedAbis);
  print(join(path, arch.arm64.split("/").last));
  if (await Permission.storage.isGranted) {
    try {
      if (deviceinfo.supportedAbis.contains(arm64[0])) {
        print("IT contains $arm64");
        apkpath = join(path, arch.arm64.split("/").last);
        await client.download(
            arch.arm64, join(path, arch.arm64.split("/").last),
            onReceiveProgress: showDownloadProgress);

        //
      } else if (deviceinfo.supportedAbis.contains(arm32[0]) ||
          deviceinfo.supportedAbis.contains(arm32[1])) {
        apkpath = join(path, arch.arm.split("/").last);
        await client.download(arch.arm, join(path, arch.arm.split("/").last),
            onReceiveProgress: showDownloadProgress);
        print("IT contains $arm32");

        //
      } else if (deviceinfo.supportedAbis.contains(x86[0])) {
        apkpath = join(path, arch.x86.split("/").last);
        await client.download(arch.x86, join(path, arch.x86.split("/").last),
            onReceiveProgress: showDownloadProgress);
        print("IT contains $x86");

        //
      } else {
        apkpath = join(path, arch.general.split("/").last);
        await client.download(
            arch.general, join(path, arch.general.split("/").last),
            onReceiveProgress: showDownloadProgress);
        print("IT contains General");
      }
    } catch (e) {
      print(e);
    }
  }
  if (_value == 100.0) {
    onClickInstallApk(apkpath, package);
  }
}

class AppUpdate extends StatefulWidget {
  final String path;
  final String package;

  AppUpdate({this.path, this.package});
  @override
  _AppUpdateState createState() => _AppUpdateState();
}

class _AppUpdateState extends State<AppUpdate> with WidgetsBindingObserver {
  void showDownloadProgress(received, total) {
    if (total != -1) {
      print("$received and $total");
      setState(() {
        _value = double.tryParse((received / total * 100).toStringAsFixed(0));
      });

      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    check(
        path: widget.path,
        package: widget.package,
        showDownloadProgress: showDownloadProgress);
  }

  @override
  void dispose() {
    super.dispose();
    _value = 0;
    WidgetsBinding.instance.removeObserver(this);
  }

  // Not needed. Just testing stuffs
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      // Navigator.of(context).pop(true);
      print("Working");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_value / 100);
    print(widget.package);

    //Testing something
    /*if (_value == 100.0) {
      print("Delaying");
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.of(context).pop(true);
      });
    }*/
    return Visibility(
      visible: _value != 100.0,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          "Downloading",
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontFamily: "YTSans",
              fontSize: 20),
        ),
        content: Container(
          padding: EdgeInsets.all(8.0),
          height: 40,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${_value.round()}%",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'YTSans',
                        fontSize: 16),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  backgroundColor: Theme.of(context).cardColor,
                  value: _value / 100,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
