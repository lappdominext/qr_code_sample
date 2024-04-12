import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RenderQRCodePage extends StatefulWidget {
  const RenderQRCodePage({super.key});

  @override
  State<RenderQRCodePage> createState() => _RenderQRCodePageState();
}

class _RenderQRCodePageState extends State<RenderQRCodePage> {
  final GlobalKey _qrKey = GlobalKey();
  String data = 'https://www.google.com';
  final inputDataController = TextEditingController();
  dynamic externalDir = '/storage/emulated/0/Download/Qr_code';
  bool dirExists = false;

  @override
  void initState() {
    inputDataController.text = 'https://www.google.com';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _saveImageQR() async {
    try {
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);

      //Drawing White Background
      final whitePaint = Paint()..color = Colors.white;
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      //Check iOS
      if (Platform.isIOS) {
        Directory path = await getApplicationDocumentsDirectory();
        externalDir = path.path;
      }

      //Check for duplicate file name
      String fileName = 'qr_code';
      int i = 1;
      while (await File('$externalDir/$fileName.png').exists()) {
        fileName = 'qr_code_$i';
        i++;
      }

      // Check if Directory Path exists or not
      dirExists = await File(externalDir).exists();

      // if Directory Path doesn't exist --> create
      if (!dirExists) {
        await Directory(externalDir).create(recursive: true);
        dirExists = true;
      }

      final file = await File('$externalDir/$fileName.png').create();
      await file.writeAsBytes(pngBytes);

      if (!mounted) return;
      const snackBar = SnackBar(content: Text('Saved to gallery'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Render QR Code Page'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: TextFormField(
                controller: inputDataController,
                decoration: InputDecoration(
                  labelText: 'Input Data',
                  prefixIcon: Icon(
                    Icons.document_scanner_outlined,
                    color: Colors.deepPurple.shade300,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple.shade300),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  labelStyle: const TextStyle(color: Colors.deepPurple),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (inputDataController.text == '') {
                  const snackBar = SnackBar(content: Text('Empty Input!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                if (inputDataController.text == data) {
                  const snackBar = SnackBar(content: Text('Duplicate Value!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                setState(() {
                  data = inputDataController.text;
                });
              },
              child: const Text('Create a QR Code'),
            ),
            const SizedBox(height: 12),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Input:'),
                  const SizedBox(width: 4),
                  Text(
                    data,
                    style: const TextStyle(color: Colors.black45),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            RepaintBoundary(
              key: _qrKey,
              child: QrImageView(
                data: data,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saveImageQR,
              child: const Text('Save Code'),
            ),
          ],
        ),
      ),
    );
  }
}
