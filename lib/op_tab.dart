import 'package:flutter/material.dart';
import 'op.dart';

typedef StringCallback = void Function(String);
typedef OPCallback = void Function(String, OP);

class OpTab extends StatelessWidget {
  const OpTab({
    Key? key,
    required this.op,
    required this.filePath,
    required this.onEdit,
    required this.onSend,
  }) : super(key: key);
  final OP op;
  final String filePath;
  final OPCallback onEdit;
  final OPCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height : 115,
        child : Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("hi",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize : 20,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 4, 3),
                    child: Text("ip : ${op.ip}:${op.port}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize : 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 4, 3),
                    child: Text("message : ${op.messageString}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize : 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            SizedBox(
              width : 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xffeaebef)),
                  onPressed: () => onEdit(filePath, op),
                ),
              ),
            ),
            SizedBox(
              width : 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.send_rounded, color: Color(0xffeaebef)),
                  onPressed: () => onSend(filePath, op),
                ),
              ),
            ),
            const SizedBox( width: 10 ),
          ],
        )
      );
  }
}
