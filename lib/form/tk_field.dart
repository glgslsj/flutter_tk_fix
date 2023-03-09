// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tk/form/tk_form.dart';

enum ValidatStatus { NONE, LOADING, SUCCESS, FAILED }

class FieldState {
  FieldState({
    this.onChanged,
    this.focusNode,
    this.value,
    this.validatStatus,
    this.validate,
    this.error,
  });

  final Function onChanged;
  final FocusNode focusNode;
  final dynamic value;
  final ValidatStatus validatStatus;
  final Function validate;
  final String error;
}

class TkField extends StatefulWidget {
  TkField({
    Key key,
    @required this.name,
    this.onChanged,
    this.onBlur,
    this.onFocus,
    this.autofocus = false,
    this.validators,
    this.onValidatePass,
    this.tooltip,
    @required this.builder,
    this.autoValidate = true,
    KeyboardKey keyboardTypes,
  }) : super(key: key);

  final String name;
  final Function onChanged;
  final Function onBlur;
  final Function onFocus;
  final Function onValidatePass;
  final bool autofocus;
  final bool autoValidate;
  final List<Function> validators;
  final String tooltip;
  final Function builder;

  @override
  TkFieldState createState() => TkFieldState();
}

class TkFieldState extends State<TkField> {
  dynamic cacheValue;
  final FocusNode _focusNode = FocusNode();
  TkFormState _form;
  String error;
  ValidatStatus validatStatus = ValidatStatus.NONE;

  @override
  void initState() {
    _form = TkForm.of(context);
    _form.registerField(widget.name, this);
    var initValue = _form.getValue(widget.name);
    if (initValue != null) setValue(initValue);
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        this.onFocus();
      } else {
        this.onBlur();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _form.unregisterField(widget.name);
    _focusNode.dispose();
    super.dispose();
  }

  onFocus() {
    setState(() {});
    if (widget.onFocus != null) widget.onFocus();
  }

  onBlur() {
    setState(() {});
    if (widget.autoValidate) this.validate();
    if (widget.onBlur != null) widget.onBlur();
  }

  setValue(value) {
    if (cacheValue != value) {
      var isInitValue = cacheValue == null;
      setState(() {
        cacheValue = value;
      });
      if (widget.onChanged != null) widget.onChanged(value);
      if (!isInitValue && cacheValue != null && widget.autoValidate)
        this.validate();
    }
  }

  updateValue(value) {
    this.error = null;
    this.validatStatus = ValidatStatus.NONE;
    _form.setFieldValue(widget.name, value);
    _form.setFieldValidateStatus(widget.name, validatStatus);
  }

  Future validate() async {
    this.error = null;
    if (widget.validators == null) return null;
    String error;
    for (var validator in widget.validators) {
      var rs = validator(cacheValue);
      if (rs is Future) {
        validatStatus = ValidatStatus.LOADING;
        setState(() {});
        error = await rs;
      } else {
        error = rs;
      }
      if (error != null) {
        this.error = error;
        break;
      }
    }
    if (this.error == null)
      validatStatus = ValidatStatus.SUCCESS;
    else {
      validatStatus = ValidatStatus.FAILED;
    }
    _form.setFieldValidateStatus(widget.name, validatStatus);
    if (this.error == null && widget.onValidatePass != null)
      widget.onValidatePass();
    setState(() {});
    return this.error;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
        context,
        FieldState(
          onChanged: updateValue,
          focusNode: _focusNode,
          value: cacheValue,
          validatStatus: validatStatus,
          validate: validate,
          error: error,
        ));
  }
}
