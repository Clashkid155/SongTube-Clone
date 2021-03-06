import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:songtube/internal/models/updateDetails.dart';

Future<UpdateDetails> getLatestRelease() async {
  try {
    var client = http.Client();
    var headers = {
      "Accept": "application/vnd.github.v3+json",
    };
    var response = await client.get(
        "https://api.github.com/repos/Clashkid155/SongTube-Clone/releases",
        headers: headers);
    var jsonResponse = jsonDecode(response.body);
    /* For SongTube Main
    double.parse(jsonResponse[0]["tag_name"]
              .split("+")
            .first
            .trim()
            .replaceRange(3, 5, "")
            ),*/
    UpdateDetails details = UpdateDetails(
        5.3,
        jsonResponse[0]["published_at"].split("T").first,
        jsonResponse[0]["body"],
        jsonResponse[0]["assets"][0]["browser_download_url"],
        jsonResponse[0]["assets"][1]["browser_download_url"],
        jsonResponse[0]["assets"][2]["browser_download_url"],
        jsonResponse[0]["assets"][3]["browser_download_url"]);
    client.close();
    return details;
  } catch (_) {
    return null;
  }
}

Future<void> queryUpdate() async {}
