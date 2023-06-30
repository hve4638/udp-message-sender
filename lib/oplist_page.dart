import 'package:flutter/material.dart';
import 'op.dart';
import 'op_tab.dart';
import 'op_edit_page.dart';
import 'global.dart';
import 'op_sender.dart';

class OPInfo {
  OPInfo(this.filename, this.op);
  String filename;
  OP op;
}

class OpListPage extends StatefulWidget {
  const OpListPage({Key? key}) : super(key: key);

  @override
  State<OpListPage> createState() => _OpListPageState();
}

class _OpListPageState extends State<OpListPage> {
  final List<OPInfo> opList = [];

  void remove(String filename) async {
    var size = opList.length;
    var index = -1;
    for (var i = 0; i < size; i++) {
      if (opList[i].filename == filename) {
        index = i;
        break;
      }
    }

    setState(() {
      opList.removeAt(index);
    });
  }

  void add(String filename) async {
    var op = await OPFile.load(filename);

    setState(() {
      opList.add(OPInfo(filename, op));
    });
  }

  void update(String filename, OP op) async {
    await Future.delayed(const Duration(milliseconds: 100));
    print("Send");
    print("- ${op.ip}:${op.port} '${op.messageString}'");

    var size = opList.length;
    var index = -1;
    for (var i = 0; i < size; i++) {
      if (opList[i].filename == filename) {
        index = i;
        break;
      }
    }

    setState(() {
      opList[index] = OPInfo(filename, op);
    });
  }

  @override
  void initState() {
    super.initState();

    OPFile.addToManageFileCallback = add;
    OPFile.removeFromManageFileCallback = remove;
    OPFile.updateToManageFileCallback = update;

    for(var filename in Global.opFiles) {
      add(filename);
    }
  }

  @override
  Widget build(BuildContext context) {
    onEdit(String filename, OP op) {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => OpEditPage(
            filePath: filename,
            initOP : op
          )
      ));
    }
    onSend(String str, OP op) {
      OpSender.send(op.ip, op.port, op.messageString);
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListView.builder(
          itemCount: opList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var filename = opList[index].filename;
            var op = opList[index].op;

            return Column(
              children: [
                OpTab(
                    filePath: filename,
                    onEdit: onEdit,
                    onSend: onSend,
                    op : op,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 2, 32, 2),
                  child: Container(
                    height: 3,
                    color : const Color(0xff2c2c2e),
                  ),
                ),
              ],
            );
          }
      ),
    );
  }
}
