import 'package:flutter/material.dart';
import 'package:start_screen/screens/splash/components/splash_content.dart';

List<Map<String, String>> splashData = [
  {
    "text": "Adopt a plant",
    "image": "assets/images/plant1.png",
  },
  {
    "text": "Befriend a furn",
    "image": "assets/images/plant2.png",
  },
  {
    "text": "Go green",
    "image": "assets/images/plant3.png",
  },
];

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  text: splashData[index]["text"],
                  image: splashData[index]["image"],
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[],
                ))
          ],
        ),
      ),
    );
  }
}
