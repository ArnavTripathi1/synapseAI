import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';

class AllRequestsScreen extends StatefulWidget {
  const AllRequestsScreen({super.key});

  @override
  State<AllRequestsScreen> createState() => _AllRequestsScreenState();
}

class _AllRequestsScreenState extends State<AllRequestsScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _requests = [];
  String _counselorId = "";

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  // ==========================================
  // 🚀 BACKEND LOGIC
  // ==========================================

  Future<void> _fetchRequests() async {
    setState(() => _isLoading = true);
    try {
      final user = await Amplify.Auth.getCurrentUser();

      // 1. Get Counselor ID
      if (_counselorId.isEmpty) {
        const profileQuery = '''query GetMyId(\$uid: ID!) {
          listCounselorProfiles(filter: { userProfileID: { eq: \$uid } }) {
            items { id }
          }
        }''';
        final profileReq = GraphQLRequest<String>(
          document: profileQuery,
          variables: {'uid': user.userId},
          authorizationMode: APIAuthorizationType.userPools,
        );
        final profileRes = await Amplify.API.query(request: profileReq).response;

        if (profileRes.data != null) {
          final data = jsonDecode(profileRes.data!);
          final items = data['listCounselorProfiles']['items'] as List;
          if (items.isNotEmpty) {
            _counselorId = items[0]['id'];
          } else {
            safePrint("❌ No Counselor Profile found.");
            if(mounted) setState(() => _isLoading = false);
            return;
          }
        }
      }

      // 2. Fetch ALL Appointments (Removed _version)
      const requestQuery = '''query GetAllAppointments(\$cid: ID!) {
        listAppointments(filter: { 
          counselorID: { eq: \$cid }
        }) {
          items {
            id
            date
            timeSlot
            topic
            status
            student {
              user { name imageUrl }
            }
          }
        }
      }''';

      final req = GraphQLRequest<String>(
        document: requestQuery,
        variables: {'cid': _counselorId},
        authorizationMode: APIAuthorizationType.userPools,
      );
      final res = await Amplify.API.query(request: req).response;

      if (res.data != null) {
        final data = jsonDecode(res.data!);
        final allItems = data['listAppointments']['items'] as List;

        // ✅ CLIENT-SIDE FILTER: Only keep 'PENDING'
        final pendingItems = allItems.where((item) {
          return item['status'] == 'PENDING';
        }).toList();

        if (mounted) {
          setState(() {
            _requests = pendingItems.cast<Map<String, dynamic>>();
            _isLoading = false;
          });
        }
      } else {
        safePrint("Error response: ${res.errors}");
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      safePrint("Error fetching requests: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ✅ Process Request (Removed version parameter)
  Future<void> _processRequest(String id, bool isAccepted) async {
    // Optimistic UI Update
    setState(() {
      _requests.removeWhere((r) => r['id'] == id);
    });

    try {
      final newStatus = isAccepted ? "CONFIRMED" : "CANCELLED";

      // ✅ Removed _version from mutation
      const mutation = '''mutation UpdateStatus(\$id: ID!, \$st: AppointmentStatus!) {
        updateAppointment(input: { id: \$id, status: \$st }) { id }
      }''';

      final req = GraphQLRequest<String>(
        document: mutation,
        variables: {'id': id, 'st': newStatus},
        authorizationMode: APIAuthorizationType.userPools,
      );

      final res = await Amplify.API.mutate(request: req).response;

      if (res.hasErrors) {
        _fetchRequests(); // Revert on error
        safePrint("Update Error: ${res.errors}");
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${res.errors.first.message}"))
          );
        }
      } else {
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isAccepted ? "Session Confirmed ✅" : "Request Declined ❌"),
                backgroundColor: isAccepted ? Colors.green : Colors.red,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              )
          );
        }
      }
    } catch (e) {
      safePrint("Error processing: $e");
      _fetchRequests();
    }
  }

  // ==========================================
  // 🎨 UI BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Pending Requests", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _requests.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: _fetchRequests,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: _requests.length,
          itemBuilder: (context, index) {
            final item = _requests[index];

            // Safe Data Extraction
            final studentName = item['student']?['user']?['name'] ?? "Unknown Student";
            final dateStr = item['date'];
            final timeStr = item['timeSlot'];
            final topic = item['topic'] ?? "General Session";

            // Format Date
            String niceDate = dateStr;
            try {
              final dt = DateTime.parse(dateStr);
              niceDate = DateFormat('EEE, MMM d').format(dt);
            } catch (_) {}

            return RequestCard(
              name: studentName,
              issue: topic,
              timeRequested: "$niceDate @ $timeStr",
              // ✅ No version passed here
              onAccept: () => _processRequest(item['id'], true),
              onDecline: () => _processRequest(item['id'], false),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("All caught up!", style: TextStyle(color: Colors.grey[600], fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("No pending requests at the moment.", style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  final String name;
  final String issue;
  final String timeRequested;
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFF3b5998).withOpacity(0.1),
            child: Text(name.isNotEmpty ? name[0] : "?", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3b5998))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text("$issue", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87)),
                Text(timeRequested, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Row(
            children: [
              _actionIcon(Icons.close, Colors.red, onDecline),
              const SizedBox(width: 12),
              _actionIcon(Icons.check, Colors.green, onAccept),
            ],
          )
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, MaterialColor color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color[50],
            shape: BoxShape.circle,
            border: Border.all(color: color[100]!),
          ),
          child: Icon(icon, size: 20, color: color[700]),
        ),
      ),
    );
  }
}
