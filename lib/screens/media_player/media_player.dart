import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:start_screen/size_config.dart';

class MediaPlayer extends StatefulWidget {
  MediaPlayer({Key key}) : super(key: key);

  static final String routeName = "/player";

  @override
  _MediaPlayerState createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
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
                        await AudioService.start(
                            backgroundTaskEntrypoint: _entrypoint);
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
                child: SizedBox(
                  height: getProportionateScreenHeight(60),
                  child: MiniPlayer(
                    image: 'assets/images/media_thumb.jpg',
                    text: "Live to worship God",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({
    Key key,
    this.text,
    this.image,
    this.onPlay,
    this.onPause,
  }) : super(key: key);
  final String text;
  final String image;
  final Function() onPlay;
  final Function() onPause;

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            onPressed: isPlaying ? widget.onPause : widget.onPlay,
          ),
        ],
      ),
    );
  }
}

// Must be a top-level function
void _entrypoint() => AudioServiceBackground.run(() => AudioPlayerTask());

final String url =
    'https://storage.googleapis.com/1a28da50-b6cc-11ea-9d3d-6b9876fb2fba/sermons/1ipwbC6H6vdNEreYlzyC';

class AudioPlayerTask extends BackgroundAudioTask {
  final _player = AudioPlayer(); // e.g. just_audio

  // Implement callbacks here. e.g. onStart, onStop, onPlay, onPause

  onStart(Map<String, dynamic> params) async {
    final mediaItem = MediaItem(
      id: url,
      album: "David MacCallum",
      title: "Dreaming of Heaven",
    );
    // Tell the UI and media notification what we're playing.
    AudioServiceBackground.setMediaItem(mediaItem);
    // Listen to state changes on the player...
    _player.playerStateStream.listen((playerState) {
      // ... and forward them to all audio_service clients.
      AudioServiceBackground.setState(
        playing: playerState.playing,
        // Every state from the audio player gets mapped onto an audio_service state.
        processingState: {
          ProcessingState.idle: AudioProcessingState.none,
          ProcessingState.loading: AudioProcessingState.connecting,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[playerState.processingState],
        // Tell clients what buttons/controls should be enabled in the
        // current state.
        controls: [
          playerState.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.stop,
        ],
      );
    });
    // Play when ready.
    _player.play();
    // Start loading something (will play when ready).
    await _player.setUrl(mediaItem.id);
  }

  onPlay() => _player.play();
  onPause() => _player.pause();
  onSeekTo(Duration duration) => _player.seek(duration);
  onSetSpeed(double speed) => _player.setSpeed(speed);
  onStop() async {
    // Stop and dispose of the player.
    await _player.dispose();
    // Shut down the background task.
    await super.onStop();
  }
}
