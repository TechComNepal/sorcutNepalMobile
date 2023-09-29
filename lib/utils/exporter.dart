import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

final box = GetStorage();

bool checkFirstAppRun() => box.read("onboard") ?? true;
// bool checkFirstAppRun() => true;

String getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  return data.size.shortestSide < 600 ? 'phone' : 'tablet';
}
