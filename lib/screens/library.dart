// Flutter
import 'package:flutter/material.dart';
import 'package:songtube/internal/languages.dart';
import 'package:songtube/internal/models/updateDetails.dart';

// Internal
import 'package:songtube/provider/configurationProvider.dart';
import 'package:songtube/screens/libraryScreen/settings.dart';
import 'package:songtube/screens/libraryScreen/components/quickAcessTile.dart';
import 'package:songtube/internal/updateChecker.dart';

// Packages
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:songtube/screens/libraryScreen/components/songtubeBanner.dart';
import 'package:songtube/ui/dialogs/appUpdateDialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConfigurationProvider config = Provider.of<ConfigurationProvider>(context);
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          // SongTube Banner
          SongTubeBanner(
            appName: config.appName,
            appVersion: config.appVersion,
          ),
          // Settings
          QuickAccessTile(
              tileIcon: Icon(EvaIcons.settingsOutline, color: Colors.redAccent),
              title: Languages.of(context).labelSettings,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsTab()));
              }),
          // Telegram Channel
          QuickAccessTile(
            tileIcon: Icon(MdiIcons.telegram, color: Colors.blue),
            title: "Telegram",
            onTap: () {
              launch("https://t.me/songtubechannel");
            },
          ),
          // Github
          QuickAccessTile(
            tileIcon: Icon(EvaIcons.githubOutline, color: Colors.blueGrey),
            title: "GitHub",
            onTap: () {
              launch("https://github.com/SongTube");
            },
          ),
          // Licenses
          QuickAccessTile(
            tileIcon: Icon(EvaIcons.heartOutline, color: Colors.redAccent),
            title: Languages.of(context).labelDonate,
            onTap: () {
              launch("https://paypal.me/artixo");
            },
          ),
          // Licenses
          QuickAccessTile(
            tileIcon: Icon(MdiIcons.license, color: Colors.green),
            title: Languages.of(context).labelLicenses,
            onTap: () {
              showLicensePage(
                  applicationName: config.appName,
                  applicationIcon: Image.asset('assets/images/ic_launcher.png',
                      height: 50, width: 50),
                  applicationVersion: config.appVersion,
                  context: context);
            },
          ),
          //Update check
          QuickAccessTile(
            tileIcon: Icon(
              MdiIcons.update,
              color: Colors.red,
            ),
            title: "Check for Update",
            onTap: () async {
              final UpdateDetails arch = await getLatestRelease();
              showDialog(
                  context: context,
                  builder: (context) => AppUpdateDialog(
                      arch, config.videoDownloadPath, config.packageName));
            },
          ),
        ],
      ),
    );
  }
}
