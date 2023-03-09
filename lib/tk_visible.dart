import 'package:flutter/material.dart';
import 'package:flutter_tk/tk.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TkVisible extends StatefulWidget {
  final Widget child;
  final double threshold;
  final Function? onShow;
  final Function? onHide;

  TkVisible(
      {Key? key,
      required this.child,
      this.threshold = 0.15,
      this.onShow,
      this.onHide})
      : super(key: key);

  @override
  TkVisibleState createState() => TkVisibleState();
}

class TkVisibleState extends State<TkVisible> {
  bool widgetOnShow = false;
  Key _key = Key(TkHelper.getRandomString(10));

  @override
  void initState() {
    super.initState();
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: _key,
        child: widget.child,
        onVisibilityChanged: (info) {
          if (info.visibleFraction > widget.threshold && !widgetOnShow) {
            setState(() {
              widgetOnShow = true;
              if (widget.onShow != null) widget.onShow!();
            });
          } else if (info.visibleFraction < widget.threshold &&
              widgetOnShow &&
              mounted) {
            setState(() {
              widgetOnShow = false;
              if (widget.onShow != null) widget.onHide!();
            });
          }
        });
  }
}
