import 'dart:convert';
import 'dart:typed_data';

import 'utils.dart';

DateTime dateTimeFromJson(int value) {
  return DateTime.fromMillisecondsSinceEpoch(value);
}

int dateTimeToJson(DateTime value) {
  return value.millisecondsSinceEpoch;
}

Map<String, dynamic> jsonFromString(String value) {
  return jsonDecode(value);
}

String jsonToString(Map<String, dynamic> value) {
  return jsonEncode(value);
}

Avatar avatarFromJson(String value) {
  return Avatar.fromString(value);
}

String avatarToJson(Avatar value) {
  return value.value;
}

Uint8List base64DataFromJson(String value) {
  return base64Decode(value);
}

String base64DataToJson(Uint8List value) {
  return base64Encode(value);
}
