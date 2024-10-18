import 'package:audio_player/src/constants/color_constants.dart';
import 'package:audio_player/src/constants/string_constants.dart';
import 'package:audio_player/src/views/audio_player/audio_player_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StringConstants.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorConstants.primary),
        useMaterial3: true,
      ),
      home: const AudioPlayerScreen(),
    );
  }
}