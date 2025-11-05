import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'battle_royale_game.dart';

void main() {
  final game = BattleRoyaleGame();
  runApp(
    GestureDetector(
      // Handle drag to move the player
      onPanUpdate: (details) => game.handlePanUpdate(details.delta),
      // Handle tap to shoot
      onTapDown: (details) => game.handleTapDown(details.localPosition),
      child: GameWidget(game: game),
    ),
  );
}
