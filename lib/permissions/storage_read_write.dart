import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

class StorageHelper {
  final Logger _logger = Logger();

  // Write a file
  Future<void> writeFile(String content, String fileName) async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final file = File('${directory.path}/$fileName');
        await file.writeAsString(content);
        _logger.i("File written successfully: $fileName");
      }
    } catch (e) {
      _logger.e("Error writing file: $e");
    }
  }

  // Read a file
  Future<String?> readFile(String fileName) async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final file = File('${directory.path}/$fileName');
        if (await file.exists()) {
          String fileContent = await file.readAsString();
          _logger.i("File read successfully: $fileName");
          return fileContent;
        } else {
          _logger.w("File does not exist: $fileName");
          return null;
        }
      }
    } catch (e) {
      _logger.e("Error reading file: $e");
    }
    return null;
  }
}
