// Simple Placeholder for the All Requests Screen
import 'package:flutter/material.dart';

class AllRequestsScreen extends StatelessWidget {
  const AllRequestsScreen({super.key});

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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          RequestCard(name: "Vikram Malhotra", issue: "Depression", timeRequested: "Tomorrow, 4:00 PM"),
          RequestCard(name: "Sanya Gupta", issue: "Career Guidance", timeRequested: "Fri, 11:00 AM"),
          RequestCard(name: "Arjun Reddy", issue: "Anger Management", timeRequested: "Sat, 09:00 AM"),
          RequestCard(name: "Priya Paul", issue: "Grief Counselling", timeRequested: "Mon, 02:00 PM"),
        ],
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  final String name;
  final String issue;
  final String timeRequested;

  const RequestCard({
    super.key,
    required this.name,
    required this.issue,
    required this.timeRequested,
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
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blueGrey[50],
            child: Text(name[0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("$issue • $timeRequested", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Row(
            children: [
              _actionIcon(Icons.close, Colors.red),
              const SizedBox(width: 8),
              _actionIcon(Icons.check, Colors.green),
            ],
          )
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, MaterialColor color) {
    return InkWell(
      onTap: () {},
      child: CircleAvatar(
        radius: 16,
        backgroundColor: color[50],
        child: Icon(icon, size: 18, color: color[600]),
      ),
    );
  }
}
