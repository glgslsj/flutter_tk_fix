import 'package:logger/logger.dart';

Logger logger = Logger();

class TkLog {
  static StackTrace? get trace {
    try {
      var lines = StackTrace.current.toString().split('\n');
      var str = lines.sublist(3, 4).reversed.join('\n');
      return StackTrace.fromString(str);
    } catch (e) {
      return null;
    }
  }
  static v(dynamic message) {
    try {
      logger.v(message, null, TkLog.trace);
    } catch(e) {
      logger.v(message.toString(), null, TkLog.trace);
    }
  }
  static i(dynamic message) {
    try {
      logger.i(message, null, TkLog.trace);
    } catch(e) {
      logger.i(message.toString(), null, TkLog.trace);
    }
  }
  static d(dynamic message) {
    try {
      logger.d(message, null, TkLog.trace);
    } catch(e) {
      logger.d(message.toString(), null, TkLog.trace);
    }
  }
  static e(dynamic message) {
    try {
      logger.e(message, null, TkLog.trace);
    } catch(e) {
      logger.e(message.toString(), null, TkLog.trace);
    }
  }
  static w(dynamic message) {
    try {
      logger.w(message, null, TkLog.trace);
    } catch(e) {
      logger.w(message.toString(), null, TkLog.trace);
    }
  }
}

const D = TkLog.d;