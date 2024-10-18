import 'dart:math';
import 'package:audio_player/src/constants/color_constants.dart';
import 'package:flutter/material.dart';

///AudioEqualizer - Display AudioEqualizer widget based on [isPlaying] and [isStopped].
class AudioEqualizer extends StatefulWidget {
  final bool isPlaying;
  final bool isStopped;

  const AudioEqualizer({
    super.key,
    required this.isPlaying,
    required this.isStopped,
  });

  @override
  AudioEqualizerState createState() => AudioEqualizerState();
}

class AudioEqualizerState extends State<AudioEqualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<double> _barHeights = [];
  double _phase = 0.0;

  @override
  void initState() {
    super.initState();
    int numberOfBars = 20;
    _barHeights = List.generate(numberOfBars, (index) => 0.0);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {
          _phase += 0.1;
          if (widget.isPlaying) {
            _barHeights = List.generate(numberOfBars, (index) {
              double wave = sin(index * pi / 5 + _phase);
              return (wave.abs() + 0.1);
            });
          }
        });
      });

    // Start the controller only when the widget is initialized
    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AudioEqualizer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Start or stop the animation based on the `isPlaying` value
    if (widget.isPlaying) {
      _controller.repeat();
    } else if (widget.isStopped) {
      _controller.stop();
      _resetEqualizer();
    } else {
      _controller.stop();
    }
  }

  void _resetEqualizer() {
    setState(() {
      _barHeights = List.generate(_barHeights.length, (index) => 0.0); // Reset all bar heights
      _phase = 0.0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AudioEqualizerPainter(_barHeights),
      child: SizedBox(
        height: 70,
        width: double.infinity,
      ),
    );
  }
}

/// AudioEqualizerPainter - Create Audio Equalizer painter.
class AudioEqualizerPainter extends CustomPainter {
  final List<double> barHeights;

  AudioEqualizerPainter(this.barHeights);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorConstants.primary.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final barWidth = size.width / (barHeights.length * 1.5);
    final spacing = barWidth / 2;

    for (int i = 0; i < barHeights.length; i++) {
      final barHeight = barHeights[i] * size.height; // Scale the height to the canvas
      final x = i * (barWidth + spacing); // Add spacing between bars
      final y = size.height - barHeight; // Start drawing from the bottom of the canvas

      final rect = Rect.fromLTWH(x, y, barWidth, barHeight);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
