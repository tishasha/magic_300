import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'main_navigation.dart';

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final _nameController = TextEditingController();
  bool _isNameEntered = false;
  final List<Offset?> _points = [];
  Uint8List? _drawingData;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<Uint8List> _captureDrawing() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 150, 150));
    final painter = DrawingPainter(_points);
    painter.paint(canvas, const Size(150, 150));
    final picture = recorder.endRecording();
    final image = await picture.toImage(150, 150);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/image2.png',
                    width: 200,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.landscape,
                      size: 200,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '太棒了！你已擁有兩項超級能力，可以成為拯救失落之島的超人或超級女孩了！',
                    style: TextStyle(
                      fontFamily: 'Rounded Mplus 1c',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '畫一個屬於你的魔法圖標！✨',
                    style: TextStyle(
                      fontFamily: 'Rounded Mplus 1c',
                      fontSize: 18,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      border: Border.all(color: Colors.yellow, width: 3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GestureDetector(
                      onPanStart: (details) {
                        setState(() {
                          _points.add(details.localPosition);
                        });
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          _points.add(details.localPosition);
                        });
                      },
                      onPanEnd: (details) {
                        setState(() {
                          _points.add(null);
                        });
                      },
                      child: CustomPaint(
                        painter: DrawingPainter(_points),
                        child: const Center(
                          child: Text(
                            '畫這裡！',
                            style: TextStyle(
                              fontFamily: 'Rounded Mplus 1c',
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '輸入你的魔法英雄名稱',
                    style: TextStyle(
                      fontFamily: 'Rounded Mplus 1c',
                      fontSize: 18,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.yellow),
                      ),
                      hintText: '你的英雄名稱',
                      hintStyle: const TextStyle(
                        fontFamily: 'Rounded Mplus 1c',
                        color: Colors.blue,
                      ),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Rounded Mplus 1c',
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                    onChanged: (value) {
                      setState(() => _isNameEntered = value.isNotEmpty);
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isNameEntered
                        ? () async {
                            _drawingData = await _captureDrawing();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainNavigation(
                                  superheroName: _nameController.text,
                                  drawingData: _drawingData,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      '開始冒險！',
                      style: TextStyle(
                        fontFamily: 'Rounded Mplus 1c',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
