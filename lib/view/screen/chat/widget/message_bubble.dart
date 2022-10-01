import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/chat_model.dart';
import 'package:mechatronia_app/helper/date_converter.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/utill/images.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  final ChatModel chat;
  final String sellerImage;
  final Function onProfileTap;
  MessageBubble({@required this.chat, @required this.sellerImage, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    bool isMe = chat.sentByCustomer == 1;
    String dateTime = DateConverter.localDateToIsoStringAMPM(DateTime.parse(chat.createdAt));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isMe
            ? SizedBox.shrink()
            : InkWell(
                onTap: onProfileTap,
                child: ClipOval(
                    child: Container(
                  color: Theme.of(context).highlightColor,
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.placeholder,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    image:
                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls.sellerImageUrl}/$sellerImage',
                    imageErrorBuilder: (c, o, s) =>
                        Image.asset(Images.placeholder, height: 40, width: 40, fit: BoxFit.cover),
                  ),
                ))),
        Flexible(
          child: Container(
            margin: isMe ? EdgeInsets.fromLTRB(70, 5, 10, 5) : EdgeInsets.fromLTRB(10, 5, 70, 5),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: isMe ? Radius.circular(10) : Radius.circular(0),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: isMe ? ColorResources.getImageBg(context) : Theme.of(context).highlightColor,
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              !isMe
                  ? Text(dateTime,
                      style: titilliumRegular.copyWith(
                        fontSize: 8,
                        color: ColorResources.getHint(context),
                      ))
                  : SizedBox.shrink(),
              chat.message.isNotEmpty
                  ? Text(chat.message,
                      textAlign: TextAlign.justify,
                      style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL))
                  : SizedBox.shrink(),
              //chat.image != null ? Image.file(chat.image) : SizedBox.shrink(),
            ]),
          ),
        ),
      ],
    );
  }
}
