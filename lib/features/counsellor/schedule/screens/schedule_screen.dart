import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synapse/features/counsellor/schedule/screens/session_details_screen.dart';
import 'package:synapse/features/counsellor/schedule/widgets/add_slot_sheet.dart';

// 1. Model for a Time Slot
class TimeSlot {
  final String id;
  final String time;
  String status; // 'Available', 'Booked', 'Break', 'Unavailable'
  String? studentName;
  bool isEnabled; // Corresponds to the Switch toggle

  TimeSlot({
    required this.id,
    required this.time,
    this.status = 'Available',
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
  // State Variables
  int _selectedDateIndex = 0;

  // FIX: Explicitly typed as List<DateTime> to prevent Type Error
  List<DateTime> _dates = [];

  // Map Date Index to a List of Slots (Simulating database storage)
  final Map<int, List<TimeSlot>> _scheduleData = {};

  @override
  void initState() {
    super.initState();
    _generateDates();
    _generateMockSlots();
  }

  // Generate next 14 days dynamically
  void _generateDates() {
    final now = DateTime.now();
    _dates = List.generate(14, (index) => now.add(Duration(days: index)));
  }

  // Create fake data for demonstration
  void _generateMockSlots() {
    // Default pattern for a typical day
    final defaultSlots = [
      TimeSlot(id: '1', time: "09:00 AM", status: "Available"),
      TimeSlot(
        id: '2',
        time: "10:00 AM",
        status: "Booked",
        studentName: "Aditya Kumar",
      ),
      TimeSlot(id: '3', time: "11:00 AM", status: "Available"),
      TimeSlot(id: '4', time: "01:00 PM", status: "Break", isEnabled: false),
      TimeSlot(id: '5', time: "02:00 PM", status: "Available"),
      TimeSlot(
        id: '6',
        time: "03:00 PM",
        status: "Booked",
        studentName: "Riya Singh",
      ),
    ];

    // Populate the map for all 14 days
    for (int i = 0; i < 14; i++) {
      // Create a DEEP COPY of the list so modifying one day doesn't affect others
      _scheduleData[i] = defaultSlots
          .map(
            (e) => TimeSlot(
              id: e.id,
              time: e.time,
              status: e.status,
              studentName: e.studentName,
              isEnabled: e.status != "Break", // Disable toggle for breaks
            ),
          )
          .toList();
    }
  }

  // Handle Switch Toggle logic
  void _toggleSlotAvailability(int slotIndex, bool newValue) {
    setState(() {
      final currentSlots = _scheduleData[_selectedDateIndex]!;
      currentSlots[slotIndex].isEnabled = newValue;

      // Update status text based on toggle
      if (newValue) {
        currentSlots[slotIndex].status = "Available";
      } else {
        currentSlots[slotIndex].status = "Unavailable";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get slots for the currently selected date, default to empty list if loading
    final currentSlots = _scheduleData[_selectedDateIndex] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "My Schedule",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFF3b5998),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                // Allows sheet to expand fully if needed
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => AddSlotSheet(
                  selectedDate:
                      _dates[_selectedDateIndex], // Pass the currently selected date
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Dynamic Date Picker
          Container(
            height: 85,
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.white,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _dates.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final date = _dates[index];
                final isSelected = _selectedDateIndex == index;

                // Format using intl package: "12" and "Mon"
                final dayNum = DateFormat('d').format(date);
                final dayName = DateFormat('E').format(date);

                return GestureDetector(
                  onTap: () => setState(() => _selectedDateIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 60,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF3b5998)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey[200]!,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF3b5998).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayNum,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dayName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white70 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // 2. Dynamic Slots List
          Expanded(
            child: currentSlots.isEmpty
                ? const Center(child: Text("No slots available for this day"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: currentSlots.length,
                    itemBuilder: (context, index) {
                      final slot = currentSlots[index];
                      return _buildTimeSlot(slot, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(TimeSlot slot, int index) {
    Color statusColor;
    Color bgColor;
    bool isBreak = slot.status == 'Break';
    bool isBooked = slot.status == 'Booked';

    // Determine colors based on status
    if (isBreak) {
      statusColor = Colors.grey;
      bgColor = Colors.grey[100]!;
    } else if (isBooked) {
      statusColor = const Color(0xFF3b5998);
      bgColor = Colors.blue[50]!;
    } else if (slot.isEnabled) {
      statusColor = Colors.green;
      bgColor = Colors.green[50]!;
    } else {
      // Unavailable state
      statusColor = Colors.red;
      bgColor = Colors.red[50]!;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Time Column
          SizedBox(
            width: 80,
            child: Text(
              slot.time,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          // Vertical Divider
          Container(height: 30, width: 2, color: Colors.grey[200]),
          const SizedBox(width: 16),

          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    slot.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                if (slot.studentName != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    slot.studentName!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Actions
          if (isBooked)
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
              onPressed: () {
                // Navigate to session details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SessionDetailsScreen(
                      studentName: slot.studentName ?? "Unknown",
                      time: slot.time,
                    ),
                  ),
                );
              },
            )
          else if (!isBreak)
            Switch(
              value: slot.isEnabled,
              activeColor: Colors.green,
              inactiveTrackColor: Colors.red[100],
              inactiveThumbColor: Colors.red,
              onChanged: (val) => _toggleSlotAvailability(index, val),
            ),
        ],
      ),
    );
  }
}
