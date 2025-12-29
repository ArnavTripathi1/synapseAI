import 'dart:convert';

import 'package:amplify_authenticator/amplify_authenticator.dart'; // Needed for SignOutButton
// 1. AWS Imports
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../auth/role_selection_screen.dart';
// 2. Screen Imports
import '../../../counsellor/home/main_screen.dart';
import '../../counselling/screens/talk_to_counsellor.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // 3. State Variables
  String _userName = "Loading...";
  int _wellnessScore = 0;
  bool _isLoading = true;
  bool _profileExists = true; // Tracks if we need to force setup

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // 4. The Query Function (With Strict Check)
  Future<void> _fetchUserData() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();

      final request = GraphQLRequest<String>(
        document: '''
        query GetUserProfile(\$id: ID!) {
          getUserProfile(id: \$id) {
            id
            name
            role
          }
        }
      ''',
        variables: {'id': user.userId},
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.errors.isNotEmpty || response.data == null) {
        _handleMissingProfile();
        return;
      }

      final data = jsonDecode(response.data!);
      final profile = data['getUserProfile'];

      if (profile == null) {
        _handleMissingProfile();
        return;
      }

      final String role = profile['role'];

      // 🔹 ROLE-BASED REDIRECTION (HERE)
      if (role == 'COUNSELOR') {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CounsellorMainScreen()),
        );
        return;
      }

      // 🔹 STUDENT FLOW
      if (!mounted) return;
      setState(() {
        _userName = profile['name'];
        _profileExists = true;
        _isLoading = false;
      });
    } catch (e) {
      safePrint("Dashboard error: $e");
      _handleMissingProfile();
    }
  }

  void _handleMissingProfile() {
    if (!mounted) return;
    setState(() {
      _userName = "Friend";
      _profileExists = false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // A. LOADING STATE
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // B. MISSING PROFILE STATE (Forces Setup)
    if (!_profileExists) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle_outlined,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 24),
              Text(
                "Profile Missing",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "You are logged in, but we don't know your name or role yet.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Button to Go to Setup
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Role Selection Screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RoleSelectionScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Complete Setup",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SignOutButton(), // Allows user to logout and retry
            ],
          ),
        ),
      );
    }

    // C. DASHBOARD STATE (Success)
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildMentalBatteryCard(),

              const SizedBox(height: 24),
              _buildCounsellorCard(),

              const SizedBox(height: 24),
              _buildSectionTitle("Weekly Trends"),
              const SizedBox(height: 16),
              _buildMoodChart(),
              const SizedBox(height: 24),
              _buildSectionTitle("Lifestyle Pulse"),
              const SizedBox(height: 16),
              _buildLifestyleGrid(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Morning,",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            Text(
              _userName,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.teal.shade100,
            child: Text(
              _userName.isNotEmpty ? _userName[0].toUpperCase() : "U",
              style: const TextStyle(fontSize: 20, color: Colors.teal),
            ),
          ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: -0.2, end: 0);
  }

  Widget _buildMentalBatteryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFA1C4FD), Color(0xFFC2E9FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA1C4FD).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mental Battery",
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF1E293B),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "You are doing great!",
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF1E293B).withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              CircularPercentIndicator(
                radius: 30.0,
                lineWidth: 6.0,
                percent: _wellnessScore / 100,
                center: Text(
                  "$_wellnessScore%",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                progressColor: Colors.white,
                backgroundColor: Colors.white.withOpacity(0.3),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Icon(
                  FontAwesomeIcons.penToSquare,
                  size: 16,
                  color: Color(0xFF1E293B),
                ),
                const SizedBox(width: 10),
                Text(
                  "Log today's mood",
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF1E293B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Color(0xFF1E293B),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).scale();
  }

  Widget _buildCounsellorCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TalkToCounsellorScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.teal.withOpacity(0.1), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                FontAwesomeIcons.userDoctor,
                color: Colors.teal.shade700,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Need someone to talk to?",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Book a confidential session",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 250.ms).slideX();
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1E293B),
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildMoodChart() {
    return Container(
      height: 220,
      padding: const EdgeInsets.only(right: 20, left: 20, top: 24, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  const days = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ];
                  final index = value.toInt();
                  if (index >= 0 && index < days.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        days[index],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 10,
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 6),
                FlSpot(1, 8),
                FlSpot(2, 5),
                FlSpot(3, 7),
                FlSpot(4, 6),
                FlSpot(5, 9),
                FlSpot(6, 8),
              ],
              isCurved: true,
              color: const Color(0xFFA1C4FD),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFA1C4FD).withOpacity(0.3),
                    const Color(0xFFA1C4FD).withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideX();
  }

  Widget _buildLifestyleGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            "Sleep",
            "7h 30m",
            0.75,
            FontAwesomeIcons.moon,
            Colors.purpleAccent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            "Focus",
            "4h 15m",
            0.60,
            FontAwesomeIcons.brain,
            Colors.tealAccent,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildInfoCard(
    String title,
    String value,
    double percent,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: color.withOpacity(0.8)),
              ),
              CircularPercentIndicator(
                radius: 18.0,
                lineWidth: 4.0,
                percent: percent,
                progressColor: color.withOpacity(0.8),
                backgroundColor: color.withOpacity(0.1),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
