import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storage Access Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Storage Access'),
        ),
        body: const StorageAccess(),
      ),
    );
  }
}

class StorageAccess extends StatefulWidget {
  const StorageAccess({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StorageAccessState createState() => _StorageAccessState();
}

class _StorageAccessState extends State<StorageAccess> {
  String _filePath = 'No file path available';
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  // Request storage permission
  Future<void> _requestPermission() async {
    // Check if permission is already granted
    if (await Permission.storage.isGranted) {
      _logger.i("Storage permission already granted");
      _getFilePath();
    } else {
      // Request permission
      PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) {
        _logger.i("Storage permission granted");
        _getFilePath();
      } else if (status.isDenied) {
        _logger.w("Storage permission denied by user");
        // Handle permission denied
        _showPermissionDeniedDialog();
      } else if (status.isPermanentlyDenied) {
        _logger.w("Storage permission permanently denied");
        // Handle permission permanently denied
        await openAppSettings(); // Open app settings to let the user grant permission manually
      }
    }
  }

  Future<void> _getFilePath() async {
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      setState(() {
        _filePath = directory.path;
        _logger.i('Storage path: $_filePath');
      });
    }
  }

  // Show a dialog when permission is denied
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text('Storage permission is required to proceed.'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Storage Path:'),
          const SizedBox(height: 10),
          Text(_filePath, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
