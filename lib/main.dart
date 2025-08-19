import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Triangle Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          accentColor: Colors.blueAccent,
        ),
        useMaterial3: true,
      ),
      home: const TriangleCalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TriangleCalculatorPage extends StatefulWidget {
  const TriangleCalculatorPage({super.key});

  @override
  State<TriangleCalculatorPage> createState() => _TriangleCalculatorPageState();
}

class _TriangleCalculatorPageState extends State<TriangleCalculatorPage> {
  late final TextEditingController _sideAController;
  late final TextEditingController _sideBController;
  late final TextEditingController _sideCController;

  String _areaResult = "0.0";
  String _perimeterResult = "0.0";
  String _heightResult = "0.0";

  double? _calculatedSideA;
  double? _calculatedSideB;
  double? _calculatedSideC;
  double? _calculatedHeight;

  @override
  void initState() {
    super.initState();
    _sideAController = TextEditingController();
    _sideBController = TextEditingController();
    _sideCController = TextEditingController();

    _sideAController.addListener(_calculateTriangleProperties);
    _sideBController.addListener(_calculateTriangleProperties);
    _sideCController.addListener(_calculateTriangleProperties);

    _calculateTriangleProperties(); // Initial calculation
  }

  @override
  void dispose() {
    _sideAController.removeListener(_calculateTriangleProperties);
    _sideBController.removeListener(_calculateTriangleProperties);
    _sideCController.removeListener(_calculateTriangleProperties);
    _sideAController.dispose();
    _sideBController.dispose();
    _sideCController.dispose();
    super.dispose();
  }

  void _calculateTriangleProperties() {
    setState(() {
      final double? sideA = double.tryParse(_sideAController.text);
      final double? sideB = double.tryParse(_sideBController.text);
      final double? sideC = double.tryParse(_sideCController.text);

      if (sideA == null || sideB == null || sideC == null) {
        _perimeterResult = "A, B, C";
        _areaResult = "ป้อนค่าด้าน A, B, C";
        _heightResult = "ค่า A, B, C";
        _calculatedSideA = null;
        _calculatedSideB = null;
        _calculatedSideC = null;
        _calculatedHeight = null;
        return;
      }

      if (sideA <= 0 || sideB <= 0 || sideC <= 0) {
        _perimeterResult = "ด้านต้องเป็นบวก";
        _areaResult = "ด้านต้องเป็นบวก";
        _heightResult = "ด้านต้องเป็นบวก";
        _calculatedSideA = null;
        _calculatedSideB = null;
        _calculatedSideC = null;
        _calculatedHeight = null;
        return;
      }

      // Triangle inequality theorem
      if (!((sideA + sideB > sideC) && (sideA + sideC > sideB) && (sideB + sideC > sideA))) {
        _perimeterResult = "ไม่สามารถสร้างสามเหลี่ยมได้";
        _areaResult = "ไม่สามารถสร้างสามเหลี่ยมได้";
        _heightResult = "ไม่สามารถสร้างสามเหลี่ยมได้";
        _calculatedSideA = null;
        _calculatedSideB = null;
        _calculatedSideC = null;
        _calculatedHeight = null;
        return;
      }


      _calculatedSideA = sideA;
      _calculatedSideB = sideB;
      _calculatedSideC = sideC;

      // Calculate Perimeter
      _perimeterResult = (sideA + sideB + sideC).toStringAsFixed(2);

      // Calculate Area using Heron's formula
      final double s = (sideA + sideB + sideC) / 2;
      final double area = sqrt(max(0.0, s * (s - sideA) * (s - sideB) * (s - sideC)));
      _areaResult = area.toStringAsFixed(2);


      if (sideA > 0) {
        _calculatedHeight = (2 * area) / sideA;
        _heightResult = _calculatedHeight!.toStringAsFixed(2);
      } else {

        _calculatedHeight = null;
        _heightResult = "ไม่สามารถคำนวณความสูง";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "พื้นที่สามเหลี่ยม",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Removed the "ตัวอย่างสามเหลี่ยม:" text and its SizedBox.
            Center(
              child: CustomPaint(
                size: const Size(250, 200),
                painter: TrianglePainter(
                  sideA: _calculatedSideA,
                  sideB: _calculatedSideB,
                  sideC: _calculatedSideC,
                  height: _calculatedHeight,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _sideAController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'ด้าน A',
                      hintText: 'ระยะ A',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _sideBController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'ด้าน B',
                      hintText: 'ระยะ B',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _sideCController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'ด้าน C',
                      hintText: 'ระยะ C',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _calculateTriangleProperties,
              icon: const Icon(Icons.calculate),
              label: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Text(
                  "คำนวณ",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "ผลลัพธ์:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "พื้นที่สามเหลี่ยม: $_areaResult",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "เส้นรอบรูป: $_perimeterResult",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "ความสูง (h) จากฐาน A: $_heightResult",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final double? sideA;
  final double? sideB;
  final double? sideC;
  final double? height;

  TrianglePainter({
    this.sideA,
    this.sideB,
    this.sideC,
    this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint dashedPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;


    Offset finalVertexA;
    Offset finalVertexB;
    Offset finalVertexC;
    Offset footOfAltitude;
    String labelA = "A";
    String labelB = "B";
    String labelC = "C";
    String labelH = "h";


    final bool hasValidInput = sideA != null &&
        sideB != null &&
        sideC != null &&
        height != null &&
        sideA! > 0 &&
        sideB! > 0 &&
        sideC! > 0;

    if (hasValidInput) {
      final double a = sideA!;
      final double b = sideB!;
      final double c = sideC!;
      final double hActual = height!;


      final double cxForC = (c * c + a * a - b * b) / (2 * a);

      
      final Offset vertexARel = Offset(0.0, hActual);
      final Offset vertexBRel = Offset(a, hActual);
      final Offset vertexCRel = Offset(cxForC, 0.0);


      final double minXRel = min(vertexARel.dx, min(vertexBRel.dx, vertexCRel.dx));
      final double maxXRel = max(vertexARel.dx, max(vertexBRel.dx, vertexCRel.dx));
      final double minYRel = min(vertexARel.dy, min(vertexBRel.dy, vertexCRel.dy));
      final double maxYRel = max(vertexARel.dy, max(vertexBRel.dy, vertexCRel.dy));

      final double triangleWidthRel = maxXRel - minXRel;
      final double triangleHeightRel = maxYRel - minYRel;

      // Add some padding to the canvas size for the triangle
      const double paddingFactor = 0.15; // 15% padding from each side of the canvas
      final double displayWidth = size.width * (1.0 - 2 * paddingFactor);
      final double displayHeight = size.height * (1.0 - 2 * paddingFactor);

      double scaleFactor = 1.0;
      if (triangleWidthRel > 0 && triangleHeightRel > 0) {
        scaleFactor = min(displayWidth / triangleWidthRel, displayHeight / triangleHeightRel);
      } else if (triangleWidthRel > 0) {
        scaleFactor = displayWidth / triangleWidthRel;
      } else if (triangleHeightRel > 0) {
        scaleFactor = displayHeight / triangleHeightRel;
      }

      // Limit scale factor to avoid extremely tiny or huge drawings
      scaleFactor = min(scaleFactor, 100.0); // Max reasonable scale
      scaleFactor = max(scaleFactor, 0.1); // Min reasonable scale

      // Calculate actual coordinates on the canvas
      final double scaledMinX = minXRel * scaleFactor;
      final double scaledMinY = minYRel * scaleFactor;


      final double translateX = (size.width - (maxXRel * scaleFactor - scaledMinX)) / 2 - scaledMinX;
      final double translateY = size.height * paddingFactor - scaledMinY; // Position apex at top padding

      finalVertexA = vertexARel * scaleFactor + Offset(translateX, translateY);
      finalVertexB = vertexBRel * scaleFactor + Offset(translateX, translateY);
      finalVertexC = vertexCRel * scaleFactor + Offset(translateX, translateY);

   
      footOfAltitude = Offset(finalVertexC.dx, finalVertexA.dy);


      labelA = "A: ${a.toStringAsFixed(2)}";
      labelB = "B: ${b.toStringAsFixed(2)}";
      labelC = "C: ${c.toStringAsFixed(2)}";
      labelH = "h: ${hActual.toStringAsFixed(2)}";
    } else {

      finalVertexA = Offset(size.width * 0.1, size.height * 0.9);
      finalVertexB = Offset(size.width * 0.9, size.height * 0.9);
      finalVertexC = Offset(size.width * 0.5, size.height * 0.1);
      footOfAltitude = Offset(finalVertexC.dx, finalVertexA.dy);
    }

    // Draw the triangle lines
    canvas.drawLine(finalVertexA, finalVertexB, paint);
    canvas.drawLine(finalVertexB, finalVertexC, paint);
    canvas.drawLine(finalVertexC, finalVertexA, paint);


    _drawDashedLine(canvas, finalVertexC, footOfAltitude, dashedPaint);

    // Draw right angle symbol
    final double angleSize = 10;

    final Path anglePath = Path();
    if (footOfAltitude.dx < finalVertexC.dx) {

      anglePath
        ..moveTo(footOfAltitude.dx, footOfAltitude.dy)
        ..lineTo(footOfAltitude.dx, footOfAltitude.dy - angleSize)
        ..lineTo(footOfAltitude.dx + angleSize, footOfAltitude.dy - angleSize)
        ..lineTo(footOfAltitude.dx + angleSize, footOfAltitude.dy)
        ..close();
    } else {

      anglePath
        ..moveTo(footOfAltitude.dx, footOfAltitude.dy)
        ..lineTo(footOfAltitude.dx, footOfAltitude.dy - angleSize)
        ..lineTo(footOfAltitude.dx - angleSize, footOfAltitude.dy - angleSize)
        ..lineTo(footOfAltitude.dx - angleSize, footOfAltitude.dy)
        ..close();
    }
    canvas.drawPath(anglePath, paint);

    // Labeling
    _drawText(
      canvas,
      labelA,
      (finalVertexA + finalVertexB) / 2 + const Offset(0, 10),
      Colors.black,
    );
    _drawText(
      canvas,
      labelB,
      (finalVertexB + finalVertexC) / 2 + const Offset(10, 0),
      Colors.black,
    );
    _drawText(
      canvas,
      labelC,
      (finalVertexC + finalVertexA) / 2 + const Offset(-10, 0),
      Colors.black,
    );

    _drawText(
      canvas,
      labelH,
      (finalVertexC + footOfAltitude) / 2 + const Offset(-10, 20), // Increased Y-offset to move it further down
      Colors.black,
    );
  }

  void _drawText(Canvas canvas, String text, Offset position, Color color) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, position - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const double dashLength = 5.0;
    const double gapLength = 3.0;
    final double distance = (p2 - p1).distance;
    final double dx = p2.dx - p1.dx;
    final double dy = p2.dy - p1.dy;

    double currentDistance = 0.0;
    while (currentDistance < distance) {
      final double startFraction = currentDistance / distance;
      double endFraction = (currentDistance + dashLength) / distance;

      if (endFraction > 1.0) {
        endFraction = 1.0;
      }

      final Offset pStart = Offset(p1.dx + dx * startFraction, p1.dy + dy * startFraction);
      final Offset pEnd = Offset(p1.dx + dx * endFraction, p1.dy + dy * endFraction);

      canvas.drawLine(pStart, pEnd, paint);

      currentDistance += dashLength + gapLength;
    }
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) {
    return oldDelegate.sideA != sideA ||
        oldDelegate.sideB != sideB ||
        oldDelegate.sideC != sideC ||
        oldDelegate.height != height;
  }
}