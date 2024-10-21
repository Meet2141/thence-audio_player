import 'dart:io';
import 'package:audio_player/src/constants/string_constants.dart';
import 'package:audio_player/src/services/api_service.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'audio_event.dart';
import 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  late PlayerController _playerController;
  String? localAudioFilePath;

  PlayerController get playerController => _playerController;

  AudioBloc() : super(AudioLoading()) {
    _playerController = PlayerController();
    on<LoadAudioEvent>(_onLoadAudio);
    on<PlayAudioEvent>(_onPlayAudio);
    on<PauseAudioEvent>(_onPauseAudio);
    on<CompletedAudioEvent>(_onCompletedAudio); // Handle audio completion

    // Add listener for player controller state changes
    _playerController.onCompletion.listen((_) {
      add(CompletedAudioEvent()); // Dispatch event when audio completes
    });
  }

  Future<void> _onLoadAudio(LoadAudioEvent event, Emitter<AudioState> emit) async {
    emit(AudioLoading());
    try {
      final localFilePath = await appState.getLocalFilePath(StringConstants.fileName);
      if (await File(localFilePath).exists()) {
        localAudioFilePath = localFilePath;
        emit(AudioPaused());
      } else {
        await getDownloadedAudio();
      }
      await _playerController.preparePlayer(path: localAudioFilePath ?? '');
      emit(AudioPaused());

    } catch (e) {
      emit(AudioError(e.toString()));
    }
  }

  Future<void> _onPlayAudio(PlayAudioEvent event, Emitter<AudioState> emit) async {
    if (_playerController.playerState == PlayerState.stopped) {
      await _playerController.preparePlayer(path: localAudioFilePath ?? '');
    }
    await _playerController.startPlayer();
    emit(AudioPlaying());
  }

  Future<void> _onPauseAudio(PauseAudioEvent event, Emitter<AudioState> emit) async {
    await _playerController.pausePlayer();
    emit(AudioPaused());
  }

  Future<void> _onCompletedAudio(CompletedAudioEvent event, Emitter<AudioState> emit) async {
    await _playerController.stopPlayer();
    emit(AudioPaused()); // Reset to paused so the play button shows again
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
    _playerController.dispose();
    return super.close();
  }
}
