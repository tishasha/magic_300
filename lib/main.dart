import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splash_screen.dart';
import 'task_provider.dart';

void main() {
  runApp(const Magic300App());
}

class Magic300App extends StatelessWidget {
  const Magic300App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        title: '奇幻字島 300',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily: 'NotoSansTC',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
