import 'package:audio_player/src/constants/color_constants.dart';
import 'package:audio_player/src/views/audio_player/bloc/audio/audio_bloc.dart';
import 'package:audio_player/src/views/audio_player/bloc/audio/audio_event.dart';
import 'package:audio_player/src/views/audio_player/bloc/audio/audio_state.dart';
import 'package:audio_player/src/widgets/audio_equalizer.dart';
import 'package:audio_player/src/widgets/audio_tracker.dart';
import 'package:audio_player/src/widgets/player_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///AudioPlayer - Display Audio Player
class AudioPlayer extends StatelessWidget {
  final AudioBloc audioBloc;

  const AudioPlayer({
    super.key,
    required this.audioBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      bloc: audioBloc,
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          height: 100,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: SizedBox(
            height: 100,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: ColorConstants.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.3,
                    child: AudioTracker(
                      playerController: audioBloc.playerController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          if (state is AudioLoading)
                            const CircularProgressIndicator()
                          else if (state is AudioPaused || state is AudioCompleted)
                            PlayerButton(
                              icon: Icons.play_arrow,
                              onTap: () => audioBloc.add(PlayAudioEvent()),
                            )
                          else if (state is AudioPlaying)
                            PlayerButton(
                              icon: Icons.pause,
                              onTap: () => audioBloc.add(PauseAudioEvent()),
                            ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: AudioEqualizer(playerController: audioBloc.playerController),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
