import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:songtube/internal/languages.dart';
import 'package:songtube/internal/models/infoSets/mediaInfoSet.dart';
import 'package:songtube/screens/homeScreen/components/roundTile.dart';

class VideoEngagement extends StatelessWidget {
  final MediaInfoSet infoset;
  final Function onSaveToFavorite;
  VideoEngagement({
    @required this.infoset,
    @required this.onSaveToFavorite
  });
  @override
  Widget build(BuildContext context) {
    int likeCount = infoset.videoDetails.engagement.likeCount;
    int dislikeCount = infoset.videoDetails.engagement.dislikeCount;
    int viewCount = infoset.videoDetails.engagement.viewCount;
    String videoUrl =  infoset.videoDetails.url;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // Likes Counter
        RoundTile(
          icon: Icon(MdiIcons.thumbUp, color: Theme.of(context).iconTheme.color),
          text: Text(
            NumberFormat.compact().format(likeCount),
            style: TextStyle(
              fontFamily: "Varela",
              fontSize: 10
            ),
            ),
        ),
        // Dislikes Counter
        RoundTile(
          icon: Icon(MdiIcons.thumbDown, color: Theme.of(context).iconTheme.color),
          text: Text(
            NumberFormat.compact().format(dislikeCount),
            style: TextStyle(
              fontFamily: "Varela",
              fontSize: 10
            ),
            ),
        ),
        //
        RoundTile(
          icon: Icon(EvaIcons.eye, color: Theme.of(context).iconTheme.color),
          text: Text(
            NumberFormat.compact().format(viewCount),
            style: TextStyle(
              fontFamily: "Varela",
              fontSize: 10
            ),
          ),
        ),
        // Channel Button
        RoundTile(
          icon: Icon(MdiIcons.heart, color: Theme.of(context).iconTheme.color),
          text: Text(
            "Favorite",
            style: TextStyle(
              fontFamily: "Varela",
              fontSize: 10
            ),
          ),
          onPressed: onSaveToFavorite
        ),
        // Share button
        RoundTile(
          icon: Icon(EvaIcons.share, color: Theme.of(context).iconTheme.color),
          text: Text(
            Languages.of(context).labelShare,
            style: TextStyle(
              fontFamily: "Varela",
              fontSize: 10
            ),
          ),
          onPressed: () {
            Share.share(videoUrl);
          },
        ),
      ],
    );
  }
}