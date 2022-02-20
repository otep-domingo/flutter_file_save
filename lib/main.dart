// @dart=2.9
// main.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local text file',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _data = "";
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Text file'),
        ),
        body: Column(
          children: [
            Row(
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      _writeData();
                    },
                    child: Text('Save')),
                ElevatedButton(
                    onPressed: () {
                      _loadData();
                    },
                    child: Text('Read File')),
              ],
            ),
            const Text("Enter text and click Save button"),
            TextField(
              controller: _textController,
            ),
            const Text("Click the Read button to display text file"),
            Container(
              width: 400,
              color: Colors.amber,
              height: 400,
              child: Text(_data ?? 'Nothing to show'),

            ),
          ],
        ));
  }

  //setup all the methods here
  Future<void> _loadData() async {
    if (kIsWeb) {
      final _loadData = await rootBundle.loadString('assets/data.txt');
      setState(() {
        _data = _loadData;
      });
    } else {
      final _dirPath = await _getDirPath;
      final _myFile = File('$_dirPath/data.txt');
      final _loadedData = await _myFile.readAsString(
          encoding: utf8); //await rootBundle.loadString('assets/data.txt');
      setState(() {
        _data = _loadedData;
      });
    }
  }

  Future<String> get _getDirPath async {
    String _dir = "";
    if (kIsWeb) {
      _dir = await rootBundle.loadString('assets/data.txt');
    } else {
      _dir = (await getApplicationDocumentsDirectory()).path;
    }
    return _dir;
  }

  Future<void> _writeData() async {
    final _dirPath = await _getDirPath;
    final _myFile = File('$_dirPath/data.txt');
    await _myFile.writeAsString(_textController.text);
    _textController.clear();
  }
}
