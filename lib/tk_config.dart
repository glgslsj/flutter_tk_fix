import 'dart:ui';

class TkConfig {
  String? uploadUrl;
  Color? appBarColor;

  static final TkConfig _singleton = TkConfig._internal();

  factory TkConfig({
    String? uploadUrl,
    Color? appBarColor,
  }) {
    if (uploadUrl != null) _singleton.uploadUrl = uploadUrl;
    if (appBarColor != null) _singleton.appBarColor = appBarColor;
    return _singleton;
  }
  TkConfig._internal();
}
