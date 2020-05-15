/*
https://github.com/CarGuo/gsy_flutter_demo/tree/master/lib/widget/particle
*/
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:impossiblocks/models/particles.dart';
import 'package:simple_animations/simple_animations.dart';

class Fireworks extends StatefulWidget {
  final int numberOfParticles;
  final int cicles;

  Fireworks(this.numberOfParticles, this.cicles);

  @override
  _FireworksState createState() => _FireworksState();
}

class _FireworksState extends State<Fireworks> {
  final Random random = Random();

  final List<ParticleModel> particles = [];

  @override
  void initState() {
    List.generate(widget.numberOfParticles, (index) {
      particles.add(ParticleModel(random, widget.cicles));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Rendering(
      builder: (context, time) {
        _simulateParticles(time);
        return CustomPaint(
          painter: FireworksPainter(particles, time),
        );
      },
    );
  }

  _simulateParticles(Duration time) {
    particles.forEach((particle) => particle.maintainRestart(time));
  }
}

class FireworksPainter extends CustomPainter {
  List<ParticleModel> particles;
  Duration time;

  FireworksPainter(this.particles, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    particles.forEach((particle) {
      final paint = Paint()..color = particle.color;
      var progress = particle.animationProgress.progress(time);
      final animation = particle.tween.transform(progress);
      final position =
          Offset(animation["x"] * size.width, animation["y"] * size.height);

      double tileSize = particle.size;

      canvas.save();
      canvas.translate(position.dx - (tileSize / 2), position.dy - (tileSize / 2));
      canvas.rotate(animation["rotate"] * pi / 180);

      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(0, 0, tileSize, tileSize),
              Radius.circular(tileSize / 6)),
          paint);
      canvas.restore();
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
