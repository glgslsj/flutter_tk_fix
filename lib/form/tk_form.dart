// @dart=2.9
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart' as g;
import 'tk_field.dart';

class TkForm extends StatefulWidget {
  TkForm({Key key, this.child, @required this.model, this.onChanged, this.controller, this.onValidateChange})
      : super(key: key);

  final Widget child;
  final g.RxMap model;
  final Function onChanged;
  final TkFormController controller;
  final Function(Map<String, ValidatStatus>) onValidateChange;

  static TkFormState of(BuildContext context) =>
      context.findAncestorStateOfType<TkFormState>();

  @override
  TkFormState createState() => TkFormState();
}

class TkFormState extends State<TkForm> {
  Map modelFields = {};
  Map cacheModel = {};
  Map<String, ValidatStatus> fieldsValidateStatus = {};

  TkFormController _controller = TkFormController();

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) _controller = widget.controller;
    _controller.setFormState(this);
    cacheModel.addAll(widget.model);
    g.debounce(widget.model, (map) {
      modelFields.forEach((key, field) {
        if (cacheModel[key] != map[key]) {
          cacheModel[key] = map[key];
          field.setValue(map[key]);
        }
      });
    }, time: Duration(microseconds: 5));
  }

  void registerField(String name, dynamic field) {
    modelFields[name] = field;
    fieldsValidateStatus[name] = ValidatStatus.NONE;
  }

  void unregisterField(String name) {
    modelFields.remove(name);
    fieldsValidateStatus.remove(name);
  }
  void setFieldValidateStatus (String field, status) {
    fieldsValidateStatus[field] = status;
    if (widget.onValidateChange != null) widget.onValidateChange(fieldsValidateStatus);
  }

  Future<Map> validate({List<String> fields}) async {
    Map rt = {};
    Map _modelFields = Map.from(modelFields);
    if (fields != null) {
      _modelFields.removeWhere((key, value) => !fields.contains(key));
    }
    Map<String, Future> futures = _modelFields.map((k, m) {
      Completer c = Completer();
      m.validate().then((v) {
        rt[k] = v != null ? ValidatStatus.FAILED : ValidatStatus.SUCCESS;
        c.complete();
      });
      return MapEntry(k, c.future);
    });
    await Future.wait(futures.values);
    return rt;
  }

  void setFieldValue(String name, dynamic value) {
    if (widget.model[name] == value) return;
    widget.model.assign(name, value);
    if (widget.onChanged != null) widget.onChanged();
  }

  dynamic getValue(String name) {
    return widget.model[name];
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: widget.child,
      onChanged: widget.onChanged,
    );
  }
}

class TkFormController {
  TkFormState formState;
  Map validateStatus;

  void setFormState (TkFormState state) {
    formState = state;
  }
  Future<Map> validate({List<String> fields}) {
    return formState.validate(fields: fields);
  }
}