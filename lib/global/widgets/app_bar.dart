import 'package:flutter/material.dart';

AppBar appBar = AppBar(
  title: Text("eCampusGuard"),
  centerTitle: true,
  leading: IconButton(
    icon: Icon(Icons.menu),
    onPressed: () {},
  ),
  actions: [
    IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
    IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
  ],
);
