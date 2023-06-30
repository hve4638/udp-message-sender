import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wol_flutter/Loading.dart';
import 'global.dart';
import 'op.dart';
import 'op_edit_page.dart';
import 'op_sender.dart';
import 'oplist_page.dart';
import 'color_palette.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OPSender',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Loading(
        onLoadPage: const HomePage(
          title: 'OPSender'
        ),
        loadingPage: Container(
            color : Palette.background
        ),
        loadFailPage: Container(),
        load: () async {
          await Global.init();
          await OPFile.loadManageFile();

          return true;
        },
      )
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                var filename = OPFile.generateFilename();
                OPFile.addManageFile(filename);
                OPFile.saveManageFile();

                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => OpEditPage(
                        filePath: filename, initOP: OP(),
                    )
                ));
              },
              icon: const Icon(Icons.add, color: Colors.white),
          )
        ],
        backgroundColor: Palette.background,
      ),
      backgroundColor: Palette.background,
      body: const OpListPage(),
    );
  }
}
