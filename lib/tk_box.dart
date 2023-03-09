import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tk/tk.dart';
import 'package:get/get.dart' as g;

class TkBox extends StatelessWidget {
  const TkBox({
    Key? key,
    this.color,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.padding = const [],
    this.marginTop,
    this.marginRight,
    this.marginBottom,
    this.marginLeft,
    this.margin = const [],
    this.width,
    this.height,
    this.alignment,
    this.child,
    this.onPressed,
    this.border,
    this.borderRadius,
    this.minWidth = 0,
    this.minHeight = 0,
    this.decoration,
    this.col,
    this.colOnMobile,
    this.colOnTablet,
    this.colOnDesktop,
    this.ratio,
    this.elevation,
    this.randomColor = false,
    this.show = true,
    this.ripple = false,
  }) : super(key: key);

  final Color? color;
  final bool show;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final List<double> padding;
  final double? marginTop;
  final double? marginRight;
  final double? marginBottom;
  final double? marginLeft;
  final List<double> margin;
  final double? width;
  final double? minWidth;
  final double? height;
  final double? minHeight;
  final double? ratio;
  final double? elevation;
  final double? col;
  final double? colOnMobile;
  final double? colOnTablet;
  final double? colOnDesktop;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final AlignmentGeometry? alignment;
  final Decoration? decoration;
  final Widget? child;
  final bool? randomColor;
  final void Function()? onPressed;
  final bool ripple;

  double getResponsiveWidth(FlexDataWidget flexData, double mediaWidth) {
    double? _col;
    if (mediaWidth > 1000) _col = colOnDesktop ?? col;
    if (mediaWidth <= 800) _col = colOnTablet ?? col;
    if (mediaWidth <= 480) _col = colOnMobile ?? col;
    return (((flexData.width + flexData.spacing) * _col! - flexData.spacing) * 100).floorToDouble() / 100 ;
  }

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox();
    Widget current = child ?? Container();

    var flexData = FlexDataWidget.of(context);

    var w = width;
    var h = height;
    if (w == null &&
        [col, colOnMobile, colOnTablet, colOnDesktop]
                .filter((e) => e != null)
                .length >
            0 &&
        flexData != null) {
      w = getResponsiveWidth(flexData, context.mediaQuerySize.width);
    }
    if (ratio != null && w == null && h != null) w = h / ratio!;
    if (ratio != null && w != null && h == null) h = w * ratio!;

    if (alignment != null)
      current = Align(alignment: alignment!, child: current);

    if (top != null ||
        bottom != null ||
        left != null ||
        right != null ||
        padding.isNotEmpty)
      current = Padding(
          padding: padding.length == 1
              ? EdgeInsets.all(padding.elementAtOrNull(0)!)
              : EdgeInsets.only(
                  top: top ?? padding.elementAtOrNull(0) ?? 0.0,
                  right: right ?? padding.elementAtOrNull(1) ?? 0.0,
                  bottom: bottom ??
                      padding.elementAtOrNull(2) ??
                      padding.elementAtOrNull(0) ??
                      0.0,
                  left: left ??
                      padding.elementAtOrNull(3) ??
                      padding.elementAtOrNull(1) ??
                      0.0),
          child: current);

    if (minHeight! > 0 || minWidth! > 0)
      current = ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth!, minHeight: minHeight!),
        child: current,
      );

    if (w != null || h != null)
      current = ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: w, height: h),
        child: current,
      );

    var _color = randomColor! ? TkHelper.randomColor : this.color;
    Decoration? boxDecoration;

    if (_color != null || border != null || borderRadius != null)
      boxDecoration = BoxDecoration(
        color: _color,
        border: border,
        borderRadius: borderRadius,
      );
    boxDecoration = boxDecoration ?? decoration;

    if (onPressed != null || elevation != null) {
      current = InkWell(
        onTap: onPressed,
        child: current,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: ripple ? null : Colors.transparent,
      );
      if (boxDecoration != null) {
        current = Ink(decoration: boxDecoration, child: current,);
      }
      current = Material(elevation: elevation ?? 0.0, child: current, color: Colors.transparent,);
    } else if (boxDecoration != null) {
      current = DecoratedBox(
        decoration: boxDecoration,
        child: current,
      );
    }

    if (marginTop != null ||
        marginBottom != null ||
        marginLeft != null ||
        marginRight != null ||
        margin.isNotEmpty)
      current = Padding(
          padding: margin.length == 1
              ? EdgeInsets.all(margin.elementAtOrNull(0)!)
              : EdgeInsets.only(
                  top: marginTop ?? margin.elementAtOrNull(0) ?? 0.0,
                  right: marginRight ?? margin.elementAtOrNull(1) ?? 0.0,
                  bottom: marginBottom ??
                      margin.elementAtOrNull(2) ??
                      margin.elementAtOrNull(0) ??
                      0.0,
                  left: marginLeft ??
                      margin.elementAtOrNull(3) ??
                      margin.elementAtOrNull(1) ??
                      0.0),
          child: current);

    return current;
  }
}
