// @dart=2.9
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tk/tk.dart';
import 'package:flutter_tk/tk_config.dart';
import 'package:flutter_tk_example/form_page.dart';
import 'package:flutter_tk_example/home.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';
import 'dart:ui';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化tkConfig
  TkConfig(
    uploadUrl: 'https://cloud.cun.mokekeji.com/files'
  );
  var isMobile = window.physicalSize.shortestSide / window.devicePixelRatio < 500;
  runApp(  DevicePreview(
    enabled: !kReleaseMode && !isMobile,
    builder: (context) => MyApp(), // Wrap your app
  ),);
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'flutter-tk',
      home: HomeScreen(),
    );
  }
}
