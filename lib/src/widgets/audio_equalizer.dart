import 'package:audio_player/src/constants/color_constants.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

///AudioEqualizer - Display Audio Waves based on [playerController].
class AudioEqualizer extends StatelessWidget {
  final PlayerController playerController;

  const AudioEqualizer({
    super.key,
    required this.playerController,
  });

  @override
  Widget build(BuildContext context) {
    return AudioFileWaveforms(
      playerController: playerController,
      size: Size(double.infinity, 70),
      playerWaveStyle: PlayerWaveStyle(
        waveThickness: 3,
        liveWaveColor: ColorConstants.primary,
        fixedWaveColor: ColorConstants.grey.withOpacity(0.5),
      ),
    );
  }
}
