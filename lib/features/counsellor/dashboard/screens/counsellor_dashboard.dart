import 'package:flutter/material.dart';
import 'package:synapse/features/counsellor/dashboard/screens/all_requests_screen.dart';

class CounsellorDashboard extends StatefulWidget {
  // Callback to tell the parent (MainScreen) to switch tabs
  final Function(int) onSwitchTab;

  const CounsellorDashboard({super.key, required this.onSwitchTab});

  @override
  State<CounsellorDashboard> createState() => _CounsellorDashboardState();
}

class _CounsellorDashboardState extends State<CounsellorDashboard> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Quick Stats Row
            Row(
              children: [
                _buildStatCard(title: "Pending", count: "4", color: Colors.orange),
                const SizedBox(width: 12),
                _buildStatCard(title: "Today", count: "8", color: const Color(0xFF3b5998)),
                const SizedBox(width: 12),
                _buildStatCard(title: "Total", count: "124", color: Colors.blueGrey),
              ],
            ),
            const SizedBox(height: 30),

            // 2. Upcoming Sessions Section -> SWITCHES TO SCHEDULE TAB (Index 1)
            _buildSectionHeader(
              "Upcoming Sessions",
              onSeeAll: () => widget.onSwitchTab(1),
            ),
            const SizedBox(height: 16),

            const SessionCard(
              name: "Aditya Kumar",
              time: "10:00 AM - 11:00 AM",
              issue: "Academic Stress",
              isLive: true,
            ),
            const SessionCard(
              name: "Riya Singh",
              time: "02:00 PM - 03:00 PM",
              issue: "Anxiety",
              isLive: false,
            ),

            const SizedBox(height: 30),

            // 3. New Requests Section -> NAVIGATES TO NEW SCREEN
            _buildSectionHeader(
              "New Requests",
              onSeeAll: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AllRequestsScreen())
                );
              },
            ),
            const SizedBox(height: 16),

            const RequestCard(
              name: "Vikram Malhotra",
              issue: "Depression",
              timeRequested: "Tomorrow, 4:00 PM",
            ),
            const RequestCard(
              name: "Sanya Gupta",
              issue: "Career Guidance",
              timeRequested: "Fri, 11:00 AM",
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Dr. Anjali Sharma",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            "Clinical Psychologist",
            style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: _isOnline ? Colors.green[50] : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _isOnline ? Colors.green : Colors.grey[400]!),
          ),
          child: Row(
            children: [
              Text(
                _isOnline ? "Online" : "Offline",
                style: TextStyle(
                  color: _isOnline ? Colors.green[700] : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: _isOnline,
                  activeColor: Colors.green,
                  onChanged: (val) => setState(() => _isOnline = val),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        InkWell(
          onTap: onSeeAll,
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              "See All",
              style: TextStyle(color: Color(0xFF3b5998), fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({required String title, required String count, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// --- Refactored Widgets ---

class SessionCard extends StatelessWidget {
  final String name;
  final String time;
  final String issue;
  final bool isLive;

  const SessionCard({
    super.key,
    required this.name,
    required this.time,
    required this.issue,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.person, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3b5998).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        issue,
                        style: const TextStyle(fontSize: 10, color: Color(0xFF3b5998), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.access_time_rounded, size: 16, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(
                  isLive ? Icons.videocam : Icons.videocam_off,
                  size: 16,
                  color: isLive ? Colors.white : Colors.grey[600],
                ),
                label: Text(isLive ? "Join Now" : "Wait"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLive ? Colors.redAccent : Colors.grey[200],
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  minimumSize: const Size(0, 36),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
