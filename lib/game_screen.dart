import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static List<int> snakePosition = [50, 65, 80, 95, 110];
  int numberOfSquares = 300;
  static var randomNumber = Random();
  int food = randomNumber.nextInt(300);

  generateNewFood() => food = randomNumber.nextInt(300);

  void _startGame() {
    snakePosition = [50, 65, 80, 95, 110];
    const duration = Duration(milliseconds: 300);
    Timer.periodic(duration, (timer) {
      updateSnake();
      if (gameOver()) {
        timer.cancel();
        _showGameOverScreen();
      }
    });
  }

  var direction = 'down';

  void updateSnake() {
    setState(() {
      switch (direction) {
        case 'down':
          if (snakePosition.last > 285) {
            snakePosition.add(snakePosition.last + 15 - 300);
          } else {
            snakePosition.add(snakePosition.last + 15);
          }
          break;

        case 'up':
          if (snakePosition.last < 15) {
            snakePosition.add(snakePosition.last - 15 + 300);
          } else {
            snakePosition.add(snakePosition.last - 15);
          }
          break;

        case 'left':
          if (snakePosition.last % 15 == 0) {
            snakePosition.add(snakePosition.last - 1 + 15);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;

        case 'right':
          if ((snakePosition.last + 1) % 15 == 0) {
            snakePosition.add(snakePosition.last + 1 - 15);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;
        default:
      }

      if (snakePosition.last == food) {
        generateNewFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  bool gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count += 1;
        }
        if (count == 2) {
          return true;
        }
      }
    }
    return false;
  }

  void _showGameOverScreen() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('GAME OVER'),
          content: Text('Score:${snakePosition.length}'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _startGame();
              },
              child: const Text('Play Again!'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (direction != 'up' && details.delta.dy > 0) {
                    direction = 'down';
                  } else if (direction != 'down' && details.delta.dy < 0) {
                    direction = 'up';
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (direction != 'left' && details.delta.dx > 0) {
                    direction = 'right';
                  } else if (direction != 'right' && details.delta.dx < 0) {
                    direction = 'left';
                  }
                },
                child: Container(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 15),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (snakePosition.contains(index)) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(color: Colors.black),
                          ),
                          padding: const EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: ColoredBox(
                              color: snakePosition.last == index ? Colors.black : Colors.black26,
                            ),
                          ),
                        );
                      }
                      if (index == food) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(color: Colors.red),
                          ),
                          padding: const EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: const ColoredBox(color: Colors.red),
                          ),
                        );
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(color: Colors.green.withOpacity(0.5)),
                          ),
                          padding: const EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: ColoredBox(
                              color: Colors.green.withOpacity(0.7),
                            ),
                          ),
                        );
                      }
                    },
                    itemCount: numberOfSquares,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: _startGame,
              child: const Text('Start'),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
