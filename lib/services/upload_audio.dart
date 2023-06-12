import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'dart:developer' as devtools show log;

class UploadAudio {
  static Future<Map<String, dynamic>> uploadAudio(String audioFilePath) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8000/upload-audio'),
      );
      final audioFileField =
          await http.MultipartFile.fromPath('file', audioFilePath);
      request.files.add(audioFileField);
      // Send the request and await the response
      final response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        //returns song
        var responseBody = await response.stream.bytesToString();
        Map<String, dynamic> useResponse = jsonDecode(responseBody);
        // String songName = useResponse['name'];
        return useResponse;

        // Print the values
      } else {
        // devtools
        // .log('Failed to upload audio. StatusCode: ${response.statusCode}');
        throw Exception(
            'Failed to upload audio. StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      // devtools.log('Error occurred while uploading audio: $e');
      throw Exception('Error occured while uploading audio: $e');
    }
  }
}
