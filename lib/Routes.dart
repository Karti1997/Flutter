import 'package:flutter/material.dart';
import 'tasks.dart';

class Routes {
  Routes._();

  static const String listRoute = "/list";

  static Map<String, WidgetBuilder> define() {
    return {
      listRoute: (context) => AppListView(),
    };
  }
}
