import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddSlotSheet extends StatefulWidget {
  final DateTime selectedDate;

  const AddSlotSheet({super.key, required this.selectedDate});

  @override
  State<AddSlotSheet> createState() => _AddSlotSheetState();
}

class _AddSlotSheetState extends State<AddSlotSheet> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _selectedType = 'Available'; // Default type
  final List<String> _types = ['Available', 'Break'];

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF3b5998), // Brand color
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          // Auto-set end time to +1 hour for convenience
          _endTime = TimeOfDay(hour: picked.hour + 1, minute: picked.minute);
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _handleSave() {
    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both start and end times")),
      );
      return;
    }

    // In a real app, you would pass this data back to the parent or API
    // Example: widget.onSave(_startTime, _endTime, _selectedType);

    Navigator.pop(context); // Close the sheet
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Slot added successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEEE, d MMMM').format(widget.selectedDate);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Hug content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            "Add New Slot",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "For $dateStr",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),

          // 2. Slot Type Selector (Chips)
          Text("SLOT TYPE", style: _labelStyle()),
          const SizedBox(height: 10),
          Row(
            children: _types.map((type) {
              final isSelected = _selectedType == type;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FilterChip(
                  label: Text(type),
                  selected: isSelected,
                  selectedColor: const Color(0xFF3b5998).withOpacity(0.1),
                  checkmarkColor: const Color(0xFF3b5998),
                  labelStyle: TextStyle(
                    color: isSelected ? const Color(0xFF3b5998) : Colors.black,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  onSelected: (bool selected) {
                    setState(() => _selectedType = type);
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // 3. Time Pickers
          Row(
            children: [
              Expanded(child: _buildTimeInput("Start Time", _startTime, true)),
              const SizedBox(width: 16),
              Expanded(child: _buildTimeInput("End Time", _endTime, false)),
            ],
          ),
          const SizedBox(height: 32),

          // 4. Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3b5998),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Add to Schedule",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Handle bottom padding for iOS home indicator
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 10),
        ],
      ),
    );
  }

  Widget _buildTimeInput(String label, TimeOfDay? time, bool isStart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _pickTime(isStart),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  time?.format(context) ?? "-- : --",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TextStyle _labelStyle() => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.grey[500],
    letterSpacing: 0.5,
  );
}
