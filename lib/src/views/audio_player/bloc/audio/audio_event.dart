abstract class AudioEvent {
  const AudioEvent();
}

class LoadAudioEvent extends AudioEvent {}
class PlayAudioEvent extends AudioEvent {}
class PauseAudioEvent extends AudioEvent {}
class CompletedAudioEvent extends AudioEvent {}

