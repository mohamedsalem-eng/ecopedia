import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/config_model.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:provider/provider.dart';

class AnnouncementScreen extends StatelessWidget {
  final Announcement announcement;
  AnnouncementScreen({Key key, this.announcement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String color = announcement.color.replaceAll('#', '0xff');
    String textColor = announcement.textColor.replaceAll('#', '0xff');
    return AlertDialog(
      content: Container(child: Text(announcement.announcement, style: TextStyle(color: Color(int.parse(textColor))))),
      backgroundColor: Color(int.parse(color)),
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      actions: <Widget>[
        TextButton(
          child: Text('ok', style: TextStyle(color: Color(int.parse(textColor)))),
          onPressed: () {
            Provider.of<SplashProvider>(context, listen: false).changeAnnouncementOnOff(false);
          },
        ),
      ],
    );
  }
}
