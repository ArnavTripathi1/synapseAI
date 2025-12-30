import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';

import 'package:synapse/features/counsellor/schedule/screens/session_details_screen.dart';
import 'package:synapse/features/counsellor/schedule/widgets/add_slot_sheet.dart';

class TimeSlot {
  final String id;
  final String time;
  String status;
  String? studentName;
  bool isEnabled;

  TimeSlot({
    required this.id,
    required this.time,
    required this.status,
    this.studentName,
    this.isEnabled = true,
  });
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedDateIndex = 0;
  List<DateTime> _dates = [];
  bool _isLoading = false;
  String _counselorProfileId = "";
  List<TimeSlot> _currentSlots = [];

  @override
  void initState() {
    super.initState();
    safePrint("DEBUG: ScheduleScreen initState called");
    _generateDates();
    _initializeScreen();
  }

  void _generateDates() {
    final now = DateTime.now();
    _dates = List.generate(14, (index) => now.add(Duration(days: index)));
  }

  Future<void> _initializeScreen() async {
    safePrint("DEBUG: Initializing Screen...");
    await _fetchCounselorId();
    if (_dates.isNotEmpty) {
      safePrint("DEBUG: Fetching slots for first date: ${_dates[0]}");
      _fetchSlotsForDate(_dates[0]);
    } else {
      safePrint("DEBUG: No dates generated!");
    }
  }

  Future<void> _fetchCounselorId() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      safePrint("DEBUG: Current User ID: ${user.userId}");

      const query = '''
        query GetMyId(\$uid: ID!) {
          listCounselorProfiles(filter: { userProfileID: { eq: \$uid } }) {
            items { id }
          }
        }
      ''';

      final req = GraphQLRequest<String>(
        document: query,
        variables: {'uid': user.userId},
        authorizationMode: APIAuthorizationType.userPools,
      );

      safePrint("DEBUG: Sending Counselor Profile Query...");
      final res = await Amplify.API.query(request: req).response;

      if (res.hasErrors) {
        safePrint("DEBUG: Profile Query Errors: ${res.errors}");
        return;
      }

      if (res.data != null) {
        final data = jsonDecode(res.data!);
        final items = data['listCounselorProfiles']['items'] as List;
        safePrint("DEBUG: Found ${items.length} Counselor Profiles");

        if (items.isNotEmpty) {
          _counselorProfileId = items[0]['id'];
          safePrint("DEBUG: Set Counselor ID to: $_counselorProfileId");
        } else {
          safePrint("DEBUG: WARNING - No Counselor Profile found for this user.");
        }
      } else {
        safePrint("DEBUG: Profile Query returned null data");
      }
    } catch (e) {
      safePrint("DEBUG: Exception in _fetchCounselorId: $e");
    }
  }

  Future<void> _fetchSlotsForDate(DateTime date) async {
    if (_counselorProfileId.isEmpty) {
      safePrint("DEBUG: Aborting fetch. Counselor ID is empty.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      safePrint("DEBUG: Querying slots for Date: $formattedDate and CID: $_counselorProfileId");

      const query = '''
        query GetSlots(\$cid: ID!, \$date: String!) {
          listAppointments(filter: { counselorID: { eq: \$cid }, date: { eq: \$date } }) {
            items {
              id
              timeSlot
              status
              student {
                user { name }
              }
            }
          }
        }
      ''';

      final req = GraphQLRequest<String>(
        document: query,
        variables: {'cid': _counselorProfileId, 'date': formattedDate},
        authorizationMode: APIAuthorizationType.userPools,
      );

      safePrint("DEBUG: Sending Appointments Query...");
      final res = await Amplify.API.query(request: req).response;

      if (res.hasErrors) {
        safePrint("DEBUG: Appointments Query Errors: ${res.errors}");
      }

      List<TimeSlot> loadedSlots = [];

      if (res.data != null) {
        final data = jsonDecode(res.data!);
        final items = data['listAppointments']['items'] as List;
        safePrint("DEBUG: Raw Items from DB: $items");

        for (var item in items) {
          if (item['status'] == 'CANCELLED') continue;

          loadedSlots.add(TimeSlot(
            id: item['id'],
            time: item['timeSlot'],
            status: item['status'],
            studentName: item['student']?['user']?['name'],
            isEnabled: true,
          ));
        }
        safePrint("DEBUG: Parsed ${loadedSlots.length} valid slots");
      } else {
        safePrint("DEBUG: Appointments Query returned null data");
      }

      loadedSlots.sort((a, b) => a.time.compareTo(b.time));

      if (mounted) {
        setState(() {
          _currentSlots = loadedSlots;
          _isLoading = false;
        });
      }

    } catch (e) {
      safePrint("DEBUG: Exception in _fetchSlotsForDate: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteSlot(String appointmentId) async {
    safePrint("DEBUG: Deleting slot $appointmentId");
    try {
      const mutation = '''
        mutation DeleteSlot(\$id: ID!) {
          deleteAppointment(input: { id: \$id }) { id }
        }
      ''';
      final req = GraphQLRequest<String>(
        document: mutation,
        variables: {'id': appointmentId},
        authorizationMode: APIAuthorizationType.userPools,
      );
      final res = await Amplify.API.mutate(request: req).response;

      if(res.hasErrors) {
        safePrint("DEBUG: Delete Error: ${res.errors}");
      } else {
        safePrint("DEBUG: Slot Deleted Successfully");
        _fetchSlotsForDate(_dates[_selectedDateIndex]);
      }

    } catch (e) {
      safePrint("DEBUG: Exception deleting slot: $e");
    }
  }

  // ==========================================
  // 🎨 UI BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Schedule", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Color(0xFF3b5998), size: 28),
            onPressed: () {
              if (_counselorProfileId.isEmpty) {
                _fetchCounselorId();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Loading profile... try again in a second.")));
                return;
              }

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                builder: (context) => AddSlotSheet(
                  counselorId: _counselorProfileId,
                  selectedDate: _dates[_selectedDateIndex],
                ),
              ).then((_) {
                _fetchSlotsForDate(_dates[_selectedDateIndex]);
              });
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 85,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _dates.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final date = _dates[index];
                final isSelected = _selectedDateIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedDateIndex = index);
                    _fetchSlotsForDate(date);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 60,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF3b5998) : Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[200]!),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat('d').format(date), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
                        const SizedBox(height: 4),
                        Text(DateFormat('E').format(date), style: TextStyle(fontSize: 12, color: isSelected ? Colors.white70 : Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _currentSlots.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _currentSlots.length,
              itemBuilder: (context, index) {
                return _buildTimeSlot(_currentSlots[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("No slots added for this day", style: TextStyle(color: Colors.grey[500])),
          const SizedBox(height: 8),
          Text("Tap '+' to add availability", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          if (_counselorProfileId.isEmpty)
            const Text("(Profile ID missing)", style: TextStyle(color: Colors.red, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(TimeSlot slot) {
    bool isConfirmed = slot.status == 'CONFIRMED';
    bool isPending = slot.status == 'PENDING';
    bool isAvailable = slot.status == 'AVAILABLE';

    Color bgColor = Colors.white;
    Color borderColor = Colors.grey[200]!;

    if (isConfirmed) {
      bgColor = Colors.blue[50]!;
      borderColor = Colors.blue[100]!;
    } else if (isPending) {
      bgColor = Colors.orange[50]!;
      borderColor = Colors.orange[100]!;
    }

    return Dismissible(
      key: Key(slot.id),
      direction: isAvailable ? DismissDirection.endToStart : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red[50],
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      onDismissed: (_) => _deleteSlot(slot.id),
      child: GestureDetector(
        onTap: (isConfirmed || isPending) ? () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SessionDetailsScreen(appointmentId: slot.id)
          ));
        } : null,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              const Icon(Icons.access_time, size: 18, color: Colors.grey),
              const SizedBox(width: 12),
              Text(
                slot.time,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),

              if (isConfirmed) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                  child: Text(slot.studentName ?? "Booked", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF3b5998))),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF3b5998)),
              ] else if (isPending) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                  child: const Text("Request", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange)),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.circle, size: 10, color: Colors.orange),
              ] else ...[
                const Text("Available", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
