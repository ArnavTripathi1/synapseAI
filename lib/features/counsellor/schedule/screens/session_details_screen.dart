import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:url_launcher/url_launcher.dart'; // Add url_launcher to pubspec.yaml if needed

class SessionDetailsScreen extends StatefulWidget {
  final String appointmentId;
  // We pass ID instead of raw strings to fetch fresh data

  // Keep these for Hero animations or placeholders if needed,
  // but we will fetch the real data.
  final String? placeholderName;
  final String? placeholderTime;

  const SessionDetailsScreen({
    super.key,
    required this.appointmentId,
    this.placeholderName,
    this.placeholderTime,
  });

  @override
  State<SessionDetailsScreen> createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen> {
  bool _isLoading = true;
  bool _isSavingNotes = false;

  // Data Containers
  Map<String, dynamic>? _sessionData;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSessionDetails();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // ==========================================
  // 🚀 BACKEND LOGIC
  // ==========================================

  Future<void> _fetchSessionDetails() async {
    try {
      const String query = '''
        query GetAppointmentDetails(\$id: ID!) {
          getAppointment(id: \$id) {
            id
            date
            timeSlot
            status
            topic
            meetingLink
            counselorNotes
            student {
              branch
              year
              user {
                name
                imageUrl
                phoneNumber
              }
            }
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {'id': widget.appointmentId},
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final data = jsonDecode(response.data!);
        final appointment = data['getAppointment'];

        if (mounted) {
          setState(() {
            _sessionData = appointment;
            // Pre-fill notes if they exist
            if (appointment['counselorNotes'] != null) {
              _notesController.text = appointment['counselorNotes'];
            }
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      safePrint("Error fetching session: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _cancelSession() async {
    try {
      const String mutation = '''
        mutation CancelAppointment(\$id: ID!, \$status: AppointmentStatus!) {
          updateAppointment(input: { id: \$id, status: \$status }) {
            id
            status
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'id': widget.appointmentId,
          'status': 'CANCELLED'
        },
        authorizationMode: APIAuthorizationType.userPools,
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Session Cancelled Successfully"), backgroundColor: Colors.red),
          );
          Navigator.pop(context); // Go back
        }
      }
    } catch (e) {
      safePrint("Error cancelling session: $e");
    }
  }

  Future<void> _saveNotes() async {
    setState(() => _isSavingNotes = true);
    try {
      const String mutation = '''
        mutation UpdateNotes(\$id: ID!, \$notes: String) {
          updateAppointment(input: { id: \$id, counselorNotes: \$notes }) {
            id
            counselorNotes
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'id': widget.appointmentId,
          'notes': _notesController.text
        },
        authorizationMode: APIAuthorizationType.userPools,
      );

      await Amplify.API.mutate(request: request).response;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Notes Saved!"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      safePrint("Error saving notes: $e");
    } finally {
      if (mounted) setState(() => _isSavingNotes = false);
    }
  }

  // ==========================================
  // 🎨 UI BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_sessionData == null) {
      return const Scaffold(body: Center(child: Text("Session not found")));
    }

    // Extract Data safely
    final student = _sessionData!['student'];
    final user = student?['user'];
    final studentName = user?['name'] ?? widget.placeholderName ?? "Unknown";
    final branch = student?['branch'] ?? "General";
    final year = student?['year'] ?? "Student";
    final topic = _sessionData!['topic'] ?? "General Session";
    final timeSlot = _sessionData!['timeSlot'] ?? widget.placeholderTime ?? "--:--";
    final date = _sessionData!['date'] ?? "Today";
    final status = _sessionData!['status'] ?? "CONFIRMED";
    final isCancelled = status == 'CANCELLED';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Session Details", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Status Banner (if Cancelled)
            if (isCancelled)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
                child: const Text(
                  "This session has been cancelled.",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

            // 2. Student Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFF3b5998),
                    child: Text(
                      _getInitials(studentName),
                      style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(studentName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(4)),
                              child: Text(topic, style: TextStyle(fontSize: 12, color: Colors.orange[800], fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            Flexible(child: Text("•  $year $branch", style: TextStyle(fontSize: 12, color: Colors.grey[600]), overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. Session Info
            const Text("SCHEDULE DETAILS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
              child: Column(
                children: [
                  _buildDetailRow(Icons.calendar_today, "Date", date),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                  _buildDetailRow(Icons.access_time, "Time", timeSlot),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                  _buildDetailRow(Icons.videocam_outlined, "Platform", "In-App Video Call"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 4. Join Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: isCancelled ? null : () {
                  // Logic to join call (e.g., launch meetingLink)
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Launching Video Call...")));
                },
                icon: const Icon(Icons.video_call, color: Colors.white),
                label: const Text("Join Session Now", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3b5998),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  disabledBackgroundColor: Colors.grey[300],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 5. Notes Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("PRIVATE NOTES", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                if (_isSavingNotes)
                  const SizedBox(height: 12, width: 12, child: CircularProgressIndicator(strokeWidth: 2))
                else
                  InkWell(
                    onTap: _saveNotes,
                    child: const Text("Save", style: TextStyle(color: Color(0xFF3b5998), fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Add notes about this session...",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3b5998))),
              ),
            ),

            const SizedBox(height: 40),

            // 6. Cancel Button
            if (!isCancelled)
              Center(
                child: TextButton(
                  onPressed: () => _showCancelConfirmation(context),
                  child: const Text("Cancel Session", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.blueGrey[50], borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 20, color: Colors.blueGrey)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ],
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    List<String> parts = name.trim().split(" ");
    if (parts.isEmpty) return "";
    if (parts.length > 1) return "${parts.first[0]}${parts.last[0]}".toUpperCase();
    return parts.first[0].toUpperCase();
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Session?"),
        content: const Text("Are you sure? This cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Keep Session")),
          TextButton(onPressed: () {
            Navigator.pop(context);
            _cancelSession();
          }, child: const Text("Confirm Cancel", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
