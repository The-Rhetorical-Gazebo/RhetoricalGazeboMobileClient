import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import "package:flutter_secure_storage/flutter_secure_storage.dart";

final _storage = new FlutterSecureStorage();
Future<bool> writeToLocalStorage(String field, dynamic value) async {
  try {
    await _storage.write(key: field, value: json.encode(value));
    return true;
  } catch (err) {
    print("Failed to write to local storage: $err");
    return false;
  }
}

Future<dynamic> readFromLocalStorage(String field) async {
  try {
    var ret = json.decode((await _storage.read(key: field))!);
    return ret;
  } catch (err) {
    print("Field not present: $field");
    return null;
  }
}

Future<bool> removeFromLocalStorage(String field) async {
  try {
    await _storage.delete(key: field);
    return true;
  } catch (err) {
    print("Cannot remove => Field not present in local storage: $field");
    return false;
  }
}

Future<bool> clearLocalStorage() async {
  try {
    await _storage.deleteAll();
    return true;
  } catch (err) {
    print("Failed to clear local storage: $err");
    return false;
  }
}
