import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- NAVIGATIONS ---
import '../../resources/resources_screen.dart';
import '../../schedule/screens/session_details_screen.dart'; // Ensure this file exists
import 'all_requests_screen.dart'; // Ensure this file exists

class CounsellorDashboard extends StatefulWidget {
  final Function(int) onSwitchTab; // Function to switch bottom tabs

  const CounsellorDashboard({super.key, required this.onSwitchTab});

  @override
  State<CounsellorDashboard> createState() => _CounsellorDashboardState();
}

class _CounsellorDashboardState extends State<CounsellorDashboard> {
  // --- STATE VARIABLES ---
  bool _isLoading = true;
  bool _isOnline = false;

  // Profile Data
  String _counselorProfileId = "";
  String _counselorName = "Loading...";
  String _specialization = "";

  // Stats
  int _pendingCount = 0;
  int _todayCount = 0;
  int _totalCount = 0;

  // Lists
  List<dynamic> _upcomingSessions = [];
  List<dynamic> _pendingRequests = [];

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  // --- 1. DATA FETCHING LOGIC ---
  Future<void> _fetchDashboardData() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();

      // A. Fetch Counselor Profile
      const String profileQuery = '''
        query GetMyCounselorProfile(\$uid: ID!) {
          listCounselorProfiles(filter: { userProfileID: { eq: \$uid } }) {
            items {
              id
              specialization
              isOnline
              user {
                name
                imageUrl
              }
            }
          }
        }
      ''';

      final profileReq = GraphQLRequest<String>(
        document: profileQuery,
        variables: {'uid': user.userId},
        authorizationMode: APIAuthorizationType.userPools,
      );
      final profileRes = await Amplify.API.query(request: profileReq).response;

      if (profileRes.data == null) throw Exception("Could not fetch profile");

      final items =
          jsonDecode(profileRes.data!)['listCounselorProfiles']['items']
              as List;
      if (items.isEmpty) {
        // Handle case where profile doesn't exist yet
        setState(() => _isLoading = false);
        return;
      }

      final counselorProfile = items[0];
      _counselorProfileId = counselorProfile['id'];

      // B. Fetch Appointments
      const String apptQuery = '''
        query ListCounselorAppointments(\$cid: ID!) {
          listAppointments(filter: { counselorID: { eq: \$cid } }) {
            items {
              id
              date
              timeSlot
              status
              topic
              student {
                user {
                  name
                  imageUrl
                }
              }
            }
          }
        }
      ''';

      final apptReq = GraphQLRequest<String>(
        document: apptQuery,
        variables: {'cid': _counselorProfileId},
        authorizationMode: APIAuthorizationType.userPools,
      );
      final apptRes = await Amplify.API.query(request: apptReq).response;

      if (apptRes.data == null) throw Exception("Could not fetch appointments");

      final List<dynamic> allAppts = jsonDecode(
        apptRes.data!,
      )['listAppointments']['items'];

      // C. Process Data
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      int pCount = 0;
      int tCount = 0;
      int totCount = 0;
      List<dynamic> upcoming = [];
      List<dynamic> requests = [];

      for (var appt in allAppts) {
        final status = appt['status'];
        final date = appt['date'];

        if (status == 'COMPLETED') totCount++;

        if (status == 'PENDING') {
          pCount++;
          requests.add(appt);
        }

        if (status == 'CONFIRMED') {
          if (date == todayStr) tCount++;
          // Add if date is today or future
          if (date.compareTo(todayStr) >= 0) upcoming.add(appt);
        }
      }

      // Sort by date/time
      upcoming.sort((a, b) => a['date'].compareTo(b['date']));
      requests.sort((a, b) => a['date'].compareTo(b['date']));

      if (mounted) {
        setState(() {
          _counselorName = counselorProfile['user']['name'] ?? "Counselor";
          _specialization = counselorProfile['specialization'] ?? "Specialist";
          _isOnline = counselorProfile['isOnline'] ?? false;
          _pendingCount = pCount;
          _todayCount = tCount;
          _totalCount = totCount;
          _upcomingSessions = upcoming;
          _pendingRequests = requests;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Dashboard Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- 2. ACTIONS ---

  Future<void> _updateRequestStatus(
    String appointmentId,
    bool isAccepted,
  ) async {
    // Optimistic UI Update
    final itemIndex = _pendingRequests.indexWhere(
      (x) => x['id'] == appointmentId,
    );
    final item = itemIndex != -1 ? _pendingRequests[itemIndex] : null;

    setState(() {
      _pendingRequests.removeWhere((x) => x['id'] == appointmentId);
      _pendingCount = _pendingRequests.length;
    });

    try {
      final newStatus = isAccepted ? "CONFIRMED" : "CANCELLED";

      const String mutation = '''
        mutation UpdateAppointmentStatus(\$id: ID!, \$status: AppointmentStatus!) {
          updateAppointment(input: { id: \$id, status: \$status }) {
            id
            status
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {'id': appointmentId, 'status': newStatus},
        authorizationMode: APIAuthorizationType.userPools,
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) throw Exception("GraphQL Error");

      // Refresh to ensure 'upcoming' list gets the new confirmed session
      _fetchDashboardData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAccepted ? "Session Confirmed" : "Request Declined"),
          backgroundColor: isAccepted ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      // Revert Optimistic update if failed
      if (item != null) {
        setState(() {
          _pendingRequests.insert(itemIndex, item);
          _pendingCount = _pendingRequests.length;
        });
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _toggleOnlineStatus(bool val) async {
    setState(() => _isOnline = val);
    try {
      const String mutation = '''
        mutation UpdateStatus(\$id: ID!, \$isOnline: Boolean!) {
          updateCounselorProfile(input: { id: \$id, isOnline: \$isOnline }) { id }
        }
      ''';
      final req = GraphQLRequest<String>(
        document: mutation,
        variables: {'id': _counselorProfileId, 'isOnline': val},
        authorizationMode: APIAuthorizationType.userPools,
      );
      await Amplify.API.mutate(request: req).response;
    } catch (e) {
      setState(() => _isOnline = !val); // Revert on error
    }
  }

  // ==========================================
  // 3. UI BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _fetchDashboardData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- A. STATS ROW ---
              Row(
                children: [
                  _buildStatCard("Pending", "$_pendingCount", Colors.orange),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    "Today",
                    "$_todayCount",
                    const Color(0xFF3b5998),
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard("Total", "$_totalCount", Colors.blueGrey),
                ],
              ),
              const SizedBox(height: 20),

              // --- B. RESOURCE LIBRARY CARD (New!) ---
              _buildResourceLibraryCard(),
              const SizedBox(height: 30),

              // --- C. UPCOMING SESSIONS ---
              _buildSectionHeader(
                "Upcoming Sessions",
                () => widget.onSwitchTab(1), // Switch to Calendar Tab
              ),
              const SizedBox(height: 12),

              if (_upcomingSessions.isEmpty)
                _buildEmptyState("No upcoming sessions today"),

              ..._upcomingSessions.take(3).map((appt) {
                final studentName =
                    appt['student']?['user']?['name'] ?? "Unknown";
                final isToday =
                    appt['date'] ==
                    DateFormat('yyyy-MM-dd').format(DateTime.now());

                return SessionCard(
                  appointmentId: appt['id'],
                  name: studentName,
                  time: "${appt['timeSlot']} (${appt['date'].substring(5)})",
                  issue: appt['topic'] ?? "General",
                  isLive: isToday,
                );
              }),

              const SizedBox(height: 30),

              // --- D. PENDING REQUESTS ---
              _buildSectionHeader(
                "New Requests",
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AllRequestsScreen()),
                ),
              ),
              const SizedBox(height: 12),

              if (_pendingRequests.isEmpty)
                _buildEmptyState("No pending requests"),

              ..._pendingRequests.take(3).map((appt) {
                final studentName =
                    appt['student']?['user']?['name'] ?? "Unknown";

                return RequestCard(
                  name: studentName,
                  issue: appt['topic'] ?? "General",
                  timeRequested: "${appt['date']} @ ${appt['timeSlot']}",
                  onAccept: () => _updateRequestStatus(appt['id'], true),
                  onDecline: () => _updateRequestStatus(appt['id'], false),
                );
              }),

              const SizedBox(height: 60), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _counselorName,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            _specialization,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
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
              const SizedBox(width: 8),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: _isOnline,
                  activeColor: Colors.green,
                  onChanged: _toggleOnlineStatus,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceLibraryCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyUploadedResourcesScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF3b5998), // Primary Blue
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3b5998).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.library_add_check,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Resource Library",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "Upload & manage content",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              "See All",
              style: TextStyle(
                color: Color(0xFF3b5998),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String msg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Center(
        child: Text(
          msg,
          style: TextStyle(
            color: Colors.grey[400],
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}

// =========================================================
// INTERNAL COMPONENTS (Can be moved to separate files later)
// =========================================================

class SessionCard extends StatelessWidget {
  final String appointmentId;
  final String name, time, issue;
  final bool isLive;

  const SessionCard({
    super.key,
    required this.appointmentId,
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[200],
                child: Text(
                  name[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      issue,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF3b5998),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isLive)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SessionDetailsScreen(appointmentId: appointmentId),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Join Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  final String name, issue, timeRequested;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const RequestCard({
    super.key,
    required this.name,
    required this.issue,
    required this.timeRequested,
    required this.onAccept,
    required this.onDecline,
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
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$issue • $timeRequested",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: onDecline,
                icon: const Icon(Icons.close, color: Colors.red),
              ),
              IconButton(
                onPressed: onAccept,
                icon: const Icon(Icons.check, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
