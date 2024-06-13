import 'dart:convert'; // Import the dart:convert library
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class MySQL {
  String urlReadDatabase = "https://ums.blue/php/access.php";
  String urlexecuteDatabase = "https://ums.blue/php/access.php";
  String urlFileUpload = "https://ums.blue/php/upload.php";

  Future<List<Map<String, dynamic>>> readDatabase(String query) async {
    final response = await http.post(
      Uri.parse(urlReadDatabase),
      body: {
        'user': 'u918Ol5mnIK201',
        'password': '01pKOnak29max31',
        'database': 'arviya',
        'query': query,
      },
    );

    if (response.statusCode == 200) {
      try {
        final List<dynamic> jsonData = json.decode(response.body);

        List<Map<String, dynamic>> resultList = [];

        for (var item in jsonData) {
          if (item is Map<String, dynamic>) {
            resultList.add(item);
          }
        }

        return resultList;
      } catch (e) {
        print(
            "Query = \"$query\" \n Error decoding JSON response: ${response.body}");
        return [];
      }
    } else {
      throw Exception('Failed to load data from MySQL.');
    }
  }

  Future<void> executeDatabase(String query) async {
    final response = await http.post(
      Uri.parse(urlexecuteDatabase),
      body: {
        'user': 'u918Ol5mnIK201',
        'password': '01pKOnak29max31',
        'database': 'arviya',
        'query': query,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to execute query in MySQL.');
    }
  }

  Future<Uint8List?> downloadImage(String imageLink) async {
    final response = await http.get(Uri.parse(imageLink));
    if (response.statusCode == 200) {
      return (response.bodyBytes);
    } else {
      return (null);
    }
  }

  Future<String> uploadImage(String filePath, String customFileName) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(urlFileUpload));
      request.fields['customFileName'] = customFileName;

      String fileName = filePath.split('/').last;

      request.files.add(
        await http.MultipartFile.fromPath('file', filePath, filename: fileName),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      } else {
        throw Exception('Failed to upload image.');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}
