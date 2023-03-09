import 'package:flutter/cupertino.dart';
import 'package:flutter_tk/tk.dart';

class TkModel {
  static Future show ({
    required Widget child,
    Alignment alignment = Alignment.center,
  }) {
    return showGeneralDialog(context: TkHelper.ctx, pageBuilder: (ctx, animation1, animation2) {
      return TkBox(
        height: double.infinity,
        alignment: alignment,
        child: child,
      );
    });
  }
}