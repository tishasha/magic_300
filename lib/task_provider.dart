import 'package:flutter/material.dart';

class TaskProvider with ChangeNotifier {
  final Map<String, Set<int>> _completedTasks = {
    '冰島': {},
    '城堡': {},
    '森林': {},
    '商業區': {},
  };

  final Map<String, Map<int, List<String>>> _taskWords = {
    '冰島': {
      0: ['蘋', '彩', '衣', '服', '大', '象'],
      1: ['腿', '長', '路', '花', '雨'],
      2: ['兔', '冰', '冷', '跳', '舞', '害', '怕'],
      3: ['爸', '關', '上', '水', '果'],
      4: ['魚', '告', '訴', '站', '立', '父', '母'],
      5: ['白', '發', '現', '看', '見', '游'],
    },
    '城堡': {
      0: ['孩', '子', '蛀', '牙', '三', '二', '一'],
      1: ['黃', '色', '小', '狗', '自', '信'],
      2: ['紅', '白', '藍', '星', '公', '正'],
      3: ['一', '條', '飛', '天', '紫', '菜'],
      4: ['時', '鐘', '睡', '覺', '午', '夜'],
      5: ['火', '生', '氣', '很', '大', '聲', '笑'],
    },
    '森林': {
      0: ['抱', '送', '禮', '物', '泥', '土'],
      1: ['長', '短', '用', '力', '聽', '音'],
      2: ['身', '體', '眼', '耳', '溫', '暖'],
      3: ['熊', '貓', '船', '出', '海'],
      4: ['想', '要', '食', '輕', '重', '快', '慢'],
      5: ['跑', '步', '可', '以', '鼻', '行', '走'],
    },
    '商業區': {
      0: ['石', '頭', '毛', '髮', '綠', '橙'],
      1: ['山', '羊', '弟', '牛', '角', '包'],
      2: ['自', '己', '吃', '十', '種', '森', '林'],
      3: ['店', '真', '美', '麗', '奇', '怪', '錢'],
      4: ['媽', '哥', '姐', '妹', '校', '班', '別'],
      5: ['愛', '雞', '豬', '幫', '忙', '問', '話'],
    },
  };

  bool isTaskCompleted(String zone, int taskIndex) {
    return _completedTasks[zone]?.contains(taskIndex) ?? false;
  }

  void completeTask(String zone, int taskIndex) {
    _completedTasks[zone]?.add(taskIndex);
    notifyListeners();
  }

  int getCompletedTaskCount() {
    return _completedTasks.values.fold(0, (sum, set) => sum + set.length);
  }

  int getTotalTaskCount() {
    return 24;
  }

  int getCompletedWordCount() {
    int wordCount = 0;
    for (var zone in _completedTasks.keys) {
      for (var taskIndex in _completedTasks[zone]!) {
        wordCount += _taskWords[zone]?[taskIndex]?.length ?? 0;
      }
    }
    return wordCount;
  }

  List<String> getWordsForTask(String zone, int taskIndex) {
    return _taskWords[zone]?[taskIndex] ?? [];
  }
}
