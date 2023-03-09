// @dart=2.9
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as g;

class TkHelper {

  static BuildContext get ctx {
    return g.Get.context;
  }

  static sleep (int milliseconds) {
    return Future.delayed(Duration(milliseconds: milliseconds));
  }

  static String getRandomString(int length) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnoPpQqRrSsTtUuVvWwXxYyZz123456789';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  static Color get randomColor {
    var rand = Random();
    int r = (30 + rand.nextInt(196));
    int g = (30 + rand.nextInt(196));
    int b = (30 + rand.nextInt(196));
    return Color.fromARGB(255, r, g, b);
  }
  static bool get isWeb {
    return g.GetPlatform.isWeb;
  }
  static bool get isMobile {
    return MediaQuery.of(TkHelper.ctx).size.shortestSide < 600;
  }
  static bool get isTablet {
    return g.GetPlatform.isMobile && MediaQuery.of(TkHelper.ctx).size.shortestSide > 600;
  }
  static bool get isDesktop {
    return g.GetPlatform.isDesktop;
  }
  static bool get isAndroid {
    return g.GetPlatform.isAndroid;
  }
  static bool get isIOS {
    return g.GetPlatform.isIOS;
  }
}