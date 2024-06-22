import 'package:admin_pc_part/Login/Login.dart';
import 'package:admin_pc_part/Welcome-intro/FirstScreen%20.dart';
import 'package:admin_pc_part/Welcome-intro/SecondScreen%20.dart';
import 'package:admin_pc_part/Welcome-intro/ThirdScreen%20.dart';
import 'package:flutter/material.dart';
import 'Welcome-intro/page_indicator_row.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Part ',
      theme: ThemeData(),
      home: const MyHomePage(title: 'intro'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    bool hasSeenScreens = _prefs.getBool('hasSeenScreens') ?? false;

    if (!hasSeenScreens) {
      _prefs.setBool('hasSeenScreens', true);
    } else {
      _navigateToMainScreen();
    }
  }

  void _navigateToMainScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const Login(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  const FirstScreen(),
                  SecondScreen(),
                  const ThirdScreen(),
                ],
              ),
            ),
            _buildPageIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return PageIndicatorRow(
      currentPage: _currentPage,
      totalPageCount: 3,
    );
  }
}
