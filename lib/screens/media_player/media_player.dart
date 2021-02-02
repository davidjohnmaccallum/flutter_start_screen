import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:start_screen/background_audio_task/audio_player_task.dart';
import 'package:start_screen/components/mini_player.dart';
import 'package:start_screen/size_config.dart';

class MediaPlayer extends StatefulWidget {
  MediaPlayer({Key key}) : super(key: key);

  static final String routeName = "/player";

  @override
  _MediaPlayerState createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  @override
  void initState() {
    super.initState();
    AudioService.playbackStateStream.listen((PlaybackState state) {
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
              Expanded(
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () async {
                        setState(() {
                          AudioService.start(
                              backgroundTaskEntrypoint: _entrypoint);
                        });
                      },
                      child: Text("Play"),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: AudioService.running
                    ? SizedBox(
                        height: getProportionateScreenHeight(60),
                        child: MiniPlayer(
                          image: 'assets/images/media_thumb.jpg',
                          text: "Live to worship God",
                        ),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Must be a top-level function
void _entrypoint() => AudioServiceBackground.run(() => AudioPlayerTask());
