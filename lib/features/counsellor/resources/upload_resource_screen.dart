import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart'; // Ensure you have this dependency or remove FadeInUp
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

class UploadResourceWizard extends StatefulWidget {
  const UploadResourceWizard({super.key});

  @override
  State<UploadResourceWizard> createState() => _UploadResourceWizardState();
}

class _UploadResourceWizardState extends State<UploadResourceWizard> {
  // --- THEME COLORS (Matches Dashboard) ---
  final Color _primaryColor = const Color(0xFF3b5998);
  final Color _backgroundColor = const Color(0xFFF8FAFC);
  final Color _textDark = const Color(0xFF1E293B);

  int _currentStep = 0;
  String _selectedType = "Article";

  // Controllers
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _categoryController = TextEditingController(text: "General");

  // State Variables
  String? _mainFileName;
  PlatformFile? _mainPickedFile; // Video File

  String? _imageFileName;
  PlatformFile? _imagePickedFile; // Header Image

  bool _isUploading = false;

  // --- MUTATION ---
  final String createResourceMutation = '''
    mutation CreateResource(\$input: CreateResourceInput!) {
      createResource(input: \$input) {
        id
        title
        headerImage
      }
    }
  ''';

  // --- FILE PICKERS ---

  Future<void> _pickMainFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _mainPickedFile = result.files.first;
        _mainFileName = result.files.first.name;
      });
    }
  }

  Future<void> _pickImageFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _imagePickedFile = result.files.first;
        _imageFileName = result.files.first.name;
      });
    }
  }

  // --- UPLOAD LOGIC ---
  Future<void> _handleUpload() async {
    if (_titleController.text.isEmpty) {
      _showSnack("Please enter a title");
      return;
    }
    if (_selectedType == "Video" && _mainPickedFile == null) {
      _showSnack("Please select a video file");
      return;
    }
    if (_imagePickedFile == null) {
      _showSnack("Please select a header image");
      return;
    }

    setState(() => _isUploading = true);

    try {
      final user = await Amplify.Auth.getCurrentUser();
      String counselorID = user.userId;
      int timestamp = DateTime.now().millisecondsSinceEpoch;

      String mainS3Path = "";
      String imageS3Path = "";
      String finalDuration = "";

      // A. Upload Header Image
      final imgFile = File(_imagePickedFile!.path!);
      imageS3Path = "public/images/${timestamp}_header.jpg";

      await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(imgFile.path),
        path: StoragePath.fromString(imageS3Path),
        options: const StorageUploadFileOptions(
          metadata: {'Content-Type': 'image/jpeg'},
        ),
      ).result;

      // B. Upload Main Content
      if (_selectedType == "Video") {
        final vidFile = File(_mainPickedFile!.path!);
        mainS3Path = "public/videos/${timestamp}_${_mainFileName}";
        finalDuration = "5 min"; // Placeholder

        await Amplify.Storage.uploadFile(
          localFile: AWSFile.fromPath(vidFile.path),
          path: StoragePath.fromString(mainS3Path),
          options: const StorageUploadFileOptions(
            metadata: {'Content-Type': 'video/mp4'},
          ),
        ).result;
      } else {
        // Generate Markdown for Article
        final tempDir = await getTemporaryDirectory();
        final cleanTitle = _titleController.text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
        final mdFile = File('${tempDir.path}/${cleanTitle}_$timestamp.md');

        await mdFile.writeAsString("# ${_titleController.text}\n\n${_contentController.text}");

        mainS3Path = "public/articles/${cleanTitle}_$timestamp.md";
        int wordCount = _contentController.text.split(" ").length;
        finalDuration = "${(wordCount / 200).ceil()} min read";

        await Amplify.Storage.uploadFile(
          localFile: AWSFile.fromPath(mdFile.path),
          path: StoragePath.fromString(mainS3Path),
        ).result;
      }

      // C. Save to DynamoDB
      final resourceInput = {
        "title": _titleController.text,
        "type": _selectedType.toUpperCase(),
        "category": _categoryController.text,
        "counselorID": counselorID,
        "url": mainS3Path,
        "headerImage": imageS3Path,
        "description": "Uploaded via Counselor Dashboard",
        "duration": finalDuration,
        "isFeatured": false,
      };

      final request = GraphQLRequest<String>(
        document: createResourceMutation,
        variables: {"input": resourceInput},
      );

      final response = await Amplify.API.mutate(request: request).response;
      if (response.hasErrors) throw Exception(response.errors.first.message);

      if (mounted) {
        setState(() => _isUploading = false);
        _showSuccessDialog();
      }
    } catch (e) {
      debugPrint("Upload Error: $e");
      setState(() => _isUploading = false);
      _showSnack("Error: $e");
    }
  }

  void _showSnack(String msg) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Success!", style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Your resource has been published.", textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close Dialog
              Navigator.pop(context); // Close Screen
            },
            child: Text("Done", style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          "Upload Resource",
          style: GoogleFonts.plusJakartaSans(color: _textDark, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 1. VISUAL STEPPER
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepCircle(0, "Type"),
                _buildStepLine(0),
                _buildStepCircle(1, "Details"),
                _buildStepLine(1),
                _buildStepCircle(2, "Review"),
              ],
            ),
          ),

          // 2. MAIN CONTENT
          Expanded(
            child: FadeInUp(
              key: ValueKey(_currentStep),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildStepContent(),
              ),
            ),
          ),

          // 3. BOTTOM BUTTONS
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  TextButton(
                    onPressed: _isUploading ? null : () => setState(() => _currentStep--),
                    child: Text("Back", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600)),
                  )
                else
                  const SizedBox(),

                ElevatedButton(
                  onPressed: _isUploading
                      ? null
                      : () => _currentStep < 2
                      ? setState(() => _currentStep++)
                      : _handleUpload(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: _isUploading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(_currentStep == 2 ? "Publish" : "Next", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0: return _buildTypeStep();
      case 1: return _buildDetailsStep();
      case 2: return _buildReviewStep();
      default: return const SizedBox();
    }
  }

  // STEP 1: TYPE SELECTION
  Widget _buildTypeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What are you sharing?", style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark)),
        const SizedBox(height: 8),
        Text("Choose the format of your resource.", style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
        const SizedBox(height: 24),

        _buildTypeCard("Article", Icons.article_outlined, "Share knowledge via text reading"),
        const SizedBox(height: 16),
        _buildTypeCard("Video", Icons.play_circle_outline, "Upload a video session or guide"),
      ],
    );
  }

  Widget _buildTypeCard(String type, IconData icon, String desc) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? _primaryColor : Colors.grey[200]!, width: isSelected ? 2 : 1),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: isSelected ? _primaryColor : Colors.grey[100], borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: isSelected ? Colors.white : Colors.grey[500]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                  Text(desc, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: _primaryColor),
          ],
        ),
      ),
    );
  }

  // STEP 2: DETAILS FORM
  Widget _buildDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Resource Details", style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark)),
        const SizedBox(height: 24),

        _buildLabel("Title"),
        _buildTextField(_titleController, "e.g., Coping with Stress"),

        const SizedBox(height: 20),
        _buildLabel("Category"),
        _buildTextField(_categoryController, "e.g., Anxiety"),

        const SizedBox(height: 20),
        _buildLabel("Cover Image"),
        GestureDetector(
          onTap: _pickImageFile,
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
            ),
            child: _imagePickedFile != null
                ? ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.file(File(_imagePickedFile!.path!), fit: BoxFit.cover))
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate_outlined, size: 40, color: _primaryColor.withOpacity(0.5)),
                const SizedBox(height: 8),
                Text("Tap to upload cover", style: GoogleFonts.plusJakartaSans(color: Colors.grey[600], fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
        _buildLabel(_selectedType == "Article" ? "Article Content" : "Video File"),
        if (_selectedType == "Article")
          _buildTextField(_contentController, "Write or paste content here...", maxLines: 8)
        else
          GestureDetector(
            onTap: _pickMainFile,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.video_file, color: _primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _mainFileName ?? "Select MP4 File",
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, color: _mainFileName != null ? Colors.black : Colors.grey),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.upload_file, color: Colors.grey),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // STEP 3: REVIEW
  Widget _buildReviewStep() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Column(
            children: [
              Text("Ready to Publish?", style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.bold, color: _textDark)),
              const SizedBox(height: 8),
              Text("Review your details below.", style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
              const Divider(height: 40),

              _buildReviewRow("Type", _selectedType),
              const SizedBox(height: 16),
              _buildReviewRow("Title", _titleController.text),
              const SizedBox(height: 16),
              _buildReviewRow("Category", _categoryController.text),
              const SizedBox(height: 16),
              _buildReviewRow("Content", _selectedType == "Video" ? (_mainFileName ?? "No File") : "Text Content"),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Cover Image", style: GoogleFonts.plusJakartaSans(color: Colors.grey[600])),
                  Icon(_imagePickedFile != null ? Icons.check_circle : Icons.error, color: _imagePickedFile != null ? Colors.green : Colors.red, size: 20),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // --- HELPER COMPONENTS ---

  Widget _buildStepCircle(int index, String label) {
    final isActive = _currentStep >= index;
    return Column(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: isActive ? _primaryColor : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              "${index + 1}",
              style: GoogleFonts.plusJakartaSans(color: isActive ? Colors.white : Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: isActive ? _primaryColor : Colors.grey)),
      ],
    );
  }

  Widget _buildStepLine(int index) {
    return Container(
      width: 40, height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      color: _currentStep > index ? _primaryColor : Colors.grey[200],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: _textDark, fontSize: 14)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.plusJakartaSans(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _primaryColor, width: 1.5)),
      ),
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(color: Colors.grey[600])),
        const SizedBox(width: 20),
        Expanded(child: Text(value, textAlign: TextAlign.end, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: _textDark))),
      ],
    );
  }
}
