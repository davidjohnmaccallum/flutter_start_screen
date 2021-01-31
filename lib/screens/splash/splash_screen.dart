import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:start_screen/size_config.dart';

import 'components/body.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  static final String routeName = "/splash";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AudioServiceWidget(child: Scaffold(body: Body()));
  }
}
