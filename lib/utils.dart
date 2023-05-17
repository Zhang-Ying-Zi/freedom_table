import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef OnWidgetSizeChange = void Function(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child!.size;
    // if (oldSize == newSize) return;

    oldSize = newSize;

    // print("newSize $newSize");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }

  @override
  void updateRenderObject(BuildContext context, covariant MeasureSizeRenderObject renderObject) {
    renderObject.onChange = onChange;
  }
}

class WidgetPosition {
  static getSizes(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size;
    // print("SIZE: $size");
    return [size?.width, size?.height];
  }

  static getPositions(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);
    // print("POSITION: $position ");
    return [position?.dx, position?.dy];
  }
}

Widget outline(Widget child) {
  return Container(decoration: BoxDecoration(border: Border.all()), child: child);
}

class CustomGradient extends CustomPainter {
  CustomGradient({
    required this.gradient,
    required this.strokeWidth,
  });

  final Gradient gradient;
  final double strokeWidth;

  final Paint p = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    // print(size);
    // Rect innerRect = Rect.fromLTRB(strokeWidth, strokeWidth, size.width - strokeWidth, size.height - strokeWidth);
    // Rect outerRect = Offset.zero & size;

    Rect innerRect = Rect.fromLTRB(size.width, 0, size.width, size.height);
    Rect outerRect = Rect.fromLTRB(size.width, 0, size.width + strokeWidth, size.height);

    p.shader = gradient.createShader(outerRect);
    Path borderPath = _calculateBorderPath(outerRect, innerRect);
    // print(borderPath.getBounds());
    canvas.drawPath(borderPath, p);
  }

  Path _calculateBorderPath(Rect outerRect, Rect innerRect) {
    Path outerRectPath = Path()..addRect(outerRect);
    Path innerRectPath = Path()..addRect(innerRect);
    return Path.combine(PathOperation.difference, outerRectPath, innerRectPath);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CustomGradientContainer extends StatelessWidget {
  CustomGradientContainer({
    super.key,
    gradient = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: [0, 1],
      colors: [
        Color.fromRGBO(0, 0, 0, 0.2),
        Color.fromRGBO(0, 0, 0, 0),
      ],
    ),
    required this.child,
    this.strokeWidth = 5,
    this.onPressed,
  }) : painter = CustomGradient(gradient: gradient, strokeWidth: strokeWidth);

  final CustomGradient painter;
  final Widget child;
  final VoidCallback? onPressed;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: painter, child: child);
  }
}
