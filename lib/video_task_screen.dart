import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'task_provider.dart';

class VideoTaskScreen extends StatefulWidget {
  final String zoneName;
  final String taskName;
  final int taskIndex;

  const VideoTaskScreen({
    super.key,
    required this.zoneName,
    required this.taskName,
    required this.taskIndex,
  });

  @override
  State<VideoTaskScreen> createState() => _VideoTaskScreenState();
}

class _VideoTaskScreenState extends State<VideoTaskScreen> {
  late VideoPlayerController _controller;
  bool _showChallengeButton = false;
  bool _hasNavigated = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    final videoNumber = _getVideoNumber(widget.zoneName, widget.taskIndex);
    final videoPath = 'assets/videos/video$videoNumber.mp4';
    print(
        'Loading $videoPath for ${widget.zoneName}, task ${widget.taskIndex}');

    _controller = VideoPlayerController.asset(videoPath);
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final videoNumber = _getVideoNumber(widget.zoneName, widget.taskIndex);
    final videoPath = 'assets/videos/video$videoNumber.mp4';
    try {
      await _controller.initialize();
      setState(() {
        _isInitialized = _controller.value.isInitialized;
      });
      print('Video initialized: ${_controller.value.isInitialized}');
      print('Duration: ${_controller.value.duration}');
      print('Position: ${_controller.value.position}');
      print('Aspect Ratio: ${_controller.value.aspectRatio}');
      if (_controller.value.isInitialized) {
        _controller.play();
        print('Playing $videoPath');
      } else {
        print('Failed to initialize video');
        setState(() {
          _showChallengeButton = true;
        });
      }
    } catch (error) {
      print('Error initializing video: $error');
      setState(() {
        _showChallengeButton = true;
      });
    }

    _controller.addListener(() {
      if (_controller.value.isInitialized && !_hasNavigated) {
        print(
            'Position: ${_controller.value.position}, Duration: ${_controller.value.duration}, IsPlaying: ${_controller.value.isPlaying}');
        if (!_controller.value.isPlaying &&
            _controller.value.position >= _controller.value.duration &&
            _controller.value.duration.inSeconds > 0) {
          print('Video finished');
          setState(() {
            _showChallengeButton = true;
          });
        }
      }
    });
  }

  int _getVideoNumber(String zone, int taskIndex) {
    const zoneOrder = ['冰島', '城堡', '森林', '商業區'];
    final zoneIndex = zoneOrder.indexOf(zone);
    return zoneIndex * 6 + taskIndex + 1; // video1.mp4 to video24.mp4
  }

  @override
  void dispose() {
    _controller.dispose();
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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Return button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              // Centered video player or buttons
              _showChallengeButton
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '影片播放完畢！✨',
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
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (!_hasNavigated) {
                              _hasNavigated = true;
                              print('Navigating to DragDropTaskScreen');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DragDropTaskScreen(
                                    zoneName: widget.zoneName,
                                    taskName: widget.taskName,
                                    taskIndex: widget.taskIndex,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            '接受挑戰',
                            style: TextStyle(
                              fontFamily: 'Rounded Mplus 1c',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    )
                  : _isInitialized
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.yellow, width: 5),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.yellow.withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _controller.seekTo(Duration.zero);
                                  _controller.play();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                '重新播放',
                                style: TextStyle(
                                  fontFamily: 'Rounded Mplus 1c',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const CircularProgressIndicator(
                          color: Colors.yellow,
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

class DragDropTaskScreen extends StatefulWidget {
  final String zoneName;
  final String taskName;
  final int taskIndex;

  const DragDropTaskScreen({
    super.key,
    required this.zoneName,
    required this.taskName,
    required this.taskIndex,
  });

  @override
  State<DragDropTaskScreen> createState() => _DragDropTaskScreenState();
}

class _DragDropTaskScreenState extends State<DragDropTaskScreen> {
  final Map<String, List<List<Map<String, dynamic>>>> _wordData = {
    '冰島': [
      [
        {
          'word': '蘋',
          'structure': '上下結構',
          'parts': ['艹', '頻']
        },
        {
          'word': '彩',
          'structure': '左右結構',
          'parts': ['采', '彡']
        },
        {
          'word': '衣',
          'structure': '獨體字',
          'parts': ['衣']
        },
        {
          'word': '服',
          'structure': '左右結構',
          'parts': ['月', '𠬝']
        },
        {
          'word': '大',
          'structure': '獨體字',
          'parts': ['大']
        },
        {
          'word': '象',
          'structure': '上下結構',
          'parts': ['⺈', '豕']
        },
      ],
      [
        {
          'word': '腿',
          'structure': '左右結構',
          'parts': ['月', '退']
        },
        {
          'word': '長',
          'structure': '獨體字',
          'parts': ['長']
        },
        {
          'word': '路',
          'structure': '左右結構',
          'parts': ['足', '各']
        },
        {
          'word': '花',
          'structure': '上下結構',
          'parts': ['艹', '化']
        },
        {
          'word': '雨',
          'structure': '獨體字',
          'parts': ['雨']
        },
      ],
      [
        {
          'word': '兔',
          'structure': '獨體字',
          'parts': ['兔']
        },
        {
          'word': '冰',
          'structure': '左右結構',
          'parts': ['冫', '水']
        },
        {
          'word': '冷',
          'structure': '左右結構',
          'parts': ['冫', '令']
        },
        {
          'word': '跳',
          'structure': '左右結構',
          'parts': ['足', '兆']
        },
        {
          'word': '舞',
          'structure': '上下結構',
          'parts': ['𠂉', '卌一舛']
        },
        {
          'word': '害',
          'structure': '上下結構',
          'parts': ['宀', '丰口']
        },
        {
          'word': '怕',
          'structure': '左右結構',
          'parts': ['忄', '白']
        },
      ],
      [
        {
          'word': '爸',
          'structure': '上下結構',
          'parts': ['父', '巴']
        },
        {
          'word': '關',
          'structure': '上下結構',
          'parts': ['門', '幺幺丱']
        },
        {
          'word': '上',
          'structure': '獨體字',
          'parts': ['上']
        },
        {
          'word': '水',
          'structure': '獨體字',
          'parts': ['水']
        },
        {
          'word': '果',
          'structure': '上下結構',
          'parts': ['田', '木']
        },
      ],
      [
        {
          'word': '魚',
          'structure': '上下結構',
          'parts': ['⺈田', '灬']
        },
        {
          'word': '告',
          'structure': '上下結構',
          'parts': ['牛', '口']
        },
        {
          'word': '訴',
          'structure': '左右結構',
          'parts': ['言', '斥']
        },
        {
          'word': '站',
          'structure': '左右結構',
          'parts': ['立', '占']
        },
        {
          'word': '立',
          'structure': '獨體字',
          'parts': ['立']
        },
        {
          'word': '父',
          'structure': '獨體字',
          'parts': ['父']
        },
        {
          'word': '母',
          'structure': '獨體字',
          'parts': ['母']
        },
      ],
      [
        {
          'word': '白',
          'structure': '獨體字',
          'parts': ['白']
        },
        {
          'word': '發',
          'structure': '上下結構',
          'parts': ['癶', '弓殳']
        },
        {
          'word': '現',
          'structure': '左右結構',
          'parts': ['王', '見']
        },
        {
          'word': '看',
          'structure': '上下結構',
          'parts': ['手', '目']
        },
        {
          'word': '見',
          'structure': '上下結構',
          'parts': ['目', '儿']
        },
        {
          'word': '游',
          'structure': '左右結構',
          'parts': ['氵', '斿']
        },
      ],
    ],
    '城堡': [
      [
        {
          'word': '孩',
          'structure': '左右結構',
          'parts': ['子', '亥']
        },
        {
          'word': '子',
          'structure': '獨體字',
          'parts': ['子']
        },
        {
          'word': '蛀',
          'structure': '上下結構',
          'parts': ['虫', '主']
        },
        {
          'word': '牙',
          'structure': '獨體字',
          'parts': ['牙']
        },
        {
          'word': '三',
          'structure': '獨體字',
          'parts': ['三']
        },
        {
          'word': '二',
          'structure': '獨體字',
          'parts': ['二']
        },
        {
          'word': '一',
          'structure': '獨體字',
          'parts': ['一']
        },
      ],
      [
        {
          'word': '黃',
          'structure': '上下結構',
          'parts': ['廿一', '由八']
        },
        {
          'word': '色',
          'structure': '上下結構',
          'parts': ['⺈', '巴']
        },
        {
          'word': '小',
          'structure': '獨體字',
          'parts': ['小']
        },
        {
          'word': '狗',
          'structure': '左右結構',
          'parts': ['犭', '句']
        },
        {
          'word': '自',
          'structure': '上下結構',
          'parts': ['丶', '目']
        },
        {
          'word': '信',
          'structure': '左右結構',
          'parts': ['亻', '言']
        },
      ],
      [
        {
          'word': '紅',
          'structure': '左右結構',
          'parts': ['糹', '工']
        },
        {
          'word': '白',
          'structure': '獨體字',
          'parts': ['白']
        },
        {
          'word': '藍',
          'structure': '上下結構',
          'parts': ['艹', '監']
        },
        {
          'word': '星',
          'structure': '上下結構',
          'parts': ['日', '生']
        },
        {
          'word': '公',
          'structure': '上下結構',
          'parts': ['八', '厶']
        },
        {
          'word': '正',
          'structure': '上下結構',
          'parts': ['一', '止']
        },
      ],
      [
        {
          'word': '一',
          'structure': '獨體字',
          'parts': ['一']
        },
        {
          'word': '條',
          'structure': '上下結構',
          'parts': ['木', '攸']
        },
        {
          'word': '飛',
          'structure': '獨體字',
          'parts': ['飛']
        },
        {
          'word': '天',
          'structure': '上下結構',
          'parts': ['一', '大']
        },
        {
          'word': '紫',
          'structure': '上下結構',
          'parts': ['此', '糸']
        },
        {
          'word': '菜',
          'structure': '上下結構',
          'parts': ['艹', '采']
        },
      ],
      [
        {
          'word': '時',
          'structure': '左右結構',
          'parts': ['日', '寺']
        },
        {
          'word': '鐘',
          'structure': '左右結構',
          'parts': ['金', '童']
        },
        {
          'word': '睡',
          'structure': '左右結構',
          'parts': ['目', '垂']
        },
        {
          'word': '覺',
          'structure': '上下結構',
          'parts': ['𦥯', '見']
        },
        {
          'word': '午',
          'structure': '獨體字',
          'parts': ['午']
        },
        {
          'word': '夜',
          'structure': '上下結構',
          'parts': ['亠亻夂', '丶']
        },
      ],
      [
        {
          'word': '火',
          'structure': '獨體字',
          'parts': ['火']
        },
        {
          'word': '生',
          'structure': '獨體字',
          'parts': ['生']
        },
        {
          'word': '氣',
          'structure': '上下結構',
          'parts': ['气', '米']
        },
        {
          'word': '很',
          'structure': '左右結構',
          'parts': ['彳', '艮']
        },
        {
          'word': '大',
          'structure': '獨體字',
          'parts': ['大']
        },
        {
          'word': '聲',
          'structure': '上下結構',
          'parts': ['殸', '耳']
        },
        {
          'word': '笑',
          'structure': '上下結構',
          'parts': ['𥫗', '夭']
        },
      ],
    ],
    '森林': [
      [
        {
          'word': '抱',
          'structure': '左右結構',
          'parts': ['扌', '包']
        },
        {
          'word': '送',
          'structure': '半包圍',
          'parts': ['辶', '关']
        },
        {
          'word': '禮',
          'structure': '左右結構',
          'parts': ['礻', '豊']
        },
        {
          'word': '物',
          'structure': '左右結構',
          'parts': ['牛', '勿']
        },
        {
          'word': '泥',
          'structure': '左右結構',
          'parts': ['氵', '尼']
        },
        {
          'word': '土',
          'structure': '獨體字',
          'parts': ['土']
        },
      ],
      [
        {
          'word': '長',
          'structure': '獨體字',
          'parts': ['長']
        },
        {
          'word': '短',
          'structure': '左右結構',
          'parts': ['矢', '豆']
        },
        {
          'word': '用',
          'structure': '獨體字',
          'parts': ['用']
        },
        {
          'word': '力',
          'structure': '獨體字',
          'parts': ['力']
        },
        {
          'word': '聽',
          'structure': '左右結構',
          'parts': ['耳', '𡈼㥁']
        },
        {
          'word': '音',
          'structure': '上下結構',
          'parts': ['立', '曰']
        },
      ],
      [
        {
          'word': '身',
          'structure': '獨體字',
          'parts': ['身']
        },
        {
          'word': '體',
          'structure': '左右結構',
          'parts': ['骨', '豊']
        },
        {
          'word': '眼',
          'structure': '左右結構',
          'parts': ['目', '艮']
        },
        {
          'word': '耳',
          'structure': '獨體字',
          'parts': ['耳']
        },
        {
          'word': '溫',
          'structure': '左右結構',
          'parts': ['氵', '𥁕']
        },
        {
          'word': '暖',
          'structure': '左右結構',
          'parts': ['日', '爰']
        },
      ],
      [
        {
          'word': '熊',
          'structure': '上下結構',
          'parts': ['能', '灬']
        },
        {
          'word': '貓',
          'structure': '左右結構',
          'parts': ['豸', '苗']
        },
        {
          'word': '船',
          'structure': '左右結構',
          'parts': ['舟', '八口']
        },
        {
          'word': '出',
          'structure': '上下結構',
          'parts': ['屮', '山']
        },
        {
          'word': '海',
          'structure': '左右結構',
          'parts': ['氵', '每']
        },
      ],
      [
        {
          'word': '想',
          'structure': '上下結構',
          'parts': ['木目', '心']
        },
        {
          'word': '要',
          'structure': '上下結構',
          'parts': ['覀', '女']
        },
        {
          'word': '食',
          'structure': '上下結構',
          'parts': ['亽', '艮']
        },
        {
          'word': '輕',
          'structure': '左右結構',
          'parts': ['車', '巠']
        },
        {
          'word': '重',
          'structure': '上下結構',
          'parts': ['千', '里']
        },
        {
          'word': '快',
          'structure': '左右結構',
          'parts': ['忄', '夬']
        },
        {
          'word': '慢',
          'structure': '左右結構',
          'parts': ['忄', '曼']
        },
      ],
      [
        {
          'word': '跑',
          'structure': '左右結構',
          'parts': ['足', '包']
        },
        {
          'word': '步',
          'structure': '上下結構',
          'parts': ['止', '少']
        },
        {
          'word': '可',
          'structure': '上下結構',
          'parts': ['丁', '口']
        },
        {
          'word': '以',
          'structure': '獨體字',
          'parts': ['以']
        },
        {
          'word': '鼻',
          'structure': '上下結構',
          'parts': ['自', '畀']
        },
        {
          'word': '行',
          'structure': '左右結構',
          'parts': ['彳', '亍']
        },
        {
          'word': '走',
          'structure': '上下結構',
          'parts': ['土', '龰']
        },
      ],
    ],
    '商業區': [
      [
        {
          'word': '石',
          'structure': '獨體字',
          'parts': ['石']
        },
        {
          'word': '頭',
          'structure': '左右結構',
          'parts': ['豆', '頁']
        },
        {
          'word': '毛',
          'structure': '獨體字',
          'parts': ['毛']
        },
        {
          'word': '髮',
          'structure': '左右結構',
          'parts': ['髟', '犮']
        },
        {
          'word': '綠',
          'structure': '左右結構',
          'parts': ['糹', '彔']
        },
        {
          'word': '橙',
          'structure': '左右結構',
          'parts': ['木', '登']
        },
      ],
      [
        {
          'word': '山',
          'structure': '獨體字',
          'parts': ['山']
        },
        {
          'word': '羊',
          'structure': '獨體字',
          'parts': ['羊']
        },
        {
          'word': '弟',
          'structure': '獨體字',
          'parts': ['弟']
        },
        {
          'word': '牛',
          'structure': '獨體字',
          'parts': ['牛']
        },
        {
          'word': '角',
          'structure': '獨體字',
          'parts': ['角']
        },
        {
          'word': '包',
          'structure': '半包圍',
          'parts': ['勹', '巳']
        },
      ],
      [
        {
          'word': '自',
          'structure': '上下結構',
          'parts': ['丶', '目']
        },
        {
          'word': '己',
          'structure': '獨體字',
          'parts': ['己']
        },
        {
          'word': '吃',
          'structure': '左右結構',
          'parts': ['口', '乞']
        },
        {
          'word': '十',
          'structure': '獨體字',
          'parts': ['十']
        },
        {
          'word': '種',
          'structure': '左右結構',
          'parts': ['禾', '重']
        },
        {
          'word': '森',
          'structure': '鼎足結構',
          'parts': ['木', '木木']
        },
        {
          'word': '林',
          'structure': '左右結構',
          'parts': ['木', '木']
        },
      ],
      [
        {
          'word': '店',
          'structure': '半包圍',
          'parts': ['广', '占']
        },
        {
          'word': '真',
          'structure': '上下結構',
          'parts': ['十目', '八']
        },
        {
          'word': '美',
          'structure': '上下結構',
          'parts': ['羊', '大']
        },
        {
          'word': '麗',
          'structure': '上下結構',
          'parts': ['丽', '鹿']
        },
        {
          'word': '奇',
          'structure': '上下結構',
          'parts': ['大', '可']
        },
        {
          'word': '怪',
          'structure': '左右結構',
          'parts': ['忄', '圣']
        },
        {
          'word': '錢',
          'structure': '左右結構',
          'parts': ['金', '戔']
        },
      ],
      [
        {
          'word': '媽',
          'structure': '左右結構',
          'parts': ['女', '馬']
        },
        {
          'word': '哥',
          'structure': '上下結構',
          'parts': ['可', '可']
        },
        {
          'word': '姐',
          'structure': '左右結構',
          'parts': ['女', '且']
        },
        {
          'word': '妹',
          'structure': '左右結構',
          'parts': ['女', '未']
        },
        {
          'word': '校',
          'structure': '左右結構',
          'parts': ['木', '交']
        },
        {
          'word': '班',
          'structure': '左右結構',
          'parts': ['王𬼀', '王']
        },
        {
          'word': '別',
          'structure': '左右結構',
          'parts': ['另', '刂']
        },
      ],
      [
        {
          'word': '愛',
          'structure': '上下結構',
          'parts': ['爫冖', '心夊']
        },
        {
          'word': '雞',
          'structure': '左右結構',
          'parts': ['隹', '奚']
        },
        {
          'word': '豬',
          'structure': '左右結構',
          'parts': ['豕', '者']
        },
        {
          'word': '幫',
          'structure': '上下結構',
          'parts': ['封', '帛']
        },
        {
          'word': '忙',
          'structure': '左右結構',
          'parts': ['忄', '亡']
        },
        {
          'word': '問',
          'structure': '內外結構',
          'parts': ['門', '口']
        },
        {
          'word': '話',
          'structure': '左右結構',
          'parts': ['言', '舌']
        },
      ],
    ],
  };

  int _currentWordIndex = 0;
  Map<String, String?> _currentAnswers = {};

  @override
  void initState() {
    super.initState();
    _initializeAnswers();
  }

  void _initializeAnswers() {
    final currentWordData =
        _wordData[widget.zoneName]![widget.taskIndex][_currentWordIndex];
    _currentAnswers = {
      for (var part in (currentWordData['parts'] as List<dynamic>)) part: null,
    };
  }

  void _checkAnswer(BuildContext context) {
    final currentWordData =
        _wordData[widget.zoneName]![widget.taskIndex][_currentWordIndex];
    final expectedParts = currentWordData['parts'] as List<dynamic>;
    bool isCorrect =
        expectedParts.every((part) => _currentAnswers[part] == part);

    if (isCorrect) {
      if (_currentWordIndex <
          _wordData[widget.zoneName]![widget.taskIndex].length - 1) {
        setState(() {
          _currentWordIndex++;
          _initializeAnswers();
        });
      } else {
        Provider.of<TaskProvider>(context, listen: false)
            .completeTask(widget.zoneName, widget.taskIndex);
        Navigator.pop(context); // Return to ZoneScreen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWordData =
        _wordData[widget.zoneName]![widget.taskIndex][_currentWordIndex];
    final word = currentWordData['word'] as String;
    final structure = currentWordData['structure'] as String;
    final parts = currentWordData['parts'] as List<dynamic>;

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
                          '${widget.taskName} - 拼湊字：$word',
                          style: const TextStyle(
                            fontFamily: 'Rounded Mplus 1c',
                            fontSize: 24,
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
                    ),
                    const SizedBox(width: 40), // Spacer for symmetry
                  ],
                ),
              ),
              // Drag-and-drop game
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        '結構：$structure',
                        style: const TextStyle(
                          fontFamily: 'Rounded Mplus 1c',
                          fontSize: 20,
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
                      const SizedBox(height: 20),
                      if (structure.contains('上下') || structure.contains('內外'))
                        Column(
                          children: parts.map((part) {
                            return DragTarget<String>(
                              onAcceptWithDetails: (details) {
                                setState(() {
                                  _currentAnswers[part] = details.data;
                                });
                                _checkAnswer(context);
                              },
                              builder: (context, candidateData, rejectedData) {
                                final isCorrect = _currentAnswers[part] == part;
                                return Container(
                                  width: 100,
                                  height: 100,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isCorrect
                                        ? Colors.green[100]
                                        : Colors.yellow[100],
                                    border: Border.all(
                                        color: Colors.yellow, width: 3),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _currentAnswers[part] ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Rounded Mplus 1c',
                                        fontSize: 40,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        )
                      else if (structure.contains('左右') ||
                          structure.contains('半包圍'))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: parts.map((part) {
                            return DragTarget<String>(
                              onAcceptWithDetails: (details) {
                                setState(() {
                                  _currentAnswers[part] = details.data;
                                });
                                _checkAnswer(context);
                              },
                              builder: (context, candidateData, rejectedData) {
                                final isCorrect = _currentAnswers[part] == part;
                                return Container(
                                  width: 100,
                                  height: 100,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isCorrect
                                        ? Colors.green[100]
                                        : Colors.yellow[100],
                                    border: Border.all(
                                        color: Colors.yellow, width: 3),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _currentAnswers[part] ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Rounded Mplus 1c',
                                        fontSize: 40,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        )
                      else if (structure.contains('鼎足'))
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: parts.map((part) {
                            return DragTarget<String>(
                              onAcceptWithDetails: (details) {
                                setState(() {
                                  _currentAnswers[part] = details.data;
                                });
                                _checkAnswer(context);
                              },
                              builder: (context, candidateData, rejectedData) {
                                final isCorrect = _currentAnswers[part] == part;
                                return Container(
                                  width: 100,
                                  height: 100,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isCorrect
                                        ? Colors.green[100]
                                        : Colors.yellow[100],
                                    border: Border.all(
                                        color: Colors.yellow, width: 3),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _currentAnswers[part] ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Rounded Mplus 1c',
                                        fontSize: 40,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        )
                      else // 獨體字
                        DragTarget<String>(
                          onAcceptWithDetails: (details) {
                            setState(() {
                              _currentAnswers[parts[0]] = details.data;
                            });
                            _checkAnswer(context);
                          },
                          builder: (context, candidateData, rejectedData) {
                            final isCorrect =
                                _currentAnswers[parts[0]] == parts[0];
                            return Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isCorrect
                                    ? Colors.green[100]
                                    : Colors.yellow[100],
                                border:
                                    Border.all(color: Colors.yellow, width: 3),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  _currentAnswers[parts[0]] ?? '',
                                  style: const TextStyle(
                                    fontFamily: 'Rounded Mplus 1c',
                                    fontSize: 40,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: parts.map((part) {
                          return Draggable<String>(
                            data: part,
                            feedback: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                border:
                                    Border.all(color: Colors.yellow, width: 3),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  part,
                                  style: const TextStyle(
                                    fontFamily: 'Rounded Mplus 1c',
                                    fontSize: 40,
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                border:
                                    Border.all(color: Colors.yellow, width: 3),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  part,
                                  style: const TextStyle(
                                    fontFamily: 'Rounded Mplus 1c',
                                    fontSize: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],
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
