import 'package:audio_player/src/views/audio_player/bloc/audio/audio_bloc.dart';
import 'package:audio_player/src/views/audio_player/bloc/audio/audio_event.dart';
import 'package:audio_player/src/views/audio_player/widgets/audio_player_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///AudioPlayerScreen - Audio Player Screen where AudioBloc is initialized and AudioPlayerView
class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AudioBloc()..add(LoadAudioEvent()),
      child: AudioPlayerView(),
    );
  }
}
