import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

final String videoUrl = 'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4';

class MediaPlayer extends StatefulWidget {
  MediaPlayer({Key key}) : super(key: key);

  static final String routeName = "/player";

  @override
  _MediaPlayerState createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(videoUrl);
    _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      print("Video initialized");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              _controller.value.initialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
              Row(
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      _controller.value.isPlaying ? _controller.pause() : _controller.play();
                    },
                    child: Text("Play"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
