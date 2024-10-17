import 'package:audio_player/src/constants/color_constants.dart';
import 'package:audio_player/src/constants/string_constants.dart';
import 'package:audio_player/src/views/audio_player/widgets/audio_player.dart';
import 'package:flutter/material.dart';

///AudioPlayerView - Display appbar and audio player view
class AudioPlayerView extends StatelessWidget {
  const AudioPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.primary,
        title: Text(
          StringConstants.appName,
          style: TextStyle(
            color: ColorConstants.white,
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.sizeOf(context).height / 3,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorConstants.primary,
                ColorConstants.blue,
              ],
              begin: const FractionalOffset(0.0, 0.3),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: AudioPlayer(),
        ),
      ),
    );
  }
}
