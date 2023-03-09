// @dart=2.9
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CustomCupertinoPicker.dart';
import 'package:flutter_tk/tk.dart';
import 'package:flutter_tk/tk_flex.dart';
import 'package:flutter_tk/tk_text.dart';
import 'package:get/get.dart' as g;
import 'package:collection/collection.dart';

Future showTkPicker({
  String title,
  @required List data,
  Function(dynamic value) onSelectedItemChanged,
  dynamic initValue,
}) async {
  var value = initValue;
  Completer c = Completer();
  await showModalBottomSheet(
      isScrollControlled: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      backgroundColor: Colors.white,
      context: g.Get.context,
      builder: (context) => Container(
          height: 266,
          child: Column(
            children: [
              TkFlex(
                padding: EdgeInsets.symmetric(horizontal: 28),
                between: true,
                height: 45,
                middle: true,
                children: [
                  TkBox(
                      onPressed: () {
                        g.Get.back();
                      },
                      child: T(
                        '取消',
                        color: TkColor('#9A9DA8'),
                      )),
                  if (title != null) Text(title),
                  TkBox(
                    child: T('确定', color: g.Get.theme.primaryColor),
                    onPressed: () {
                      c.complete(value);
                      g.Get.back();
                    },
                  ),
                ],
              ),
              Divider(
                color: TkColor('#E8E8E8'),
                height: 1,
                thickness: 1,
              ),
              Expanded(
                  child: TkPicker(
                data: data,
                onSelectedItemChanged: (val) {
                  value = val;
                  if (onSelectedItemChanged != null) onSelectedItemChanged(val);
                },
                initValue: initValue,
              ))
            ],
          )));
  if (!c.isCompleted) c.complete(null);
  return c.future;
}

class TkPicker extends StatefulWidget {
  final List data;
  final Function(dynamic value) onSelectedItemChanged;
  final dynamic initValue;

  const TkPicker(
      {Key key, this.data, this.onSelectedItemChanged, this.initValue})
      : super(key: key);

  @override
  _TkPickerState createState() => _TkPickerState();
}

class _TkPickerState extends State<TkPicker> {
  List value;

  @override
  void initState() {
    value = _initValue;
    super.initState();
  }

  int get pickerNum => _data.length;

  List get _initValue {
    if (widget.initValue == null) return _data.map((e) => e.first.value).toList();
    if (_data.length == 1) return [widget.initValue];
    return List.from(widget.initValue);
  }

  List<List<TkPickerItem>> get _data {
    if (widget.data.first is List<TkPickerItem>)
      return List<List<TkPickerItem>>.from(widget.data);
    else
      return [List<TkPickerItem>.from(widget.data)];
  }

  dynamic get emitValue {
    if (value.isEmpty) return null;
    if (pickerNum == 1) return value.elementAtOrNull(0);
    return value;
  }

  void updateValue(int index, dynamic val) {
    value[index] = val;
    if (widget.onSelectedItemChanged != null)
      widget.onSelectedItemChanged(emitValue);
  }

  @override
  Widget build(BuildContext context) {
    return TkFlex(
        height: 260,
        children: _data
            .mapIndexed((i, e) => Expanded(
                    child: SinglePickerWidget(
                      data: e,
                      onSelectedItemChanged: (val) {
                        updateValue(i, val);
                      },
                  initValue: _initValue.elementAtOrNull(i),
                )))
            .toList());
  }
}

class SinglePickerWidget extends StatefulWidget {
  final List<TkPickerItem> data;
  final Function(dynamic value) onSelectedItemChanged;
  final dynamic initValue;

  const SinglePickerWidget(
      {Key key, this.data, this.onSelectedItemChanged, this.initValue})
      : super(key: key);

  @override
  _SinglePickerWidgetState createState() => _SinglePickerWidgetState();
}

class _SinglePickerWidgetState extends State<SinglePickerWidget> {
  var controller = FixedExtentScrollController();

  @override
  Widget build(BuildContext context) {
    if (widget.initValue != null)
      controller.jumpToItem(widget.data
          .indexWhere((element) => element.value == widget.initValue));
    return CCupertinoPicker(
      scrollController: controller,
      magnification: 1.2,
      backgroundColor: Colors.transparent,
      children: widget.data.map((e) => TkBox(alignment: Alignment.center, child: T(e._text))).toList(),
      itemExtent: 55,
      onSelectedItemChanged: (int index) {
        var item = widget.data[index];
        if (widget.onSelectedItemChanged != null)
          widget.onSelectedItemChanged(item.value);
      },
    );
  }
}

class TkPickerItem {
  final dynamic value;
  final String text;
  final List<TkPickerItem> children;

  TkPickerItem(
    this.value, {
    this.text,
    this.children,
  });

  String get _text {
    return this.text ?? this.value.toString();
  }
}
