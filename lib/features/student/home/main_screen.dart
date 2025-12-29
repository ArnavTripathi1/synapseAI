import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../chat/screens/chat_ai_screen.dart';
import '../dashboard/screens/dashboard_screen.dart';
import '../resources/screens/resources_screen.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // The 3 Main Views
  final List<Widget> _screens = [
    const DashboardScreen(), // Index 0: Home/Stats
    const ChatAIScreen(),      // Index 1: The AI Copilot (Center)
    const ResourcesScreen(), // Index 2: Hub
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: AppTheme.secondary.withOpacity(0.5),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.robot), // Robot icon for AI
            label: 'Synapse',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_rounded),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
