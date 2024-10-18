import 'dart:io';
import 'package:audio_player/src/constants/string_constants.dart';
import 'package:audio_player/src/services/api_service.dart';
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
      try {
        final localFilePath = await appState.getLocalFilePath(StringConstants.fileName);
        if (await File(localFilePath).exists()) {
          localAudioFilePath = localFilePath;
          await audioPlayer.setFilePath(localAudioFilePath!);
          emit(AudioPaused());
        } else {
          await getDownloadedAudio();
          await audioPlayer.setFilePath(localAudioFilePath!);
          emit(AudioPaused());
        }

        // Disable repeat mode if the audio completes
        audioPlayer.playerStateStream.listen((playerState) {
          if (playerState.processingState == ProcessingState.completed) {
            add(CompletedAudioEvent());
          }
        });
      } catch (e) {
        emit(AudioError(e.toString()));
      }

      audioPlayer.setLoopMode(LoopMode.off);
    });

    on<PlayAudioEvent>((event, emit) {
      audioPlayer.play();
      emit(AudioPlaying());
    });

    on<PauseAudioEvent>((event, emit) {
      audioPlayer.pause();
      emit(AudioPaused());
    });

    on<CompletedAudioEvent>((event, emit) {
      audioPlayer.seek(Duration.zero);
      add(PauseAudioEvent());
      audioPlayer.stop();
      emit(CompletedState());
    });
  }

  Future<void> getDownloadedAudio() async {
    final response = await ApiService().downloadAndSaveAudioFile();
    if (response.statusCode == 200) {
      localAudioFilePath = await appState.getLocalFilePath(StringConstants.fileName);
      final file = File(localAudioFilePath ?? '');
      await file.writeAsBytes(response.bodyBytes);
    } else {
      throw HttpException('Failed to download audio file. Status code: ${response.statusCode}');
    }
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}
