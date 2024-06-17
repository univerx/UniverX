import 'package:flutter/material.dart';
import 'package:univerx/database/database_helper.dart';

void logout() async {
  await DatabaseHelper.instance.deleteNeptunLogin();
  await DatabaseHelper.instance.clearAllEvents();
}
