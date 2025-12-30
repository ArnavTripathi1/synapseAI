import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isSaving = false;

  // IDs for updates
  String _userProfileId = "";
  String _counselorProfileId = "";

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _feeController = TextEditingController();
  final _aboutController = TextEditingController();
  final _licenseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _feeController.dispose();
    _aboutController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  // ==========================================
  // 🚀 BACKEND LOGIC: FETCH DATA
  // ==========================================

  Future<void> _fetchProfileData() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();

      // Query: Get Counselor Profile + Nested User Info
      const String query = '''
        query GetMyCounselorProfile(\$uid: ID!) {
          listCounselorProfiles(filter: { userProfileID: { eq: \$uid } }) {
            items {
              id
              specialization
              experienceYears
              fee
              aboutMe
              licenseNumber
              user {
                id
                name
                phoneNumber
              }
            }
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {'uid': user.userId},
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.data == null) {
        _showError("Failed to load profile.");
        return;
      }

      final data = jsonDecode(response.data!);
      final items = data['listCounselorProfiles']['items'] as List;

      if (items.isNotEmpty) {
        final profile = items[0];
        final userDetails = profile['user'];

        // Store IDs for later updates
        _counselorProfileId = profile['id'];
        _userProfileId = userDetails['id'];

        // Populate Fields
        if (mounted) {
          setState(() {
            _nameController.text = userDetails['name'] ?? "";
            _phoneController.text = userDetails['phoneNumber'] ?? "";

            _specializationController.text = profile['specialization'] ?? "";
            _experienceController.text = (profile['experienceYears'] ?? 0).toString();
            _feeController.text = (profile['fee'] ?? 0).toString();
            _aboutController.text = profile['aboutMe'] ?? "";
            _licenseController.text = profile['licenseNumber'] ?? "";

            _isLoading = false;
          });
        }
      } else {
        _showError("Profile not found.");
      }
    } catch (e) {
      safePrint("Fetch Error: $e");
      _showError("Error fetching data.");
    }
  }

  // ==========================================
  // 🚀 BACKEND LOGIC: UPDATE DATA
  // ==========================================

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // 1. Update User Profile (Name, Phone)
      const String updateUserMutation = '''
        mutation UpdateUser(\$id: ID!, \$name: String, \$phone: String) {
          updateUserProfile(input: { id: \$id, name: \$name, phoneNumber: \$phone }) {
            id
          }
        }
      ''';

      final userReq = GraphQLRequest<String>(
        document: updateUserMutation,
        variables: {
          'id': _userProfileId,
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
        },
        authorizationMode: APIAuthorizationType.userPools,
      );
      await Amplify.API.mutate(request: userReq).response;

      // 2. Update Counselor Profile (Professional Details)
      const String updateCounselorMutation = '''
        mutation UpdateCounselor(\$id: ID!, \$spec: String, \$exp: Int, \$fee: Float, \$about: String, \$lic: String) {
          updateCounselorProfile(input: { 
            id: \$id, 
            specialization: \$spec, 
            experienceYears: \$exp, 
            fee: \$fee, 
            aboutMe: \$about, 
            licenseNumber: \$lic 
          }) {
            id
          }
        }
      ''';

      final counselorReq = GraphQLRequest<String>(
        document: updateCounselorMutation,
        variables: {
          'id': _counselorProfileId,
          'spec': _specializationController.text.trim(),
          'exp': int.tryParse(_experienceController.text) ?? 0,
          'fee': double.tryParse(_feeController.text) ?? 0.0,
          'about': _aboutController.text.trim(),
          'lic': _licenseController.text.trim(),
        },
        authorizationMode: APIAuthorizationType.userPools,
      );

      final res = await Amplify.API.mutate(request: counselorReq).response;

      if (res.hasErrors) {
        _showError("Failed to save changes: ${res.errors.first.message}");
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile Updated Successfully!"), backgroundColor: Colors.green),
          );
          Navigator.pop(context); // Go back
        }
      }

    } catch (e) {
      safePrint("Update Error: $e");
      _showError("An error occurred while saving.");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String msg) {
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    }
  }

  // Helper method to extract initials
  String _getInitials(String name) {
    String cleanName = name.replaceAll(RegExp(r'^(Dr\.|Mr\.|Mrs\.|Ms\.|Er\.)\s+', caseSensitive: false), '').trim();
    if (cleanName.isEmpty) return "";
    List<String> nameParts = cleanName.split(RegExp(r'\s+'));
    if (nameParts.isEmpty) return "";
    String first = nameParts.first[0].toUpperCase();
    if (nameParts.length > 1) {
      return "$first${nameParts.last[0].toUpperCase()}";
    }
    return first;
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          _isSaving
              ? const Center(child: Padding(padding: EdgeInsets.only(right: 16), child: CircularProgressIndicator(strokeWidth: 2)))
              : TextButton(
            onPressed: _saveProfile,
            child: const Text(
              "Save",
              style: TextStyle(color: Color(0xFF3b5998), fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 1. Profile Picture (Initials)
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[200]!, width: 4),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFF3b5998),
                        child: Text(
                          _getInitials(_nameController.text),
                          style: const TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image Upload feature coming soon!")));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF3b5998),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 2. Personal Info
              _buildSectionTitle("Personal Information"),
              _buildTextField("Full Name", _nameController, Icons.person_outline),
              _buildTextField("Phone Number", _phoneController, Icons.phone_outlined, inputType: TextInputType.phone),

              const SizedBox(height: 20),

              // 3. Professional Info
              _buildSectionTitle("Professional Details"),
              _buildTextField("Specialization", _specializationController, Icons.work_outline),
              _buildTextField("License Number", _licenseController, Icons.badge_outlined),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField("Experience (Yrs)", _experienceController, Icons.history, inputType: TextInputType.number),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField("Fee (₹/hr)", _feeController, Icons.currency_rupee, inputType: TextInputType.number),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 4. Bio Section
              _buildSectionTitle("About Me"),
              TextFormField(
                controller: _aboutController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Write a short bio about your methodology...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3b5998))),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3b5998))),
          filled: true,
          fillColor: Colors.grey[50],
          isDense: true,
        ),
      ),
    );
  }
}
