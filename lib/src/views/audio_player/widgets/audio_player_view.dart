import 'package:audio_player/src/constants/color_constants.dart';
import 'package:audio_player/src/constants/string_constants.dart';
import 'package:audio_player/src/views/audio_player/bloc/audio/audio_bloc.dart';
import 'package:audio_player/src/views/audio_player/bloc/audio/audio_state.dart';
import 'package:audio_player/src/views/audio_player/widgets/audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///AudioPlayerView - Display appbar and audio player view
class AudioPlayerView extends StatelessWidget {
  const AudioPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    final audioBloc = context.read<AudioBloc>();
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
      body: BlocBuilder<AudioBloc, AudioState>(
        bloc: audioBloc,
        builder: (context, state) {
          if (state is AudioError) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                state.message,
                style: TextStyle(color: ColorConstants.red),
              ),
            );
          }
          return Center(
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
              child: AudioPlayer(audioBloc: audioBloc),
            ),
          );
        },
      ),
    );
  }
}
