import 'package:flutter/material.dart';

import '../presentation/views/home.dart';

const String home = '/';
const String search = '/search';

Route<dynamic> controller(RouteSettings settings){
  switch (settings.name){
    case home:
      return MaterialPageRoute(
          builder: (context) => const Home(),
      );
    default:
      throw ('the route is unavailable!');
  }
}