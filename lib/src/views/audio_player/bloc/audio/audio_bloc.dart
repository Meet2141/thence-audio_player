import 'dart:io';
import 'package:audio_player/src/constants/string_constants.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'audio_event.dart';
import 'audio_state.dart';
import 'package:just_audio/just_audio.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  String? localAudioFilePath;

  AudioBloc() : super(AudioInitial()) {
    on<LoadAudioEvent>((event, emit) async {
      emit(AudioLoading());
      final localFilePath = await _getLocalFilePath();
      if (await File(localFilePath).exists()) {
        localAudioFilePath = localFilePath;
        await audioPlayer.setFilePath(localAudioFilePath!);
        emit(AudioPaused());
      } else {
        await _downloadAndSaveAudioFile();
        await audioPlayer.setFilePath(localAudioFilePath!);
        emit(AudioPaused());
      }

      // Listen for the completion event
      audioPlayer.playerStateStream.listen((playerState) {
        // When audio finishes, reset to paused (i.e., show play button)
        if (playerState.processingState == ProcessingState.completed) {
          // Reset playback to the start
          audioPlayer.seek(Duration.zero);
          add(PauseAudioEvent());
        }
      });
    });

    on<PlayAudioEvent>((event, emit) {
      audioPlayer.play();
      emit(AudioPlaying());
    });

    on<PauseAudioEvent>((event, emit) {
      audioPlayer.pause();
      emit(AudioPaused());
    });
  }

  Future<void> _downloadAndSaveAudioFile() async {
    final response = await http.get(Uri.parse(StringConstants.audioUrl));

    if (response.statusCode == 200) {
      localAudioFilePath = await _getLocalFilePath();
      final file = File(localAudioFilePath ?? '');
      await file.writeAsBytes(response.bodyBytes);
    } else {
      throw Exception(StringConstants.failedToDownload);
    }
  }

  Future<String> _getLocalFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/background_music.mp3';
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}
