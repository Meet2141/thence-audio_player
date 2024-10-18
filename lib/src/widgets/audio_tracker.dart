import 'package:audio_player/src/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

///AudioTracker - Display Tracker for music based on [audioPlayer]
class AudioTracker extends StatelessWidget {
  final AudioPlayer audioPlayer;

  const AudioTracker({super.key, required this.audioPlayer});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: audioPlayer.positionStream,
      builder: (context, snapshot) {
        final currentPosition = snapshot.data ?? Duration.zero;
        final duration = audioPlayer.duration ?? Duration.zero;

        return CustomPaint(
          size: Size(double.infinity, 100),
          painter: AudioTrackerPainter(
            currentPosition: currentPosition,
            duration: duration,
          ),
        );
      },
    );
  }
}

///AudioTrackerPainter - Create tracker painter using [currentPosition] and [duration].
class AudioTrackerPainter extends CustomPainter {
  final Duration currentPosition;
  final Duration duration;

  AudioTrackerPainter({required this.currentPosition, required this.duration});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorConstants.grey
      ..style = PaintingStyle.fill;

    final width = size.width;
    final height = size.height;

    // Check if duration is greater than zero to prevent division by zero
    if (duration.inMilliseconds > 0) {
      // Calculate filled width
      double filledWidth = (currentPosition.inMilliseconds / duration.inMilliseconds) * width;
      // Ensure filledWidth does not exceed the width of the canvas
      filledWidth = filledWidth.clamp(0.0, width);

      // Draw the filled part based on the current audio position
      canvas.drawRect(Rect.fromLTWH(0, 0, filledWidth, height), paint);
    }

    // Draw the border
    paint.color = ColorConstants.white;
    paint.style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
