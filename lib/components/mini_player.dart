import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({
    Key key,
    this.text,
    this.image,
  }) : super(key: key);
  final String text;
  final String image;

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  bool isPlaying = false;

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(60),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset(
              widget.image,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  widget.text,
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                isPlaying ? AudioService.pause() : AudioService.play();
              },
            ),
          ],
        ),
      ),
    );
  }
}
