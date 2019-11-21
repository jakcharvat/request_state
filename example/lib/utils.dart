import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  Utils(this.context);

  final BuildContext context;

  void openSource(String url) async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      _mobileSourceOpen(url);
      return;
    }

    _showUrlSnackbar(url);
  }

  void _mobileSourceOpen(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Cannot Launch url $url");
    }
  }

  void _showUrlSnackbar(String url) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(url),
    ));
  }
}
