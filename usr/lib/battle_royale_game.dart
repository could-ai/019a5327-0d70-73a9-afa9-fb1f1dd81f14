import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

// Main game class for the battle royale prototype
typedef DragUpdateInfo = PanDragUpdateInfo;

typedef TapDownInfo = TapDownInfo; // reuse Flame's TapDetector info 

class BattleRoyaleGame extends FlameGame with PanDetector, TapDetector {
  late Player _player;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Initialize player at center of screen
    _player = Player()
      ..position = canvasSize / 2
      ..size = Vector2(50, 50)
      ..anchor = Anchor.center;
    add(_player);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    // Drag to move the player
    _player.position.add(info.delta.game);
  }

  @override
  void onTapDown(TapDownInfo info) {
    // Tap to shoot towards tap position
    _player.shoot(info.eventPosition.game);
  }
}

// Simple player component represented by a green square
class Player extends PositionComponent with HasGameRef<BattleRoyaleGame> {
  final Paint _paint = Paint()..color = const Color(0xFF00FF00);

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }

  void shoot(Vector2 target) {
    final bullet = Bullet(
      position: position.clone(),
      target: target,
    );
    gameRef.add(bullet);
  }
}

// Bullet component that moves from player towards tap location
class Bullet extends CircleComponent with HasGameRef<BattleRoyaleGame> {
  final Vector2 _direction;

  Bullet({required Vector2 position, required Vector2 target})
      : _direction = (target - position).normalized(),
        super(
          position: position,
          radius: 5,
          paint: Paint()..color = const Color(0xFFFF0000),
        );

  @override
  void update(double dt) {
    super.update(dt);
    // Move the bullet forward
    position.add(_direction * 200 * dt);
    // Remove the bullet when off-screen
    if (!gameRef.size.toRect().contains(position.toOffset())) {
      removeFromParent();
    }
  }
}