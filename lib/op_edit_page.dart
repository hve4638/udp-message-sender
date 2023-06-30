import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'color_palette.dart';
import 'op.dart';
import 'global.dart';

class OpEditPage extends StatefulWidget {
  const OpEditPage({
    Key? key,
    required this.filePath,
    required this.initOP,
  }) : super(key: key);
  final String filePath;
  final OP initOP;

  @override
  State<OpEditPage> createState() => _OpEditPageState();
}

class _OpEditPageState extends State<OpEditPage> {
  bool deleted = false;
  late OP op;
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    op = widget.initOP.copy();
    _ipController.text = op.ip;
    _portController.text = "${op.port}";
    _messageController.text = op.messageString;
  }

  @override
  void dispose() {
    super.dispose();
    save();
  }

  void save() {
    if (!deleted) {
      op.ip = _ipController.text;
      op.port = int.parse(_portController.text);
      op.messageString = _messageController.text;
      OPFile.save(widget.filePath, op);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit OP',
        ),
        actions: [
          IconButton(
            onPressed: () {
              //OPFile.removeFromManageFileCallback?.call(widget.filePath);
              //OPFile.removeManageFile();
              OPFile.removeManageFile(widget.filePath);
              OPFile.saveManageFile();
              OPFile.remove(widget.filePath);
              deleted = true;
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete, color: Colors.white),
          )
        ],
        backgroundColor: Palette.background,
      ),
      backgroundColor: Palette.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 40,
                  child : Padding(
                      padding: EdgeInsets.all(4.0),
                      child : Center(
                        child: Text("ip",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0,0.0,16.0,0.0),
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      controller: _ipController,
                      onChanged: (value) {

                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 40,
                  child : Center(
                    child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child : Text("port",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0,0.0,16.0,0.0),
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      controller: _portController,
                      onChanged: (value) {
                        print("hi");
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 80,
                  child : Center(
                    child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child : Text("message",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0,0.0,16.0,0.0),
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      controller: _messageController,
                      onChanged: (value) {

                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
