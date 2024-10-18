import 'dart:io';

import 'package:audio_player/src/constants/string_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

///ApiService - Include app api call method
class ApiService {
  Future<Response> downloadAndSaveAudioFile() async {
    try {
      final response = await http.get(Uri.parse(StringConstants.audioUrl));
      return response;
    }
    on SocketException catch (_) {
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
}
