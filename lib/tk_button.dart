import 'package:fbutton/fbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as g;

enum ButtonType {
  flat,
  primary,
  accent,
  danger,
}

class TkButton extends StatelessWidget {
  final String text;
  final ButtonType type;

  const TkButton(this.text, {Key? key, this.type = ButtonType.flat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FButton(
      text: text,
      color: g.Get.theme.accentColor,
    );
  }
}
