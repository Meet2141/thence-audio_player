abstract class AudioEvent {
  const AudioEvent();
}

class PlayAudioEvent extends AudioEvent {}

class PauseAudioEvent extends AudioEvent {}

class LoadAudioEvent extends AudioEvent {}
