import 'package:flutter/material.dart';
import 'package:transit/core/theme/colors.dart';

class SafeScaffold extends StatelessWidget {
  const SafeScaffold({super.key, this.body, this.appBar});
 final Widget? body;
 final AppBar? appBar;
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: appBar,
      resizeToAvoidBottomInset: false, 
      backgroundColor: backgroundColor,body: body,));
  }
}