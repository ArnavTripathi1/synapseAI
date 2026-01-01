import 'package:flutter/material.dart';

import '../../student/chat/screens/chat_screen.dart';
import '../dashboard/screens/counsellor_dashboard.dart';
import '../profile/screens/profile_screen.dart';
import '../schedule/screens/schedule_screen.dart';

class CounsellorMainScreen extends StatefulWidget {
  const CounsellorMainScreen({super.key});

  @override
  State<CounsellorMainScreen> createState() => _CounsellorMainScreenState();
}

class _CounsellorMainScreenState extends State<CounsellorMainScreen> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // Initialize pages
    final List<Widget> screens = [
      CounsellorDashboard(onSwitchTab: _navigateToTab),
      const ScheduleScreen(),
      const ChatsTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF3b5998),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: "Schedule",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
