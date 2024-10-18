abstract class AudioState {
  const AudioState();
}

class AudioInitial extends AudioState {}

class AudioLoading extends AudioState {}

class AudioPlaying extends AudioState {}

class AudioPaused extends AudioState {}

class CompletedState extends AudioState {}

class AudioError extends AudioState {
  final String message;
  AudioError(this.message);
}
