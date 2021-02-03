import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';

class Player extends StatefulWidget {
  const Player({
    Key key,
    this.track = "",
    this.image,
    this.album = "",
  }) : super(key: key);
  final String track;
  final String album;
  final String image;

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  bool isPlaying = false;
  double sliderPos = 0.5;
  Duration played = Duration(minutes: 5, seconds: 30);
  Duration remaining = Duration(minutes: 5, seconds: 30);

  @override
  void initState() {
    super.initState();
    updatePlaybackState(AudioService.playbackState);
    AudioService.playbackStateStream.listen(updatePlaybackState);
  }

  void updatePlaybackState(PlaybackState state) {
    setState(() {
      isPlaying = state != null ? state.playing : false;
    });
  }

  format(Duration d) => d.toString().substring(2, 7);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: getProportionateScreenHeight(400),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 8.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          children: [
            Icon(Icons.horizontal_rule),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.asset(
                widget.image,
                fit: BoxFit.cover,
                height: getProportionateScreenWidth(300),
                width: getProportionateScreenWidth(300),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                widget.track,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.album,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                  fontSize: getProportionateScreenWidth(15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Slider(
                value: sliderPos,
                onChanged: (value) {
                  setState(() {
                    sliderPos = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Row(
                children: [
                  Text(
                    format(played),
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(10),
                    ),
                  ),
                  Spacer(),
                  Text(
                    format(remaining),
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(10),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      alignment: Alignment.centerLeft,
                      iconSize: getProportionateScreenWidth(30),
                      icon: Icon(Icons.playlist_play),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      iconSize: getProportionateScreenWidth(30),
                      icon: Icon(Icons.replay_10),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      iconSize: getProportionateScreenWidth(60),
                      icon: Icon(isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill),
                      onPressed: () {
                        isPlaying ? AudioService.pause() : AudioService.play();
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      iconSize: getProportionateScreenWidth(30),
                      icon: Icon(Icons.forward_30),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        "1.0x",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      iconSize: getProportionateScreenWidth(25),
                      icon: Icon(Icons.cast),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      alignment: Alignment.centerRight,
                      iconSize: getProportionateScreenWidth(25),
                      icon: Icon(Icons.share),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
