import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:synapse/features/counsellor/resources/upload_resource_screen.dart';

// Import your viewer screens (Adjust paths as needed)
import '../../student/resources/screens/article_reading_screen.dart';
import '../../student/resources/screens/video_player_screen.dart';

class MyUploadedResourcesScreen extends StatefulWidget {
  const MyUploadedResourcesScreen({super.key});

  @override
  State<MyUploadedResourcesScreen> createState() => _MyUploadedResourcesScreenState();
}

class _MyUploadedResourcesScreenState extends State<MyUploadedResourcesScreen> {
  bool _isLoading = true;
  List<dynamic> _myResources = [];
  final Color _primaryColor = const Color(0xFF3b5998);

  // Updated Query to fetch ALL details needed for viewing/editing
  final String listResourcesQuery = '''
    query ListResources {
      listResources {
        items {
          id
          title
          type
          category
          counselorID
          createdAt
          url
          headerImage
          description
          duration
        }
      }
    }
  ''';

  final String deleteResourceMutation = '''
    mutation DeleteResource(\$id: ID!) {
      deleteResource(input: {id: \$id}) { id }
    }
  ''';

  final String updateResourceMutation = '''
    mutation UpdateResource(\$id: ID!, \$title: String, \$category: String, \$description: String) {
      updateResource(input: {id: \$id, title: \$title, category: \$category, description: \$description}) {
        id title category description
      }
    }
  ''';

  @override
  void initState() {
    super.initState();
    _fetchMyResources();
  }

  // --- DATA FETCHING ---
  Future<void> _fetchMyResources() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      String myId = user.userId;

      final request = GraphQLRequest<String>(document: listResourcesQuery);
      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final Map<String, dynamic> data = jsonDecode(response.data!);
        final List<dynamic> allItems = data['listResources']['items'];

        final myItems = allItems.where((item) => item['counselorID'] == myId).toList();
        myItems.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));

        if (mounted) {
          setState(() {
            _myResources = myItems;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  // --- HELPER: GET S3 URL ---
  Future<String> _getS3Url(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(
        path: StoragePath.fromString(key),
        options: const StorageGetUrlOptions(
          pluginOptions: S3GetUrlPluginOptions(expiresIn: Duration(hours: 1)),
        ),
      ).result;
      return result.url.toString();
    } catch (e) {
      debugPrint("S3 Error: $e");
      return "";
    }
  }

  // --- ACTION 1: VIEW RESOURCE ---
  Future<void> _viewResource(Map<String, dynamic> item) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final contentUrl = await _getS3Url(item['url']);

      if (!mounted) return;
      Navigator.pop(context); // Dismiss loading

      if (item['type'] == 'VIDEO') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerScreen(
              videoUrl: contentUrl,
              title: item['title'],
              description: item['description'] ?? "",
            ),
          ),
        );
      } else {
        // Fetch Article Content
        final response = await http.get(Uri.parse(contentUrl));
        final markdownContent = response.body;

        // Get Header Image
        String headerImageUrl = "https://img.freepik.com/free-vector/organic-flat-people-meditating-illustration_23-2148906556.jpg";
        if (item['headerImage'] != null) {
          headerImageUrl = await _getS3Url(item['headerImage']);
        }

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleDetailScreen(
              counselorId: item['counselorID'],
              title: item['title'],
              category: item['category'],
              readTime: item['duration'] ?? "5 min read",
              imageUrl: headerImageUrl,
              content: markdownContent,
            ),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Dismiss loading
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error opening resource: $e")));
    }
  }

  // --- ACTION 2: EDIT RESOURCE (Metadata only) ---
  void _showEditDialog(Map<String, dynamic> item, int index) {
    final titleController = TextEditingController(text: item['title']);
    final categoryController = TextEditingController(text: item['category']);
    final descController = TextEditingController(text: item['description']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Resource", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: "Category", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _updateResource(item['id'], index, titleController.text, categoryController.text, descController.text);
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _updateResource(String id, int index, String newTitle, String newCategory, String newDesc) async {
    try {
      final request = GraphQLRequest<String>(
        document: updateResourceMutation,
        variables: {
          "id": id,
          "title": newTitle,
          "category": newCategory,
          "description": newDesc
        },
      );

      final response = await Amplify.API.mutate(request: request).response;
      if (response.hasErrors) throw Exception("Update failed");

      // Local Update
      setState(() {
        _myResources[index]['title'] = newTitle;
        _myResources[index]['category'] = newCategory;
        _myResources[index]['description'] = newDesc;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Resource updated successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update failed: $e")));
    }
  }

  // --- ACTION 3: DELETE RESOURCE ---
  void _confirmDelete(String id, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Resource?"),
        content: const Text("Are you sure you want to delete this? This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteResource(id, index);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteResource(String id, int index) async {
    final deletedItem = _myResources[index];
    setState(() => _myResources.removeAt(index)); // Optimistic UI

    try {
      final request = GraphQLRequest<String>(
        document: deleteResourceMutation,
        variables: {"id": id},
      );
      final res = await Amplify.API.mutate(request: request).response;
      if (res.hasErrors) throw Exception("GraphQL Error");

      // Note: Ideally, you should also call Amplify.Storage.remove(key: url) here

    } catch (e) {
      setState(() => _myResources.insert(index, deletedItem)); // Revert
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to delete resource")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("My Resources", style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadResourceWizard()));
          _fetchMyResources();
        },
        backgroundColor: _primaryColor,
        icon: const Icon(Icons.add),
        label: const Text("Upload New"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _myResources.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: _fetchMyResources,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: _myResources.length,
          itemBuilder: (context, index) {
            final item = _myResources[index];
            return _buildResourceCard(item, index);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("No uploads yet", style: GoogleFonts.plusJakartaSans(color: Colors.grey[500], fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildResourceCard(Map<String, dynamic> item, int index) {
    final isVideo = item['type'] == 'VIDEO';
    final dateStr = item['createdAt'].toString().substring(0, 10);

    return InkWell(
      onTap: () => _viewResource(item), // View on tap
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            // ICON
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isVideo ? Colors.red.withOpacity(0.1) : _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isVideo ? Icons.play_circle_outline : Icons.article_outlined,
                color: isVideo ? Colors.red : _primaryColor,
              ),
            ),
            const SizedBox(width: 16),

            // DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${item['category']} • $dateStr",
                    style: GoogleFonts.plusJakartaSans(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),

            // ACTION MENU (Edit/Delete)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'view') _viewResource(item);
                if (value == 'edit') _showEditDialog(item, index);
                if (value == 'delete') _confirmDelete(item['id'], index);
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(value: 'view', child: ListTile(leading: Icon(Icons.visibility, size: 20), title: Text('View'), dense: true)),
                const PopupMenuItem<String>(value: 'edit', child: ListTile(leading: Icon(Icons.edit, size: 20), title: Text('Edit'), dense: true)),
                const PopupMenuItem<String>(value: 'delete', child: ListTile(leading: Icon(Icons.delete, color: Colors.red, size: 20), title: Text('Delete', style: TextStyle(color: Colors.red)), dense: true)),
              ],
              icon: const Icon(Icons.more_vert, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
