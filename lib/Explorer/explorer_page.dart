import 'package:flutter/material.dart';
import '../Account/account_page.dart';
import '../Sections/SectionPage.dart';
import '../Settings/SettingsPage.dart';
import 'ExplorerContentPage.dart';
import 'package:admin_pc_part/chart/chartPage.dart';

class ExplorerPage extends StatefulWidget {
  final String userID;

  const ExplorerPage({super.key, required this.userID});

  @override
  _ExplorerPageState createState() => _ExplorerPageState(userID: userID);
}

class _ExplorerPageState extends State<ExplorerPage> {
  late PageController _pageController;
  int _currentIndex = 2;
  final String userID;

  _ExplorerPageState({required this.userID});

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: const InkWell(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('lib/assets/user.png'),
          ),

        ),
      ),
      title: const Text('PC Part'),

    );
  }

  PageView _buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      children: [
        AccountPage(userID: userID),
        ExplorerContentPage(userID: userID),
        SectionPage(userID: userID),
        ChartPage(userID: userID),
        SettingsPage(userID: userID),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        _pageController.jumpToPage(index);
      },
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.black,
      selectedLabelStyle: const TextStyle(color: Colors.black),
      unselectedLabelStyle: const TextStyle(color: Colors.black),
      items: [
        _buildBottomNavigationBarItem('lib/assets/user.png', 'Account', 0),
        _buildBottomNavigationBarItem('lib/assets/explore.png', 'Explorer', 2),
        _buildBottomNavigationBarItem('lib/assets/compass.png', 'Section', 1),
        _buildBottomNavigationBarItem('lib/assets/chart.png', 'Charts', 3),
        _buildBottomNavigationBarItem('lib/assets/setting.png', 'Settings', 4),

      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      String imagePath, String label, int index) {
    return BottomNavigationBarItem(
      icon: InkWell(
        onTap: () {
          _pageController.jumpToPage(index);
        },
        child: Image.asset(imagePath, width: 24, height: 24),
      ),
      label: label,
    );
  }
}
