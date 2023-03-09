import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_color/smart_color.dart';

Color TkColor (String color) {
  return SmartColor.parse(color);
}