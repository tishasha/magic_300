import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'success_screen.dart';

class AudioTaskScreen extends StatefulWidget {
  const AudioTaskScreen({super.key});

  @override
  State<AudioTaskScreen> createState() => _AudioTaskScreenState();
}

class _AudioTaskScreenState extends State<AudioTaskScreen>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _player;
  bool _isCorrect = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isLoading = true; // Add loading state
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initializeAudio();

    // Initialize animation controller for button scaling
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeAudio() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });
    try {
      print('Attempting to load audio from: assets/audio/spell_sound.m4a');
      await _player.setAsset('assets/audio/spell_sound.m4a');
      print('Audio asset set successfully');
      print('Playing audio');
      await _player.play();
      print('Audio playback started');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Detailed audio error: $e');
      setState(() {
        _hasError = true;
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void _checkAnswer(String spell) {
    if (_isLoading) return; // Prevent interaction while loading
    if (spell == 'sparkle') {
      setState(() => _isCorrect = true);
      _animationController.forward().then((_) {
        // Navigate to SuccessScreen after animation
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const SuccessScreen(),
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
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '試試再聽一次！',
            style: TextStyle(fontFamily: 'Rounded Mplus 1c', fontSize: 16),
          ),
          backgroundColor: Colors.pinkAccent,
        ),
      );
      _initializeAudio();
    }
  }

  @override
  void dispose() {
    print('Disposing audio player');
    _player.stop();
    _player.dispose();
    _animationController.dispose();
    super.dispose();
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
            // Animated background bubbles
            Positioned(
              top: 30,
              left: 10,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + _animationController.value * 0.2,
                    child: child,
                  );
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 10,
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
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: Center(
                child: _isCorrect
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: const Text(
                              '魔法聽對了！✨',
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
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '考考你的聆聽能力, 你聽到什麼聲音？✨',
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
                          if (_isLoading)
                            const CircularProgressIndicator(
                              color: Colors.yellow,
                            ),
                          if (_hasError) ...[
                            const Text(
                              '無法播放音檔，請稍後再試',
                              style: TextStyle(
                                fontFamily: 'Rounded Mplus 1c',
                                fontSize: 18,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _errorMessage,
                              style: const TextStyle(
                                fontFamily: 'Rounded Mplus 1c',
                                fontSize: 14,
                                color: Colors.redAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () => _checkAnswer('sparkle'),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.7),
                                    border: Border.all(
                                      color: Colors.yellow,
                                      width: 3,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/images/sparkle.png',
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
                              ),
                              GestureDetector(
                                onTap: () => _checkAnswer('rainbow'),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.7),
                                    border: Border.all(
                                      color: Colors.pink,
                                      width: 3,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/images/rainbow.png',
                                    width: 80,
                                    height: 80,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.wb_iridescent,
                                      size: 80,
                                      color: Colors.pink,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _checkAnswer('bubble'),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.7),
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 3,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/images/bubble.png',
                                    width: 80,
                                    height: 80,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.bubble_chart,
                                      size: 80,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _initializeAudio,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                '再聽一次',
                                style: TextStyle(
                                  fontFamily: 'Rounded Mplus 1c',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
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
