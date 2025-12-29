import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CounselorHomeScreen extends StatelessWidget {
  const CounselorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Counselor Dashboard")),
      body: const Center(
        child: Text("Welcome Counselor"),
      ),
    );
  }
}
