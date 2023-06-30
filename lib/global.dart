import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class Global {
  static late String targetPath;
  static late Directory targetDirectory;
  static late Directory documentDirectory;
  static late File manageFile;
  static bool complete = false;
  static List<String> opFiles = [];

  static Future<void> init() async {
    if (complete) return;

    documentDirectory = await getApplicationDocumentsDirectory();
    targetPath = '${documentDirectory.path}/OPSender';

    _initTargetDirectory(targetPath);
    _initManageFile('$targetPath/list.json');

    complete = true;
  }

  static void _initTargetDirectory(String targetPath) {
    targetDirectory = Directory(targetPath);

    if (!targetDirectory.existsSync()) {
      targetDirectory.createSync(recursive: true);
    }
  }

  static void _initManageFile(String managePath) {
    manageFile = File(managePath);
    if (!manageFile.existsSync()) {
      var map = <String, dynamic>{
        "op" : <String>[],
      };

      final jsonString = jsonEncode(map);
      manageFile.writeAsString(jsonString);
    }
  }
}