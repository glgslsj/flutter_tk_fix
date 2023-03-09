import 'package:flutter/material.dart';
import 'package:flutter_tk/tk.dart';
import 'package:gap/gap.dart';

class TkFlex extends StatelessWidget {
  final List<Widget> children;
  final bool column;
  final bool wrap;
  final bool average;
  final bool between;
  final bool around;
  final bool middle;
  final bool bottom;
  final bool center;
  final bool right;
  final double spacing;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final void Function()? onPressed;

  const TkFlex({
    Key? key,
    this.children = const [],
    this.column = false,
    this.wrap = false,
    this.average = false,
    this.between = false,
    this.around = false,
    this.middle = false,
    this.bottom = false,
    this.center = false,
    this.right = false,
    this.spacing = 0.0,
    this.padding,
    this.width,
    this.height,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _children = average ? children.map((e) => Expanded(child: e)).toList() : children;
    var _direction = column ? Axis.vertical : Axis.horizontal;
    Widget rt;
    if (wrap) {
      var mainAlignment = WrapAlignment.start;
      var crossAlignment = WrapCrossAlignment.start;
      if (between) mainAlignment = WrapAlignment.spaceBetween;
      if (around) mainAlignment = WrapAlignment.spaceAround;
      if (column) {
        if (middle) mainAlignment = WrapAlignment.center;
        if (bottom) mainAlignment = WrapAlignment.end;
        if (center) crossAlignment = WrapCrossAlignment.center;
        if (right) crossAlignment = WrapCrossAlignment.end;
      } else {
        if (middle) crossAlignment = WrapCrossAlignment.center;
        if (bottom) crossAlignment = WrapCrossAlignment.end;
        if (center) mainAlignment = WrapAlignment.center;
        if (right) mainAlignment = WrapAlignment.end;
      }
      rt = Wrap(
        spacing: spacing,
        runSpacing: spacing,
        alignment: mainAlignment,
        crossAxisAlignment: crossAlignment,
        direction: _direction,
        children: _children,
      );
    } else {
      var mainAlignment = MainAxisAlignment.start;
      var crossAlignment = CrossAxisAlignment.start;
      if (between) mainAlignment = MainAxisAlignment.spaceBetween;
      if (around) mainAlignment = MainAxisAlignment.spaceAround;
      if (column) {
        if (middle) mainAlignment = MainAxisAlignment.center;
        if (bottom) mainAlignment = MainAxisAlignment.end;
        if (center) crossAlignment = CrossAxisAlignment.center;
        if (right) crossAlignment = CrossAxisAlignment.end;
      } else {
        if (middle) crossAlignment = CrossAxisAlignment.center;
        if (bottom) crossAlignment = CrossAxisAlignment.end;
        if (center) mainAlignment = MainAxisAlignment.center;
        if (right) mainAlignment = MainAxisAlignment.end;
      }
      if (spacing > 0 && _children.isNotEmpty) {
        List<Widget> list = [];
        _children.forEach((element) {
          list.add(element);
          list.add(Gap(spacing));
        });
        list.removeLast();
        _children = list;
      }
      rt = Flex(
        crossAxisAlignment: crossAlignment,
        mainAxisAlignment: mainAlignment,
        direction: _direction,
        children: _children,
      );
    }
    if (this.padding != null)
      rt = Padding(
        padding: padding!,
        child: rt,
      );
    if (width != null || height != null || onPressed != null) {
      rt = TkBox(
        onPressed: onPressed,
        width: width,
        height: height,
        child: rt,
      );
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        return FlexDataWidget(width: box.maxWidth, spacing: spacing, child: rt,);
      },
    );
  }
}

class FlexDataWidget extends InheritedWidget {
  FlexDataWidget({required this.width, required this.spacing, required Widget child})
      : super(child: child);

  final double width;
  final double spacing;

  static FlexDataWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FlexDataWidget>();
  }

  @override
  bool updateShouldNotify(FlexDataWidget old) {
    return old.width != width || old.spacing != spacing;
  }
}
