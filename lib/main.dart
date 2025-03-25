import 'package:flutter/material.dart';
import 'package:student_app/chatbot.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent, // Transparent for gradient
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple[100], // Pastel purple AppBar
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color.fromARGB(255, 214, 165, 175), // Pastel pink FAB
          elevation: 5, // Soft shadow
        ),
        cardTheme: CardTheme(
          color: const Color.fromARGB(255, 198, 221, 240), // Pastel blue for cards
          elevation: 4, // Soft shadow
          margin: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color.fromARGB(255, 131, 169, 201), // Pastel blue for bottom nav
          selectedItemColor: const Color.fromARGB(255, 215, 162, 224),
          unselectedItemColor: const Color.fromARGB(255, 5, 70, 97),
        ),
      ),
      home: GradientBackground(child: MainScreen()),
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue[50]!,
            Colors.purple[50]!,
            Colors.green[50]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomeScreen(),
    UnitTestPage(),
    RecordingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Positioned(
            right: 16,
            bottom: 70, // Positioned above the navigation bar
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatPage()),
                );
              },
              child: const Icon(Icons.chat),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: "Tests"),
          BottomNavigationBarItem(icon: Icon(Icons.video_library), label: "Recordings"),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  bool showCalendar = false;

  void _pickDate(BuildContext context) {
    setState(() {
      showCalendar = !showCalendar;
    });
  }

  void _setTomorrowSchedule() {
    setState(() {
      selectedDate = DateTime.now().add(Duration(days: 1));
      showCalendar = false;
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("Hi Student!"), elevation: 0),
    body: SingleChildScrollView(
      child: Column(
        children: [
          // Streaks & Badges
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStreakCard(
                  title: "Attendance Streak",
                  icon: Icons.local_fire_department, // 🔥
                  gradientColors: [Colors.orange[200]!, Colors.orange[400]!],
                  streakValue: "🔥 10 Days",
                ),
                _buildStreakCard(
                  title: "Test Streak",
                  icon: Icons.edit_note, // 📝
                  gradientColors: [Colors.blue[200]!, Colors.blue[400]!],
                  streakValue: "📝 5 Tests",
                ),
                _buildStreakCard(
                  title: "Achievements",
                  icon: Icons.celebration, // 🎉
                  gradientColors: [Colors.purple[200]!, Colors.purple[400]!],
                  streakValue: "🎉 3 Badges",
                ),
              ],
            ),
          ),

          // Date Selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dateButton("Today", selectedDate.day == DateTime.now().day, () {
                  setState(() {
                    selectedDate = DateTime.now();
                    showCalendar = false;
                  });
                }),
                _dateButton("Tomorrow", selectedDate.day == DateTime.now().add(Duration(days: 1)).day, _setTomorrowSchedule),
                _dateButton("Date", false, () => _pickDate(context)),
              ],
            ),
          ),

          // Calendar
          if (showCalendar)
            Container(
              height: 350, // Prevents overflow
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView( // Fixes overflow issue
                child: TableCalendar(
                  focusedDay: selectedDate,
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  calendarFormat: CalendarFormat.month,
                  onDaySelected: (selected, focused) {
                    setState(() {
                      selectedDate = selected;
                      showCalendar = false;
                    });
                  },
                ),
              ),
            ),

          // Schedule
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: _getScheduleForDate(selectedDate),
            ),
          ),
        ],
      ),
    ),
  );
}
  // Streak Box
// Replace _buildStreakBox with this:
Widget _buildStreakCard({
  required String title,
  required IconData icon,
  required List<Color> gradientColors,
  required String streakValue,
}) {
  return GestureDetector(
    onTap: () {
      // Optional: Add functionality for tapping the card
    },
    child: Container(
      width: 110,
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          SizedBox(height: 8),
          Text(
            streakValue,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildStreakCardWithAnimation({
  required String title,
  required IconData icon,
  required List<Color> gradientColors,
  required String streakValue,
  required bool isAchieved,
}) {
  return AnimatedScale(
    scale: isAchieved ? 1.1 : 1.0, // Slightly enlarge when achieved
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    child: _buildStreakCard(
      title: title,
      icon: icon,
      gradientColors: gradientColors,
      streakValue: streakValue,
    ),
  );
}
  // Date Button
  Widget _dateButton(String text, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.blue[200] : const Color.fromARGB(255, 235, 217, 217),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  // Schedule Functionality
  List<Widget> _getScheduleForDate(DateTime date) {
    // Simulated schedules for different days
    Map<String, List<Map<String, String>>> schedules = {
      "today": [
        {"subject": "Mathematics", "time": "10:00 AM - 11:00 AM"},
        {"subject": "Physics", "time": "11:15 AM - 12:15 PM"},
        {"subject": "Chemistry", "time": "12:30 PM - 1:30 PM"},
      ],
      "tomorrow": [
        {"subject": "English", "time": "9:00 AM - 10:00 AM"},
        {"subject": "Biology", "time": "11:00 AM - 12:00 PM"},
      ],
      "other": [
        {"subject": "History", "time": "8:00 AM - 9:00 AM"},
        {"subject": "Geography", "time": "10:00 AM - 11:00 AM"},
      ]
    };

    String key = date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day
        ? "today"
        : date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().add(Duration(days: 1)).day
            ? "tomorrow"
            : "other";

    return schedules[key]!.map((classInfo) {
      return Card(
        child: ListTile(
          title: Text(classInfo["subject"]!),
          subtitle: Text(classInfo["time"]!),
          leading: Icon(Icons.book, color: const Color.fromARGB(255, 143, 198, 243)),
        ),
      );
    }).toList();
  }
}

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> todayRecordings = [
    {"subject": "Math", "chapter": "Algebra", "duration": "45 min", "progress": "0.8"},
    {"subject": "Physics", "chapter": "Kinematics", "duration": "30 min", "progress": "0.5"},
    {
      "subject": "Tutorial",
      "chapter": "How to Slap Your Brother",
      "duration": "10 min",
      "progress": "1.0",
      "videoPath": "assets/videos/Tutorial.mp4",
    }
  ];

  final List<Map<String, String>> yesterdayRecordings = [
    {"subject": "Chemistry", "chapter": "Organic", "duration": "50 min", "progress": "1.0"},
  ];

  final List<Map<String, String>> dateWiseRecordings = [
    {"subject": "Biology", "chapter": "Cells", "duration": "40 min", "progress": "0.6"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildRecordingCard(BuildContext context, Map<String, String> recording) {
    print('Video path is $todayRecordings');
    return Card(
      child: ListTile(
        title: Text("${recording["subject"]!} - ${recording["chapter"]!}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Duration: ${recording["duration"]!}"),
            LinearProgressIndicator(
              value: double.parse(recording["progress"]!),
              backgroundColor: const Color.fromARGB(255, 150, 221, 242),
              color: Colors.red,
            ),
          ],
        ),
        leading: Icon(Icons.video_collection, color: Colors.blue),
        onTap: () {
          if (recording.containsKey("videoPath")) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(videoPath: recording["videoPath"]!),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recordings"),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Today"),
            Tab(text: "Yesterday"),
            Tab(text: "Other Dates"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView(children: todayRecordings.map((r) => _buildRecordingCard(context, r)).toList()),
          ListView(children: yesterdayRecordings.map((r) => _buildRecordingCard(context, r)).toList()),
          ListView(children: dateWiseRecordings.map((r) => _buildRecordingCard(context, r)).toList()),
        ],
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;

  const VideoPlayerScreen({super.key, required this.videoPath});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    print('Initializing video player with path: ${widget.videoPath}');
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        print('Error initializing video player: $error');
        setState(() {
          _isError = true;
          _errorMessage = error.toString();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Player")),
      body: Center(
        child: _isError
            ? Text("Error loading video: $_errorMessage")
            : _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(),
      ),
      floatingActionButton: _isError
          ? null
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying ? _controller.pause() : _controller.play();
                });
              },
              child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
            ),
    );
  }
}
class TestModel {
  final String subject;
  final String chapter;
  final String question;
  final String answer;
  final DateTime date;

  TestModel({
    required this.subject,
    required this.chapter,
    required this.question,
    required this.answer,
    required this.date,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'chapter': chapter,
      'question': question,
      'answer': answer,
      'date': date.toIso8601String(),
    };
  }

  // Create from Map
  factory TestModel.fromMap(Map<String, dynamic> map) {
    return TestModel(
      subject: map['subject'],
      chapter: map['chapter'],
      question: map['question'],
      answer: map['answer'],
      date: DateTime.parse(map['date']),
    );
  }
}

// ✅ Main Page for Unit Tests
class UnitTestPage extends StatefulWidget {
  @override
  _UnitTestPageState createState() => _UnitTestPageState();
  
}

class _UnitTestPageState extends State<UnitTestPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data structure for subjects, tests, and questions
  final Map<String, Map<String, List<TestModel>>> subjects = {
  "Math": {
    "Algebra Test": [
      TestModel(
        subject: 'Math',
        chapter: 'Algebra',
        question: 'Solve for x: 2x + 3 = 7',
        answer: '2',
        date: DateTime.now(),
      ),
      TestModel(
        subject: 'Math',
        chapter: 'Algebra',
        question: 'What is the square root of 16?',
        answer: '4',
        date: DateTime.now(),
      ),
      TestModel(
        subject: 'Math',
        chapter: 'Algebra',
        question: 'Simplify: 3x + 2x',
        answer: '5x',
        date: DateTime.now(),
      ),
      TestModel(
        subject: 'Math',
        chapter: 'Algebra',
        question: 'What is the value of x in 5x = 25?',
        answer: '5',
        date: DateTime.now(),
      ),
      TestModel(
        subject: 'Math',
        chapter: 'Algebra',
        question: 'Expand: (x + 2)(x - 3)',
        answer: 'x^2 - x - 6',
        date: DateTime.now(),
      ),
    ],
    "Geometry Test": [
      TestModel(
        subject: 'Math',
        chapter: 'Geometry',
        question: 'What is the sum of angles in a triangle?',
        answer: '180 degrees',
        date: DateTime.now(),
      ),
      TestModel(
        subject: 'Math',
        chapter: 'Geometry',
        question: 'What is the area of a circle with radius 7?',
        answer: '154 square units',
        date: DateTime.now(),
      ),
      TestModel(
        subject: 'Math',
        chapter: 'Geometry',
        question: 'What is the perimeter of a square with side length 5?',
        answer: '20 units',
        date: DateTime.now(),
      ),
      TestModel(
        subject: 'Math',
        chapter: 'Geometry',
        question: 'What is the length of the hypotenuse of a right triangle with legs 3 and 4?',
        answer: '5',
        date: DateTime.now(),
      ),
      TestModel(
        subject: 'Math',
        chapter: 'Geometry',
        question: 'What is the volume of a cube with side length 3?',
        answer: '27 cubic units',
        date: DateTime.now(),
      ),
    ],
  },
  "Science": {
    "Physics Test": [
      TestModel(
        subject: 'Science',
        chapter: 'Physics',
        question: 'What is the speed of light?',
        answer: '299,792 km/s',
        date: DateTime.now(),
      ),
      TestModel(
        subject: 'Science',
        chapter: 'Physics',
        question: 'What is Newton\'s second law of motion?',
        answer: 'F = ma',
        date: DateTime.now(),
      ),
      TestModel(
        subject: 'Science',
        chapter: 'Physics',
        question: 'What is the unit of force?',
        answer: 'Newton',
        date: DateTime.now(),
      ),
      TestModel(
        subject: 'Science',
        chapter: 'Physics',
        question: 'What is the acceleration due to gravity on Earth?',
        answer: '9.8 m/s^2',
        date: DateTime.now(),
      ),
      TestModel(
        subject: 'Science',
        chapter: 'Physics',
        question: 'What is the formula for kinetic energy?',
        answer: 'KE = 1/2 mv^2',
        date: DateTime.now(),
      ),
    ],
    "Biology Test": [
      TestModel(
        subject: 'Science',
        chapter: 'Biology',
        question: 'What is the powerhouse of the cell?',
        answer: 'Mitochondria',
        date: DateTime.now(),
      ),
      TestModel(
        subject: 'Science',
        chapter: 'Biology',
        question: 'What is the basic unit of life?',
        answer: 'Cell',
        date: DateTime.now(),
      ),
      TestModel(
        subject: 'Science',
        chapter: 'Biology',
        question: 'What is the process by which plants make food?',
        answer: 'Photosynthesis',
        date: DateTime.now(),
      ),
      TestModel(
        subject: 'Science',
        chapter: 'Biology',
        question: 'What is the genetic material in cells?',
        answer: 'DNA',
        date: DateTime.now(),
      ),
      TestModel(
        subject: 'Science',
        chapter: 'Biology',
        question: 'What is the function of red blood cells?',
        answer: 'Transport oxygen',
        date: DateTime.now(),
      ),
    ],
  },
};

final Map<String, bool> testCompletionStatus = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: subjects.keys.length, vsync: this);

    
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Tests'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: subjects.keys.map((subject) => Tab(text: subject)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: subjects.entries.map((entry) {
          final subjectName = entry.key;
          final tests = entry.value;
          return ListView(
            children: tests.entries.map((testEntry) {
              final testName = testEntry.key;
              final questions = testEntry.value;
              return _buildTestCard(subjectName, testName, questions);
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTestCard(String subjectName, String testName, List<TestModel> questions) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text(testName),
        children: questions.map((question) => _buildQuestionTile(question)).toList(),
      ),
    );
  }

  Widget _buildQuestionTile(TestModel question) {
    return ListTile(
      title: Text(question.question),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestDetailPage(test: question),
          ),
        );
      },
    );
  }
}
class TestDetailPage extends StatelessWidget {
  final TestModel test;

  TestDetailPage({required this.test});

  @override
  Widget build(BuildContext context) {
    TextEditingController _answerController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text(test.chapter)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              test.question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                labelText: 'Your Answer',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String userAnswer = _answerController.text.trim();
                String result = userAnswer == test.answer
                    ? 'Correct ✅'
                    : 'Incorrect ❌';

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result),
                  ),
                );
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body:  Center(
        child:  ChatbotApp(),
        // Text(
        //   'Chatbot coming soon',
        //   style: TextStyle(fontSize: 24),
        // ),
      ),
    );
  }
}

