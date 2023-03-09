// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tk/form/tk_field.dart';
import 'package:flutter_tk/tk_box.dart';

class ModelTextField extends StatefulWidget {
  ModelTextField({
    Key key,
    @required this.name,
    this.onChanged,
    this.onBlur,
    this.onFocus,
    this.obscureText = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.validators,
    this.onValidatePass,
    this.tooltip,
    this.label,
    this.onFieldSubmitted,
    this.textInputAction,
    this.inputDecoration,
    this.textAlign = TextAlign.start,
    this.autoValidate = true,
    this.keyboardKeys,
    this.maxLength,
    this.inputFormatters,
    this.hideSucessIcon = false,
    this.placeHolder,
    this.textCapitalization = TextCapitalization.none,
    this.formatValue, this.style,
  }) : super(key: key);
  final TextInputType keyboardKeys;
  final String name;
  final Function onChanged;
  final Function onBlur;
  final Function onFocus;
  final Function formatValue;
  final Function onValidatePass;
  final Function onFieldSubmitted;
  final bool hideSucessIcon;
  final bool obscureText;
  final bool autofocus;
  final bool autoValidate;
  final int maxLines;
  final List<Function> validators;
  final String tooltip;
  final String label;
  final String placeHolder;
  final TextInputAction textInputAction;
  final InputDecoration inputDecoration;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final int maxLength;
  final List<TextInputFormatter> inputFormatters;
  final TextStyle style;

  @override
  _ModelTextFieldState createState() => _ModelTextFieldState();
}

class _ModelTextFieldState extends State<ModelTextField> {
  TextEditingController _controller = TextEditingController();
  GlobalKey<TkFieldState> _key = GlobalKey();

  void onFieldSubmitted(String value) {
    if (widget.onFieldSubmitted != null)
      widget.onFieldSubmitted(value);
    else if (widget.textInputAction == TextInputAction.next) {
      FocusScope.of(context).nextFocus();
    }
  }

  void setFieldValue(value) {
    if (widget.formatValue != null) value = widget.formatValue(value);
    if (_controller.text != value) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _controller.text = value);
    }
  }

  void onBlur() {
    if (widget.autoValidate) _key.currentState.validate();
    if (widget.onBlur != null) widget.onBlur();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: TkField(
        key: _key,
        name: widget.name,
        onChanged: widget.onChanged,
        onBlur: onBlur,
        onFocus: widget.onFocus,
        validators: widget.validators,
        onValidatePass: widget.onValidatePass,
        autoValidate: false,
        builder: (BuildContext context, FieldState fieldState) {
          setFieldValue(fieldState.value);
          Widget icon;
          switch (fieldState.validatStatus) {
            case ValidatStatus.LOADING:
              icon = Container(
                width: 18,
                child: SpinKitRing(
                  lineWidth: 2,
                  size: 18,
                  color: Theme.of(context).primaryColor,
                ),
              );
              break;
            case ValidatStatus.FAILED:
              icon = Icon(Icons.error, color: Colors.red,);
              break;
            case ValidatStatus.SUCCESS:
              icon = widget.hideSucessIcon ? null : Icon(Icons.done, color: Colors.green,);
              break;
            case ValidatStatus.NONE:
              break;
          }
          var inputDecoration = InputDecoration(
            helperText: widget.tooltip ?? ' ',
            errorText: fieldState.error,
            labelText: widget.label,
            hintText: widget.placeHolder,
            suffix: icon,
          );
          return TextFormField(
            style: widget.style,
            maxLength: widget.maxLength,
            controller: _controller,
            autofocus: widget.autofocus,
            maxLines: widget.maxLines,
            inputFormatters: widget.inputFormatters,
            decoration: widget.inputDecoration ?? inputDecoration,
            textInputAction: widget.textInputAction,
            obscureText: widget.obscureText,
            onFieldSubmitted: onFieldSubmitted,
            textCapitalization: widget.textCapitalization,
            onChanged: (val) {
              fieldState.onChanged(_controller.text);
            },
            focusNode: fieldState.focusNode,
            textAlign: widget.textAlign,
            keyboardType: widget.keyboardKeys,
          );
        },
      ),
    );
  }
}
