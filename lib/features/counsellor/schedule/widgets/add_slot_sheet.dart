import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';

class AddSlotSheet extends StatefulWidget {
  final String counselorId;
  final DateTime selectedDate;

  const AddSlotSheet({super.key, required this.counselorId, required this.selectedDate});

  @override
  State<AddSlotSheet> createState() => _AddSlotSheetState();
}

class _AddSlotSheetState extends State<AddSlotSheet> {
  TimeOfDay _time = const TimeOfDay(hour: 9, minute: 0);
  bool _isCreating = false;

  Future<void> _createSlot() async {
    setState(() => _isCreating = true);

    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
      final formattedTime = _time.format(context); // e.g. "9:00 AM"

      const mutation = '''
        mutation CreateSlot(\$input: CreateAppointmentInput!) {
          createAppointment(input: \$input) {
            id
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        authorizationMode: APIAuthorizationType.userPools,
        variables: {
          'input': {
            'counselorID': widget.counselorId,
            'studentID': "0000", // Dummy ID required by Schema
            'date': formattedDate,
            'timeSlot': formattedTime,
            'status': "AVAILABLE", // ✅ Correct status
            'topic': 'Open Slot',
            'meetingLink': '',
            'counselorNotes': ''
          }
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${response.errors.first.message}")));
      } else {
        Navigator.pop(context); // Close sheet
      }
    } catch (e) {
      safePrint("Error creating slot: $e");
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      height: 300,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Add Availability", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Date: ${DateFormat('EEE, MMM d').format(widget.selectedDate)}", style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 30),

          InkWell(
            onTap: () async {
              final newTime = await showTimePicker(context: context, initialTime: _time);
              if (newTime != null) setState(() => _time = newTime);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Time: ${_time.format(context)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Icon(Icons.access_time, color: Color(0xFF3b5998)),
                ],
              ),
            ),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _isCreating ? null : _createSlot,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3b5998),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isCreating
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Add Slot", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
