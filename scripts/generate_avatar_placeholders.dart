import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart' as path;

// This is a standalone script to generate placeholder avatar images
// It can be run with: dart scripts/generate_avatar_placeholders.dart

void main() async {
  final avatars = [
    'noah', 'moses', 'david', 'daniel', 'esther', 'ruth', 
    'abraham', 'joshua', 'solomon', 'samson', 'deborah', 'miriam'
  ];
  
  final colors = {
    'noah': Colors.blue,
    'moses': Colors.red,
    'david': Colors.purple,
    'daniel': Colors.amber,
    'esther': Colors.pink,
    'ruth': Colors.green,
    'abraham': Colors.brown,
    'joshua': Colors.orange,
    'solomon': Colors.indigo,
    'samson': Colors.deepOrange,
    'deborah': Colors.teal,
    'miriam': Colors.cyan,
  };
  
  final outputDir = path.join('assets', 'images', 'avatars');
  
  // Create directory if it doesn't exist
  final directory = Directory(outputDir);
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
  
  // Generate each avatar
  for (final avatar in avatars) {
    final pngBytes = await _generateAvatar(
      name: avatar,
      color: colors[avatar] ?? Colors.grey,
      size: 200,
    );
    
    final file = File(path.join(outputDir, '$avatar.png'));
    await file.writeAsBytes(pngBytes);
    print('Generated placeholder for $avatar');
  }
  
  print('All placeholders generated!');
}

Future<Uint8List> _generateAvatar({
  required String name,
  required Color color,
  required double size,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  
  // Draw background circle
  final paint = Paint()
    ..color = color.withOpacity(0.3)
    ..style = PaintingStyle.fill;
  
  canvas.drawCircle(Offset(size / 2, size / 2), size / 2, paint);
  
  // Draw border
  final borderPaint = Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4;
  
  canvas.drawCircle(Offset(size / 2, size / 2), size / 2 - 2, borderPaint);
  
  // Draw initials
  final textStyle = TextStyle(
    color: color,
    fontSize: size / 3,
    fontWeight: FontWeight.bold,
  );
  
  final textSpan = TextSpan(
    text: name.substring(0, 1).toUpperCase(),
    style: textStyle,
  );
  
  final textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
  );
  
  textPainter.layout();
  
  final xCenter = (size - textPainter.width) / 2;
  final yCenter = (size - textPainter.height) / 2;
  textPainter.paint(canvas, Offset(xCenter, yCenter));
  
  // Convert to image
  final picture = recorder.endRecording();
  final img = await picture.toImage(size.toInt(), size.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  
  return byteData!.buffer.asUint8List();
} 