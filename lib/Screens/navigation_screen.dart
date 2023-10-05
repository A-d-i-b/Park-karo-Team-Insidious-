import 'package:flutter/material.dart';
import 'package:parkit/Screens/history_screen.dart';
import 'package:parkit/Screens/profile_screen.dart';
import '../utils/bottomBarIcon.dart';
import 'home.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int index = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0, keepPage: false);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(
              color: Color(0xff8843b7),
            ),
          ),
          elevation: 5,
          indicatorColor: Colors.white,
          backgroundColor: Colors.white,
        ),
        child: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: index,
          onDestinationSelected: (value) {
            setState(() {
              index = value;
            });
            pageController.jumpToPage(index);
          },
          destinations: [
            BottomBarIcon(
              icon: Icons.home_rounded,
              color: Color(0xff8843b7),
              labelName: "Home",
            ),
            BottomBarIcon(
              icon: Icons.settings_rounded,
              color: Color(0xff8843b7),
              labelName: "Profile",
            ),
            BottomBarIcon(
              icon: Icons.people_rounded,
              color: Color(0xff8843b7),
              labelName: "History",
            ),
          ],
        ),
      ),
      body: PageView(
        controller: pageController,
        children: [
          HomeScreen(),
          Profile(),
          HistoryScreen(),
        ],
        onPageChanged: (page) {
          setState(() {
            index = page;
          });
        },
      ),
    );
  }
}
