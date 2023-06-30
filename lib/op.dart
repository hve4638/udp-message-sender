import 'dart:io';
import 'dart:convert';
import 'global.dart';

typedef StringCallback = void Function(String);
typedef OPCallback = void Function(String, OP);

enum OPMessageType {
  string, hex
}

class OP {
  String title = "New Message";
  String ip = "";
  int port = 9;
  String messageString = "";
  List<int> messageHex = [];
  OPMessageType messageType = OPMessageType.string;

  OP copy() {
    var copied = OP();
    copied.title = title;
    copied.ip = ip;
    copied.port = port;
    copied.messageString = messageString;
    copied.messageHex = List.from(messageHex);
    copied.messageType = messageType;

    return copied;
  }
}

class OPFile {
  static StringCallback? addToManageFileCallback;
  static StringCallback? removeFromManageFileCallback;
  static OPCallback? updateToManageFileCallback;

  static String generateFilename() {
    final now = DateTime.now();
    const formattedPrefix = "OP_";
    final formattedDate = "${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)}";
    final formattedTime = "${_twoDigits(now.hour)}${_twoDigits(now.minute)}${_twoDigits(now.second)}${_fourDigits(now.millisecond)}";
    return "$formattedPrefix$formattedDate$formattedTime.json";
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
  static String _fourDigits(int n) {
    if (n >= 100) return "$n";
    if (n >= 10) return "0$n";
    return "00$n";
  }

  static void createFolder(String dir) {
    final directory = Global.documentDirectory;
    final newPath = '${directory.path}/$dir';

    final folder = Directory(newPath);
    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
    }
  }

  static void save(String filename, OP op) {
    final directory = Global.targetDirectory;
    final file = File('${directory.path}/$filename');

    var map = <String, dynamic>{
      "title" : op.title,
      "ip" : op.ip,
      "port" : "${op.port}",
      "messageString" : op.messageString,
      "messageHex" : op.messageHex,
      "messageType" : opMessageTypeToStr(op.messageType),
    };

    final jsonString = jsonEncode(map);
    file.writeAsString(jsonString);

    updateToManageFileCallback?.call(filename, op);
  }

  static Future<OP> load(String filename) async {
    final directory = Global.targetPath;
    final file = File('$directory/$filename');

    var op = OP();
    if (file.existsSync()) {
      final jsonString = await file.readAsString();
      final json = jsonDecode(jsonString);

      try {
        op.title = json["title"];
        op.ip = json["ip"];
        op.port = int.parse(json["port"]);
        op.messageType = strToOpMessageType(json["messageType"]);
        if (op.messageType == OPMessageType.hex) {
          op.messageHex = json["messageHex"] as List<int>;
        }
        else {
          op.messageString = json["messageString"];
        }
      }
      catch(ex) {
        print("Exception Occur while load OP");
        print(" filename : ${file.path}");
        print(" reason : $ex");
        op = OP();
      }
    }
    else {
      print("load fail");
    }

    return op;
  }

  static void remove(String filename) {
    final directory = Global.targetPath;
    final file = File('$directory/$filename');
    if (file.existsSync()) {
      file.delete();
    }

    OPFile.removeFromManageFileCallback?.call(filename);
  }

  static String opMessageTypeToStr(OPMessageType messageType) {
    switch(messageType) {
      case OPMessageType.hex:
        return "hex";
      case OPMessageType.string:
      default:
        return "none";
    }
  }

  static OPMessageType strToOpMessageType(String messageTypeStr) {
    switch(messageTypeStr) {
      case "hex":
        return OPMessageType.hex;
      case "string":
      default:
        return OPMessageType.string;
    }
  }

  static void saveManageFile() async {
    final file = Global.manageFile;
    var map = <String, dynamic>{
      "op" : Global.opFiles
    };

    final jsonString = jsonEncode(map);
    file.writeAsString(jsonString);
  }

  static Future<void> loadManageFile() async {
    final file = Global.manageFile;

    var op = OP();
    if (file.existsSync()) {
      final contents = await file.readAsString();
      final json = jsonDecode(contents);
      if (json["op"] is List<dynamic>) {
        Global.opFiles = [];
        for (var ele in json["op"]) {
          Global.opFiles.add(ele.toString());
        }
      }
    }
  }

  static void addManageFile(String filename) async {
    Global.opFiles.add(filename);
    addToManageFileCallback?.call(filename);
  }

  static void removeManageFile(String filename) async {
    Global.opFiles.remove(filename);
    removeFromManageFileCallback?.call(filename);
  }
}



