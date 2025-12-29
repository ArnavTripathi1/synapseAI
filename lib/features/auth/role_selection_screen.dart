import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:google_fonts/google_fonts.dart';

import '../dashboard/screens/CounselorHomeScreen.dart';
import '../home/main_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final _nameController = TextEditingController();
  String? _selectedRole; // Used only for UI / routing
  bool _isSaving = false;

  Future<void> _saveProfile() async {
    if (_selectedRole == null || _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter name and select a role")),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = await Amplify.Auth.getCurrentUser();

      final request = GraphQLRequest<String>(
        document: '''
        mutation CreateUserProfile(\$input: CreateUserProfileInput!) {
          createUserProfile(input: \$input) {
            id
            role
          }
        }
      ''',
        variables: {
          'input': {
            'id': user.userId,
            'name': _nameController.text.trim(),
            'role': _selectedRole, // STUDENT or COUNSELOR
          }
        },
      );

      final response =
      await Amplify.API.mutate(request: request).response;

      if (response.errors.isNotEmpty) {
        throw Exception(response.errors.first.message);
      }

      if (!mounted) return;

      _redirectByRole(_selectedRole!);
    } catch (e) {
      safePrint("Profile creation error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save profile")),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _redirectByRole(String role) {
    late final Widget next;

    switch (role) {
      case 'COUNSELOR':
        next = const CounselorHomeScreen();
        break;
      case 'STUDENT':
      default:
        next = const MainScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => next),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Welcome!",
          style: GoogleFonts.plusJakartaSans(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Let's get you set up.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tell us who you are to personalize your experience.",
              style: GoogleFonts.plusJakartaSans(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Your Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "I am a...",
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildRoleCard("Student", Icons.school_outlined),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildRoleCard(
                    "Counselor",
                    Icons.health_and_safety_outlined,
                  ),
                ),
              ],
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  "Continue",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(String label, IconData icon) {
    final isSelected = _selectedRole == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = label;
        });
      },
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
