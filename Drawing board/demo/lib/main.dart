import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DrawingApp(),
  ));
}

class DrawingApp extends StatefulWidget {
  const DrawingApp({super.key});

  @override
  State<DrawingApp> createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  @override
  void initState() {
    super.initState();
    _controller = DrawingController();
  }

  late DrawingController _controller;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(155, 247, 164, 40),
        centerTitle: true,
        title: const Text(
          "Doodle",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: DrawingBoard(
        controller: _controller,
        background: Container(
          color: const Color.fromARGB(255, 248, 238, 220),
          height: 600,
          width: 600,
        ),
        showDefaultActions: true,
        showDefaultTools: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: saveDrawing,
        backgroundColor: const Color.fromARGB(255, 240, 84, 28),
        child: const Icon(Icons.save_alt, color: Colors.white),
      ),
    );
  }

  Future<void> saveDrawing() async {
    try {
      final imageData = await _controller.getImageData();
      if (imageData == null) {
        print("No Image to Save");
        return;
      }
      String path;
      final directory = Directory("/storage/emulated/0/Download");
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      path = "${directory.path}/drawings.png";
      final file = File(path);
      await file.writeAsBytes(imageData.buffer.asInt8List());
    } catch (error) {
      print("Error saving drawing $error");
    }
  }
}