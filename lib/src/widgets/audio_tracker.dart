import 'package:audio_player/src/constants/color_constants.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

///AudioTracker - Display Tracker for music based on [playerController]
class AudioTracker extends StatelessWidget {
  final PlayerController playerController;

  const AudioTracker({super.key, required this.playerController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: playerController.onCurrentDurationChanged, // Stream that returns int (milliseconds)
      builder: (context, snapshot) {
        // Convert int (milliseconds) to Duration
        final currentPosition = Duration(milliseconds: snapshot.data ?? 0);
        final duration = Duration(milliseconds: playerController.maxDuration);

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
