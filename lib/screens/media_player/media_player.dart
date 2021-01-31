import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

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
              Container(),
              Row(
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      await AudioService.start(
                          backgroundTaskEntrypoint: _entrypoint);
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
