import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'video_task_screen.dart';

class ZoneScreen extends StatelessWidget {
  final String zoneName;

  const ZoneScreen({super.key, required this.zoneName});

  static const Map<String, List<String>> _zoneTasks = {
    '冰島': [
      '世界慶典大冒險',
      '大地的孩子',
      '冰上遇險',
      '合力搶救冰淇淋',
      '一個像海的地方',
      '我的朋友—白海豚',
    ],
    '城堡': [
      '蛀牙王子',
      '我自信所以我漂亮',
      '我是美國女總統',
      '忍者飯團',
      '時鐘國王',
      '為什麼我不能噴火',
    ],
    '森林': [
      '刺蝟先生的擁抱',
      '鱷魚愛上長頸鹿',
      '熊貓澡堂',
      '拜托 熊貓先生',
      '河馬媽媽分鬆餅',
      '比一比 誰最長',
    ],
    '商業區': [
      '超神奇糖果舖',
      '牛角包生氣了',
      '麵包小偷',
      '印度豹大拍賣',
      '馬鈴薯家族',
      '請投狼柏高一票',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final tasks = _zoneTasks[zoneName] ?? [];
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Return button and title
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          zoneName,
                          style: const TextStyle(
                            fontFamily: 'Rounded Mplus 1c',
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
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
                    ),
                    const SizedBox(width: 40), // Spacer for symmetry
                  ],
                ),
              ),
              // Grid of tasks
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: tasks.asMap().entries.map((entry) {
                      final index = entry.key;
                      final taskName = entry.value;
                      final isCompleted =
                          taskProvider.isTaskCompleted(zoneName, index);

                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoTaskScreen(
                                    zoneName: zoneName,
                                    taskName: taskName,
                                    taskIndex: index,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(10),
                              backgroundColor: isCompleted
                                  ? Colors.pink[100] // Pink for completed
                                  : Colors.blue[100], // Blue for incomplete
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                    color: Colors.yellow, width: 3),
                              ),
                              elevation: 5,
                              shadowColor: Colors.yellow.withOpacity(0.5),
                            ),
                            child: Text(
                              taskName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Rounded Mplus 1c',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
                          if (isCompleted)
                            Positioned(
                              top: -5,
                              right: -5,
                              child: Container(
                                padding: const EdgeInsets.all(8),
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
                                child: const Text(
                                  '✨',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
