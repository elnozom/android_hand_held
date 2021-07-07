import 'package:flutter/material.dart';

PreferredSizeWidget appBar(title, tabs) {
  if (tabs == null) {
    return AppBar(
      title: Text(title),
    );
  }
  return AppBar(
    title: Text(title),
    bottom: TabBar(
      tabs: tabs,
    ),
  );
}
