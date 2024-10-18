import 'package:path_provider/path_provider.dart';

class AppState {
  AppState._internal();

  static final AppState _appState = AppState._internal();

  factory AppState() {
    return _appState;
  }

  Future<String> getLocalFilePath(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$filename.mp3';
  }
}
