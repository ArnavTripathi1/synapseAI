import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:synapse/features/counsellor/profile/screens/edit_profile_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  // --- State Variables ---
  bool _isLoading = true;
  String _name = "Loading...";
  String _specialization = "Specialist";
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  // ==========================================
  // 🚀 BACKEND LOGIC
  // ==========================================

  Future<void> _fetchProfileData() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();

      // Query: Find Counselor Profile via User ID
      const String query = '''
        query GetMyCounselorProfile(\$uid: ID!) {
          listCounselorProfiles(filter: { userProfileID: { eq: \$uid } }) {
            items {
              specialization
              isVerified
              user {
                name
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
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final data = jsonDecode(response.data!);
      final items = data['listCounselorProfiles']['items'] as List;

      if (items.isNotEmpty) {
        final profile = items[0];
        final userDetails = profile['user'];

        if (mounted) {
          setState(() {
            _name = userDetails != null ? userDetails['name'] : "Doctor";
            _specialization = profile['specialization'] ?? "Specialist";
            _isVerified = profile['isVerified'] ?? false;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      safePrint("Error fetching profile: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    try {
      await Amplify.Auth.signOut();
      // The Authenticator in main.dart handles the redirection automatically
    } catch (e) {
      safePrint("Error signing out: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error signing out. Please try again.")),
        );
      }
    }
  }

  // --- Helper: Get Initials ---
  String _getInitials(String name) {
    if (name.isEmpty) return "";
    List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return "";
    String first = parts.first[0].toUpperCase();
    if (parts.length > 1) {
      return "$first${parts.last[0].toUpperCase()}";
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
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF3b5998),
                    child: Text(
                      _getInitials(_name),
                      style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Text Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dr. $_name", // Assuming "Dr." prefix
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _specialization,
                          style: TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        if (_isVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Verified Profile",
                              style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Settings
            _buildSettingsSection(
              "Account Settings",
              [
                _buildListTile(Icons.person_outline, "Edit Profile", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfileScreen())
                  ).then((_) => _fetchProfileData()); // Refresh on back
                }),
                _buildListTile(Icons.notifications_outlined, "Notifications", () {}),
                _buildListTile(Icons.lock_outline, "Privacy & Security", () {}),
              ],
            ),

            _buildSettingsSection(
              "Support",
              [
                _buildListTile(Icons.help_outline, "Help & Support", () {}),
                _buildListTile(Icons.info_outline, "Terms & Conditions", () {}),
              ],
            ),

            const SizedBox(height: 20),

            // Log Out Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: _signOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Log Out", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(children: tiles),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Colors.grey[700], size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
