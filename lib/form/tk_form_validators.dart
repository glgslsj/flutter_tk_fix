// @dart=2.9
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class TkFormValidators {
  /// [FormFieldValidator] that requires the field have a non-empty value.
  static FormFieldValidator required({
    String errorText = "不能留空",
  }) {
    return (valueCandidate) {
      if (valueCandidate == null ||
          ((valueCandidate is Iterable ||
                  valueCandidate is String ||
                  valueCandidate is Map) &&
              valueCandidate.length == 0)) {
        return errorText;
      }
      return null;
    };
  }

  /// [FormFieldValidator] that requires the field's value be true.
  /// Commonly used for required checkboxes.
  static FormFieldValidator requiredTrue({
    String errorText = "这里必须选中",
  }) {
    return (valueCandidate) {
      if (valueCandidate != true) {
        return errorText;
      }
      return null;
    };
  }

  /// [FormFieldValidator] that requires the field's value to be greater than
  /// or equal to the provided number.
  static FormFieldValidator min(
    num min, {
    String errorText,
  }) {
    return (valueCandidate) {
      if (valueCandidate != null &&
          ((valueCandidate is num && valueCandidate < min) ||
              (valueCandidate is String &&
                  num.tryParse(valueCandidate) != null &&
                  num.tryParse(valueCandidate) < min))) {
        return errorText ?? "输入必须大于或等于 $min";
      }
      return null;
    };
  }

  /// [FormFieldValidator] that requires the field's value to be less than
  /// or equal to the provided number.
  static FormFieldValidator max(
    num max, {
    String errorText,
  }) {
    return (valueCandidate) {
      if (valueCandidate != null) {
        if ((valueCandidate is num && valueCandidate > max) ||
            (valueCandidate is String &&
                num.tryParse(valueCandidate) != null &&
                num.tryParse(valueCandidate) > max)) {
          return errorText ?? "输入必须小于或等于 $max";
        }
      }
      return null;
    };
  }

  /// [FormFieldValidator] that requires the length of the field's value to be
  /// greater than or equal to the provided minimum length.
  static FormFieldValidator minLength(
    num minLength, {
    String errorText,
  }) {
    return (valueCandidate) {
      if (valueCandidate != null && valueCandidate.length < minLength) {
        return errorText ?? "至少需要输入 $minLength 个字符";
      }
      return null;
    };
  }

  /// [FormFieldValidator] that requires the length of the field's value to be
  /// less than or equal to the provided maximum length.
  static FormFieldValidator maxLength(
    num maxLength, {
    String errorText,
  }) {
    return (valueCandidate) {
      if (valueCandidate != null && valueCandidate.length > maxLength) {
        return errorText ?? "最多只能输入 $maxLength 个字符";
      }
      return null;
    };
  }

  /// [FormFieldValidator] that requires the field's value to be a valid email address.
  static FormFieldValidator email({
    String errorText = "请填写正确的邮箱地址",
  }) {
    return (valueCandidate) {
      if (valueCandidate != null && valueCandidate.isNotEmpty) {
        if (!EmailValidator.validate(valueCandidate.trim())) return errorText;
      }
      return null;
    };
  }

  /// [FormFieldValidator] that requires the field's value to be a valid url.
  static FormFieldValidator url(
      {String errorText = "请填写正确的链接地址",
      List<String> protocols = const ['http', 'https', 'ftp'],
      bool requireTld = true,
      bool requireProtocol = false,
      bool allowUnderscore = false,
      List<String> hostWhitelist = const [],
      List<String> hostBlacklist = const []}) {
    return (valueCandidate) {
      if (valueCandidate != null && valueCandidate.isNotEmpty) {
        if (!isURL(valueCandidate,
            protocols: protocols,
            requireTld: requireTld,
            requireProtocol: requireProtocol,
            allowUnderscore: allowUnderscore,
            hostWhitelist: hostWhitelist,
            hostBlacklist: hostBlacklist)) return errorText;
      }
      return null;
    };
  }

  /// [FormFieldValidator] that requires the field's value to match the provided regex pattern.
  static FormFieldValidator pattern(
    Pattern pattern, {
    String errorText = "格式错误",
  }) {
    return (valueCandidate) {
      if (valueCandidate != null && valueCandidate.isNotEmpty) {
        if (!RegExp(pattern).hasMatch(valueCandidate)) return errorText;
      }
      return null;
    };
  }

  /// [FormFieldValidator] that requires the field's value to be a valid number.
  static FormFieldValidator numeric({
    String errorText = "只能输入数字",
  }) {
    return (valueCandidate) {
      if (num.tryParse(valueCandidate) == null && valueCandidate.isNotEmpty)
        return errorText;
      return null;
    };
  }

  /// [FormFieldValidator] that requires the field's value to be a valid credit card number.
  static FormFieldValidator creditCard({
    String errorText = "银行卡号不正确",
  }) {
    return (valueCandidate) {
      if (valueCandidate != null && valueCandidate.isNotEmpty) {
        if (!isCreditCard(valueCandidate)) return errorText;
      }
      return null;
    };
  }

  /// [FormFieldValidator] that requires the field's value to be a valid IP address.
  /// * [version] is a String or an `int`.
  // ignore: non_constant_identifier_names
  static FormFieldValidator IP({
    dynamic version,
    String errorText = "请填写正确的ip地址",
  }) {
    return (valueCandidate) {
      if (valueCandidate != null && valueCandidate.isNotEmpty) {
        if (!isIP(valueCandidate, version)) return errorText;
      }
      return null;
    };
  }

  /// [FormFieldValidator] that requires the field's value to be a valid date string.
  static FormFieldValidator date({
    String errorText = "请输入正确的日期",
  }) {
    return (valueCandidate) {
      if (valueCandidate != null && valueCandidate.isNotEmpty) {
        if (!isDate(valueCandidate)) return errorText;
      }
      return null;
    };
  }
}
