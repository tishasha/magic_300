import 'package:flutter/material.dart';
import 'zone_screen.dart';

class SavingLostIsland extends StatelessWidget {
  const SavingLostIsland({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background island image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/zone_background.png'),
                fit: BoxFit.cover,
                opacity: 0.8,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/image3.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.landscape,
                  size: 300,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          // Playful title
          const Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Text(
              '🌟 拯救失落之島 🌟',
              style: TextStyle(
                fontFamily: 'Rounded Mplus 1c',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    offset: Offset(2, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Zone buttons with solid background and frame
          Stack(
            children: [
              // Ice Island (Top-left)
              Positioned(
                top: 150,
                left: 50,
                child: _buildZoneButton(
                    '🧊',
                    '冰島',
                    () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const ZoneScreen(zoneName: '冰島'),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 500),
                          ),
                        ),
                    true),
              ),
              // Castle (Top-right)
              Positioned(
                top: 150,
                right: 50,
                child: _buildZoneButton(
                    '🏰',
                    '城堡',
                    () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const ZoneScreen(zoneName: '城堡'),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 500),
                          ),
                        ),
                    true),
              ),
              // Forest (Middle-left)
              Positioned(
                top: 300,
                left: 30,
                child: _buildZoneButton(
                    '🌳',
                    '森林',
                    () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const ZoneScreen(zoneName: '森林'),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 500),
                          ),
                        ),
                    true),
              ),
              // Business District (Middle-right)
              Positioned(
                top: 300,
                right: 30,
                child: _buildZoneButton(
                    '💼',
                    '商業區',
                    () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const ZoneScreen(zoneName: '商業區'),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 500),
                          ),
                        ),
                    true),
              ),
              // Village (Bottom-left)
              Positioned(
                bottom: 150,
                left: 50,
                child: _buildZoneButton('🏡', '村莊', null, false),
              ),
              // Grassland (Bottom-right)
              Positioned(
                bottom: 150,
                right: 50,
                child: _buildZoneButton('🌾', '草原', null, false),
              ),
              // Special Zone (Bottom-middle-left)
              Positioned(
                bottom: 50,
                left: 50, // Adjusted to avoid overlap
                child: _buildZoneButton('🌀', '特殊區', null, false),
              ),
              // City District (Bottom-middle-right)
              Positioned(
                bottom: 50,
                right: 50, // Adjusted to avoid overlap
                child: _buildZoneButton('🏙️', '城市區', null, false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZoneButton(
      String emoji, String name, VoidCallback? onPressed, bool isUnlocked) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isUnlocked
                ? Colors.pink[200]
                : Colors.blue[300], // Solid background
            border:
                Border.all(color: Colors.yellow, width: 5), // Prominent frame
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.yellow.withOpacity(0.8),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(15),
            backgroundColor:
                isUnlocked ? Colors.pink[200] : Colors.blue[300], // Solid color
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isUnlocked ? Icons.star : Icons.lock,
                color: isUnlocked ? Colors.blue : Colors.white,
                size: 30,
              ),
              const SizedBox(height: 8),
              Text(
                '$emoji $name',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Rounded Mplus 1c',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(2, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isUnlocked)
          Positioned(
            top: -8,
            right: -8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.star,
                color: Colors.blue,
                size: 18,
              ),
            ),
          ),
      ],
    );
  }
}
