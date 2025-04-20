import 'package:flutter/material.dart';
import 'audio_task_screen.dart';
import 'dart:async';

class MagicalWandScreen extends StatefulWidget {
  const MagicalWandScreen({super.key});

  @override
  State<MagicalWandScreen> createState() => _MagicalWandScreenState();
}

class _MagicalWandScreenState extends State<MagicalWandScreen>
    with SingleTickerProviderStateMixin {
  String? _starPart;
  String? _stickPart;
  bool _isCompleted = false;
  late AnimationController _animationController;
  late Animation<double> _sparkleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for sparkle effect
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _sparkleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    if (_starPart == 'star' && _stickPart == 'stick') {
      setState(() => _isCompleted = true);
      _animationController.repeat(); // Start sparkle animation
      // Navigate to AudioTaskScreen after 2 seconds with a fade transition
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const AudioTaskScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        }
      });
    }
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
        child: Stack(
          children: [
            // Background animated bubbles
            Positioned(
              top: 50,
              left: 20,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + _animationController.value * 0.2,
                    child: child,
                  );
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              right: 20,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + _animationController.value * 0.2,
                    child: child,
                  );
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: Center(
                child: _isCompleted
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Completed wand
                              Column(
                                children: [
                                  Image.asset(
                                    'assets/images/wand_star.png',
                                    width: 100,
                                    height: 100,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.star,
                                      size: 100,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/wand_stick.png',
                                    width: 60,
                                    height: 120,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.straighten,
                                      size: 120,
                                      color: Colors.pink,
                                    ),
                                  ),
                                ],
                              ),
                              // Sparkle effect
                              AnimatedBuilder(
                                animation: _sparkleAnimation,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _sparkleAnimation.value,
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.yellow.withOpacity(0.5),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '魔法棒完成！✨',
                            style: TextStyle(
                              fontFamily: 'Rounded Mplus 1c',
                              fontSize: 28,
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
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '小朋友我們先來練習合併動作!幫我打造魔法棒吧！✨',
                            style: TextStyle(
                              fontFamily: 'Rounded Mplus 1c',
                              fontSize: 28,
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
                          ),
                          const SizedBox(height: 40),
                          // Drag targets for wand parts
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DragTarget<String>(
                                onAcceptWithDetails: (details) {
                                  setState(() => _starPart = details.data);
                                  _checkAnswer();
                                },
                                builder:
                                    (context, candidateData, rejectedData) {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.7),
                                      border: Border.all(
                                        color: Colors.yellow,
                                        width: 3,
                                      ),
                                    ),
                                    child: Center(
                                      child: _starPart == 'star'
                                          ? Image.asset(
                                              'assets/images/wand_star.png',
                                              width: 80,
                                              height: 80,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(
                                                Icons.star,
                                                size: 80,
                                                color: Colors.yellow,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.star_border,
                                              size: 50,
                                              color: Colors.yellow,
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DragTarget<String>(
                                onAcceptWithDetails: (details) {
                                  setState(() => _stickPart = details.data);
                                  _checkAnswer();
                                },
                                builder:
                                    (context, candidateData, rejectedData) {
                                  return Container(
                                    width: 60,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white.withOpacity(0.7),
                                      border: Border.all(
                                        color: Colors.pink,
                                        width: 3,
                                      ),
                                    ),
                                    child: Center(
                                      child: _stickPart == 'stick'
                                          ? Image.asset(
                                              'assets/images/wand_stick.png',
                                              width: 40,
                                              height: 100,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(
                                                Icons.straighten,
                                                size: 100,
                                                color: Colors.pink,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.straighten,
                                              size: 40,
                                              color: Colors.pink,
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          // Draggable wand parts
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Draggable<String>(
                                data: 'star',
                                feedback: Material(
                                  elevation: 5,
                                  child: Image.asset(
                                    'assets/images/wand_star.png',
                                    width: 80,
                                    height: 80,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.star,
                                      size: 80,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                ),
                                childWhenDragging: const SizedBox(
                                  width: 80,
                                  height: 80,
                                ),
                                child: Image.asset(
                                  'assets/images/wand_star.png',
                                  width: 80,
                                  height: 80,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                    Icons.star,
                                    size: 80,
                                    color: Colors.yellow,
                                  ),
                                ),
                              ),
                              Draggable<String>(
                                data: 'stick',
                                feedback: Material(
                                  elevation: 5,
                                  child: Image.asset(
                                    'assets/images/wand_stick.png',
                                    width: 40,
                                    height: 100,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.straighten,
                                      size: 100,
                                      color: Colors.pink,
                                    ),
                                  ),
                                ),
                                childWhenDragging: const SizedBox(
                                  width: 40,
                                  height: 100,
                                ),
                                child: Image.asset(
                                  'assets/images/wand_stick.png',
                                  width: 40,
                                  height: 100,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                    Icons.straighten,
                                    size: 100,
                                    color: Colors.pink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
