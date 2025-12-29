import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:google_fonts/google_fonts.dart';

import '../counsellor/home/main_screen.dart';
import '../student/home/main_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final _nameController = TextEditingController();

  // Backend value: 'STUDENT' or 'COUNSELOR'
  String? _selectedRole;
  bool _isSaving = false;

  final Color _brandColor = const Color(0xFF3b5998);
  final Color _accentColor = const Color(0xFF1E293B);

  Future<void> _saveProfile() async {
    if (_selectedRole == null || _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter your name and select a role",
            style: GoogleFonts.plusJakartaSans(),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
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
            'role': _selectedRole, // Expected: 'STUDENT' or 'COUNSELOR'
          }
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.errors.isNotEmpty) {
        throw Exception(response.errors.first.message);
      }

      if (!mounted) return;

      _redirectByRole(_selectedRole!);
    } catch (e) {
      safePrint("Profile creation error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save profile: ${e.toString()}")),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _redirectByRole(String role) {
    late final Widget next;

    switch (role) {
      case 'COUNSELOR':
        next = const CounsellorMainScreen(); // Ensure this import is correct
        break;
      case 'STUDENT':
      default:
        next = const MainScreen(); // Ensure this import is correct
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // 1. Header Section
              Text(
                "Welcome to Synapse",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: _accentColor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Let's personalize your experience. Are you seeking help or offering guidance?",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey[600],
                  fontSize: 16,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // 2. Name Input
              Text(
                "What should we call you?",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: _accentColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nameController,
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: Colors.black87),
                decoration: InputDecoration(
                  hintText: "Enter your full name",
                  hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: _brandColor, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // 3. Role Selection
              Text(
                "I am a...",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: _accentColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildRoleCard(
                      label: "Student",
                      backendValue: "STUDENT",
                      icon: Icons.school_rounded,
                      description: "I need support",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildRoleCard(
                      label: "Counselor",
                      backendValue: "COUNSELOR",
                      icon: Icons.health_and_safety_rounded,
                      description: "I provide guidance",
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // 4. Continue Button
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brandColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    disabledBackgroundColor: _brandColor.withOpacity(0.6),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                      : Text(
                    "Continue",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String label,
    required String backendValue,
    required IconData icon,
    required String description,
  }) {
    final isSelected = _selectedRole == backendValue;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = backendValue;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 160,
        decoration: BoxDecoration(
          color: isSelected ? _brandColor.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _brandColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: _brandColor.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ]
              : [],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? _brandColor.withOpacity(0.1) : Colors.grey[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: isSelected ? _brandColor : Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected ? _brandColor : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: Colors.grey[500],
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // Checkmark Badge
            if (isSelected)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _brandColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
