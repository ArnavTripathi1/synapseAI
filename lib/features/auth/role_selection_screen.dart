import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

// ✅ NAVIGATION IMPORTS
// Adjust these paths to match your project structure
import 'package:synapse/features/counsellor/home/main_screen.dart';

import '../student/home/main_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isSaving = false;

  // --- STEP 1 DATA ---
  final _nameController = TextEditingController();
  String? _selectedRole; // 'STUDENT' or 'COUNSELOR'

  // --- STEP 2 DATA (STUDENT) ---
  final _branchController = TextEditingController();
  String _selectedYear = "1st Year";
  final List<String> _years = [
    "1st Year", "2nd Year", "3rd Year", "4th Year", "PhD"
  ];

  // --- STEP 2 DATA (COUNSELOR) ---
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _aboutMeController = TextEditingController();

  // --- SHARED DATA ---
  final _phoneController = TextEditingController();

  // --- COLORS ---
  final Color _brandColor = const Color(0xFF3b5998);
  final Color _accentColor = const Color(0xFF1E293B);

  // ==========================================
  // ⚡ LOGIC: NAVIGATION & SUBMISSION
  // ==========================================

  void _nextStep() {
    if (_currentStep == 0) {
      // Validate Step 1
      if (_nameController.text.trim().isEmpty || _selectedRole == null) {
        _showError("Please enter your name and select a role.");
        return;
      }
      // Move to Step 2
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep = 1);
    } else {
      // Validate Step 2 & Submit
      _submitFullProfile();
    }
  }

  void _goBack() {
    if (_currentStep == 1) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep = 0);
    }
  }

  // ==========================================
  // 🛡️ ROBUST SUBMISSION LOGIC (PREVENTS DUPLICATES)
  // ==========================================

  Future<void> _submitFullProfile() async {
    // 1. Validate UI Inputs
    if (_selectedRole == 'STUDENT') {
      if (_branchController.text.isEmpty) {
        _showError("Please enter your branch.");
        return;
      }
    } else {
      if (_specializationController.text.isEmpty ||
          _experienceController.text.isEmpty) {
        _showError("Please fill in your professional details.");
        return;
      }
    }

    setState(() => _isSaving = true);

    try {
      final user = await Amplify.Auth.getCurrentUser();
      final userId = user.userId;

      // -----------------------------------------------------------
      // STEP 1: Handle UserProfile (Check before Create)
      // -----------------------------------------------------------
      final userExists = await _doesUserProfileExist(userId);

      if (!userExists) {
        await _createUserProfile(userId);
      } else {
        safePrint("DEBUG: User Profile already exists. Skipping create.");
      }

      // -----------------------------------------------------------
      // STEP 2: Handle Role Profile (Prevent Duplicates)
      // -----------------------------------------------------------
      if (_selectedRole == 'STUDENT') {
        final studentExists = await _doesStudentProfileExist(userId);
        if (!studentExists) {
          await _createStudentProfile(userId);
        } else {
          safePrint("DEBUG: Student Profile already exists. Skipping create.");
        }
      } else {
        // COUNSELOR
        final counselorExists = await _doesCounselorProfileExist(userId);
        if (!counselorExists) {
          await _createCounselorProfile(userId);
        } else {
          safePrint("DEBUG: Counselor Profile already exists. Skipping create.");
        }
      }

      // -----------------------------------------------------------
      // STEP 3: Success! Redirect
      // -----------------------------------------------------------
      if (!mounted) return;
      _redirectByRole(_selectedRole!);

    } catch (e) {
      safePrint("Setup Error: $e");
      _showError("An error occurred: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  void _redirectByRole(String role) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => role == 'COUNSELOR'
            ? const CounsellorMainScreen()
            : const MainScreen(), // Student Home
      ),
          (route) => false,
    );
  }

  // ==========================================
  // 🔍 EXISTENCE CHECKS
  // ==========================================

  Future<bool> _doesUserProfileExist(String userId) async {
    const query = 'query GetUser(\$id: ID!) { getUserProfile(id: \$id) { id } }';
    final req = GraphQLRequest<String>(
        document: query,
        variables: {'id': userId},
        authorizationMode: APIAuthorizationType.userPools
    );
    final res = await Amplify.API.query(request: req).response;
    if (res.data != null) {
      final data = jsonDecode(res.data!);
      return data['getUserProfile'] != null;
    }
    return false;
  }

  Future<bool> _doesCounselorProfileExist(String userId) async {
    const query = '''
      query CheckCounselor(\$uid: ID!) {
        listCounselorProfiles(filter: { userProfileID: { eq: \$uid } }) {
          items { id }
        }
      }
    ''';
    final req = GraphQLRequest<String>(
        document: query,
        variables: {'uid': userId},
        authorizationMode: APIAuthorizationType.userPools
    );
    final res = await Amplify.API.query(request: req).response;
    if (res.data != null) {
      final data = jsonDecode(res.data!);
      final items = data['listCounselorProfiles']['items'] as List;
      return items.isNotEmpty;
    }
    return false;
  }

  Future<bool> _doesStudentProfileExist(String userId) async {
    const query = '''
      query CheckStudent(\$uid: ID!) {
        listStudentProfiles(filter: { userProfileID: { eq: \$uid } }) {
          items { id }
        }
      }
    ''';
    final req = GraphQLRequest<String>(
        document: query,
        variables: {'uid': userId},
        authorizationMode: APIAuthorizationType.userPools
    );
    final res = await Amplify.API.query(request: req).response;
    if (res.data != null) {
      final data = jsonDecode(res.data!);
      final items = data['listStudentProfiles']['items'] as List;
      return items.isNotEmpty;
    }
    return false;
  }

  // ==========================================
  // 🚀 CREATION MUTATIONS
  // ==========================================

  Future<void> _createUserProfile(String userId) async {
    const mutation = '''
      mutation CreateUserProfile(\$input: CreateUserProfileInput!) {
        createUserProfile(input: \$input) { id }
      }
    ''';

    final req = GraphQLRequest<String>(
      document: mutation,
      authorizationMode: APIAuthorizationType.userPools,
      variables: {
        'input': {
          'id': userId,
          'name': _nameController.text.trim(),
          'role': _selectedRole,
          'phoneNumber': _phoneController.text.trim(),
        },
      },
    );
    final res = await Amplify.API.mutate(request: req).response;
    if (res.hasErrors) throw Exception(res.errors.first.message);
  }

  Future<void> _createStudentProfile(String userId) async {
    const mutation = '''
      mutation CreateStudentProfile(\$input: CreateStudentProfileInput!) {
        createStudentProfile(input: \$input) { id }
      }
    ''';

    final req = GraphQLRequest<String>(
      document: mutation,
      authorizationMode: APIAuthorizationType.userPools,
      variables: {
        'input': {
          'userProfileID': userId,
          'branch': _branchController.text.trim(),
          'year': _selectedYear,
          'wellnessScore': 75,
          'currentMood': "Good",
        },
      },
    );
    final res = await Amplify.API.mutate(request: req).response;
    if (res.hasErrors) throw Exception(res.errors.first.message);
  }

  Future<void> _createCounselorProfile(String userId) async {
    const mutation = '''
      mutation CreateCounselorProfile(\$input: CreateCounselorProfileInput!) {
        createCounselorProfile(input: \$input) { id }
      }
    ''';

    final req = GraphQLRequest<String>(
      document: mutation,
      authorizationMode: APIAuthorizationType.userPools,
      variables: {
        'input': {
          'userProfileID': userId,
          'specialization': _specializationController.text.trim(),
          'experienceYears': int.tryParse(_experienceController.text) ?? 0,
          'aboutMe': _aboutMeController.text.trim(),
          'rating': 5.0,
          'isOnline': true,
          'isVerified': false,
          'fee': 0.0,
        },
      },
    );
    final res = await Amplify.API.mutate(request: req).response;
    if (res.hasErrors) throw Exception(res.errors.first.message);
  }

  // ==========================================
  // 🎨 UI BUILDER
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _currentStep == 1
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _goBack,
        )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(child: _buildProgressDot(isActive: true)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildProgressDot(isActive: _currentStep == 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Page View
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe
                children: [
                  _buildStep1(), // Role & Name
                  _buildStep2(), // Specific Details
                ],
              ),
            ),

            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brandColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    _currentStep == 0 ? "Continue" : "Complete Setup",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressDot({required bool isActive}) {
    return AnimatedContainer(
      duration: 300.ms,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? _brandColor : Colors.grey[200],
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  // --- STEP 1: BASIC INFO ---
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to Synapse",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: _accentColor,
              letterSpacing: -0.5,
            ),
          ).animate().fadeIn().slideY(begin: 0.2, end: 0),
          const SizedBox(height: 8),
          Text(
            "Let's get you set up. Who are you?",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 32),

          _buildLabel("Full Name"),
          _buildTextField(controller: _nameController, hint: "Enter your name"),

          const SizedBox(height: 24),
          _buildLabel("I am a..."),
          Row(
            children: [
              Expanded(
                child: _buildRoleCard(
                  label: "Student",
                  value: "STUDENT",
                  icon: Icons.school_rounded,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildRoleCard(
                  label: "Counselor",
                  value: "COUNSELOR",
                  icon: Icons.health_and_safety_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- STEP 2: SPECIFIC DETAILS ---
  Widget _buildStep2() {
    final isStudent = _selectedRole == 'STUDENT';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isStudent ? "Academic Details" : "Professional Details",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _accentColor,
            ),
          ).animate().fadeIn().slideX(),
          const SizedBox(height: 8),
          Text(
            "Help us customize your dashboard.",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),

          _buildLabel("Phone Number"),
          _buildTextField(
            controller: _phoneController,
            hint: "+91 98765 43210",
            isPhone: true,
          ),
          const SizedBox(height: 24),

          if (isStudent) ...[
            _buildLabel("Branch / Major"),
            _buildTextField(
              controller: _branchController,
              hint: "e.g. Computer Science",
            ),
            const SizedBox(height: 24),
            _buildLabel("Current Year"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedYear,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: _years.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: GoogleFonts.plusJakartaSans()),
                    );
                  }).toList(),
                  onChanged: (newValue) =>
                      setState(() => _selectedYear = newValue!),
                ),
              ),
            ),
          ] else ...[
            _buildLabel("Specialization"),
            _buildTextField(
              controller: _specializationController,
              hint: "e.g. Clinical Psychologist",
            ),
            const SizedBox(height: 24),
            _buildLabel("Years of Experience"),
            _buildTextField(
              controller: _experienceController,
              hint: "e.g. 5",
              isNumber: true,
            ),
            const SizedBox(height: 24),
            _buildLabel("About Me"),
            _buildTextField(
              controller: _aboutMeController,
              hint: "Short bio...",
              maxLines: 3,
            ),
          ],
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          color: _accentColor,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPhone = false,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isPhone
          ? TextInputType.phone
          : (isNumber ? TextInputType.number : TextInputType.text),
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _brandColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = value),
      child: AnimatedContainer(
        duration: 200.ms,
        height: 120,
        decoration: BoxDecoration(
          color: isSelected ? _brandColor.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _brandColor : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? _brandColor : Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                color: isSelected ? _brandColor : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
