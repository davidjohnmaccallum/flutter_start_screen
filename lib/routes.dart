import 'package:flutter/material.dart';
import 'package:start_screen/screens/media_player/media_player.dart';
import 'package:start_screen/screens/splash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  MediaPlayer.routeName: (context) => MediaPlayer(),
};
