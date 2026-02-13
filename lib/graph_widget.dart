import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class GraphWidget extends StatelessWidget {
  final List<String> equations;
  final double scale;
  final Offset offset;

  const GraphWidget({
    super.key,
    required this.equations,
    this.scale = 40.0,
    this.offset = Offset.zero,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRect(
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _FunctionPainter(equations, scale, offset),
          ),
        );
      },
    );
  }
}

class _FunctionPainter extends CustomPainter {
  final List<String> equations;
  final double scale;
  final Offset offset;

  _FunctionPainter(this.equations, this.scale, this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    final paintAxis = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    final paintGraph = Paint()
      ..color = Colors.purpleAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final centerX = size.width / 2 + offset.dx;
    final centerY = size.height / 2 + offset.dy;
    int minX = ((-centerX) / scale).floor();
    int maxX = ((size.width - centerX) / scale).ceil();
    
    int maxY = ((centerY) / scale).ceil();
    int minY = ((centerY - size.height) / scale).floor();

    for (int i = minX; i <= maxX; i++) {
      double xPos = centerX + i * scale;
      
      canvas.drawLine(Offset(xPos, 0), Offset(xPos, size.height), paintGrid);

      if (i != 0) {
        drawText(canvas, '$i', Offset(xPos - 5, centerY + 5));
      }
    }

    for (int i = minY; i <= maxY; i++) {
      double yPos = centerY - i * scale;

      canvas.drawLine(Offset(0, yPos), Offset(size.width, yPos), paintGrid);

      if (i != 0) {
        drawText(canvas, '$i', Offset(centerX + 8, yPos - 10));
      }
    }

    canvas.drawLine(Offset(centerX, 0), Offset(centerX, size.height), paintAxis); // Eje Y
    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), paintAxis); // Eje X
    
    drawText(canvas, "0", Offset(centerX - 15, centerY + 5));

    for (String eqString in equations) {
      if (eqString.isEmpty) continue;
      
      try {
        Parser p = Parser();
        Expression exp = p.parse(eqString);
        ContextModel cm = ContextModel();

        Path path = Path();
        bool firstPoint = true;

        for (double xPixel = 0; xPixel <= size.width; xPixel += 1) {
          double xMath = (xPixel - centerX) / scale;
          cm.bindVariable(Variable('x'), Number(xMath));
          
          double yMath = exp.evaluate(EvaluationType.REAL, cm);
          double yPixel = centerY - (yMath * scale);

          if (yPixel.isFinite) {
            if (firstPoint) {
              path.moveTo(xPixel, yPixel);
              firstPoint = false;
            } else {
              double prevXMath = (xPixel - 1 - centerX) / scale;
              cm.bindVariable(Variable('x'), Number(prevXMath));
              double prevY = centerY - (exp.evaluate(EvaluationType.REAL, cm) * scale);
              
              if ((yPixel - prevY).abs() < size.height / 2) { 
                 path.lineTo(xPixel, yPixel);
              } else {
                 path.moveTo(xPixel, yPixel);
              }
            }
          }
        }
        canvas.drawPath(path, paintGraph);
      } catch (e) {
      }
    }
  }

  void drawText(Canvas canvas, String text, Offset pos) {
    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(color: Colors.black, fontSize: 12),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: 100);
    textPainter.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}