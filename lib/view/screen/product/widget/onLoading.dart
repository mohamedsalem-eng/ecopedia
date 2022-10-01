import 'package:flutter/material.dart';

void onLoading(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          height: 100,
          color:Colors.transparent,
          child: Image.asset("assets/images/loading.gif")
        ),
      );
    },
  );
}
/**
 * 
 */