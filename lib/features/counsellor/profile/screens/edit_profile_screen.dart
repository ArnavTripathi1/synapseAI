import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _specializationController;
  late TextEditingController _experienceController;
  late TextEditingController _feeController;
  late TextEditingController _aboutController;
  late TextEditingController _licenseController;

  @override
  void initState() {
    super.initState();
    // Pre-fill with mock data
    _nameController = TextEditingController(text: "Dr. Yashendra Sharma");
    _phoneController = TextEditingController(text: "+91 98765 43210");
    _specializationController = TextEditingController(text: "Clinical Psychologist");
    _experienceController = TextEditingController(text: "8");
    _feeController = TextEditingController(text: "500");
    _aboutController = TextEditingController(
      text: "I specialize in helping students manage academic stress and anxiety. I believe in a holistic approach to mental health...",
    );
    _licenseController = TextEditingController(text: "RCI-2023-8992");
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

  // Helper method to extract initials dynamically
  String _getInitials(String name) {
    // Optional: Remove common titles if included in the name field
    String cleanName = name.replaceAll(RegExp(r'^(Dr\.|Mr\.|Mrs\.|Ms\.|Er\.)\s+', caseSensitive: false), '').trim();

    if (cleanName.isEmpty) return "";
    List<String> nameParts = cleanName.split(RegExp(r'\s+'));

    if (nameParts.isEmpty) return "";

    String firstInitial = nameParts.first[0].toUpperCase();

    if (nameParts.length > 1) {
      String lastInitial = nameParts.last[0].toUpperCase();
      return "$firstInitial$lastInitial";
    }

    return firstInitial;
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Updated Successfully"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              "Save",
              style: TextStyle(
                color: Color(0xFF3b5998),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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
              // 1. Profile Picture Changer
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[200]!, width: 4),
                      ),
                      // AnimatedBuilder listens to changes in the controller
                      child: AnimatedBuilder(
                        animation: _nameController,
                        builder: (context, child) {
                          return CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color(0xFF3b5998),
                            child: Text(
                              _getInitials(_nameController.text),
                              style: const TextStyle(fontSize: 30, color: Colors.white),
                            ),
                            // backgroundImage: NetworkImage('...'),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          _showImagePickerOptions();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF3b5998),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 2. Personal Info Section
              _buildSectionTitle("Personal Information"),
              _buildTextField(
                "Full Name",
                _nameController,
                Icons.person_outline,
              ),
              _buildTextField(
                "Phone Number",
                _phoneController,
                Icons.phone_outlined,
                inputType: TextInputType.phone,
              ),

              const SizedBox(height: 20),

              // 3. Professional Info Section
              _buildSectionTitle("Professional Details"),
              _buildTextField(
                "Specialization",
                _specializationController,
                Icons.work_outline,
              ),
              _buildTextField(
                "License Number",
                _licenseController,
                Icons.badge_outlined,
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      "Experience (Yrs)",
                      _experienceController,
                      Icons.history,
                      inputType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      "Fee (₹/hr)",
                      _feeController,
                      Icons.currency_rupee,
                      inputType: TextInputType.number,
                    ),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF3b5998)),
                  ),
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
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      IconData icon, {
        TextInputType inputType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Required';
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3b5998)),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          isDense: true,
        ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Update Profile Picture",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF3b5998)),
                title: const Text("Take Photo"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xFF3b5998),
                ),
                title: const Text("Choose from Gallery"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
