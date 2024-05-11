import 'package:flutter/material.dart';

import 'game_screen.dart';

void main() {
  runApp(const SnakeGame());
}

class SnakeGame extends StatelessWidget {
  const SnakeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Snake Game',
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}
