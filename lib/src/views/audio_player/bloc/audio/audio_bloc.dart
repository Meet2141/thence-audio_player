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
      try {
        final localFilePath = await _getLocalFilePath();
        if (await File(localFilePath).exists()) {
          localAudioFilePath = localFilePath;
          await audioPlayer.setFilePath(localAudioFilePath!);
          emit(AudioPaused());
        } else {
          await _downloadAndSaveAudioFile(); // Handle errors inside this function
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

  Future<void> _downloadAndSaveAudioFile() async {
    try {
      final response = await http.get(Uri.parse(StringConstants.audioUrl));

      if (response.statusCode == 200) {
        localAudioFilePath = await _getLocalFilePath();
        final file = File(localAudioFilePath ?? '');
        await file.writeAsBytes(response.bodyBytes);
      } else {
        throw HttpException('Failed to download audio file. Status code: ${response.statusCode}');
      }
    } on SocketException catch (_) {
      // Handle network issues
      throw Exception('No Internet connection. Please check your network.');
    } on HttpException catch (e) {
      // Handle download-specific issues
      throw Exception('HTTP Error: ${e.message}');
    } on Exception catch (e) {
      // General error
      throw Exception('Error occurred: ${e.toString()}');
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
