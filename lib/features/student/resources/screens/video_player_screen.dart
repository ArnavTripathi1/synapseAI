import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl; // Can be a YouTube link OR an S3 Key (public/videos/...)
  final String title;
  final String description;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.description,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  // Player Controllers
  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  bool _isYouTube = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // 1. Check if it is YouTube
      if (widget.videoUrl.contains('youtube.com') || widget.videoUrl.contains('youtu.be')) {
        _initializeYoutube();
      } else {
        // 2. It is an S3 file (either full URL or Key)
        await _initializeS3Video();
      }
    } catch (e) {
      debugPrint("Video Init Error: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Could not load video: $e";
        });
      }
    }
  }

  void _initializeYoutube() {
    _isYouTube = true;
    String? videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
          forceHD: false,
        ),
      );
      if (mounted) setState(() => _isLoading = false);
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = "Invalid YouTube URL";
      });
    }
  }

  Future<void> _initializeS3Video() async {
    _isYouTube = false;
    String finalUrl = widget.videoUrl;

    // A. If it's an S3 Key (not http), fetch the signed URL
    if (!widget.videoUrl.startsWith('http')) {
      try {
        final result = await Amplify.Storage.getUrl(
          path: StoragePath.fromString(widget.videoUrl),
          options: const StorageGetUrlOptions(
            pluginOptions: S3GetUrlPluginOptions(expiresIn: Duration(hours: 1)),
          ),
        ).result;
        finalUrl = result.url.toString();
      } catch (e) {
        throw Exception("Failed to get S3 URL: $e");
      }
    }

    // B. Initialize Video Player
    _videoController = VideoPlayerController.networkUrl(Uri.parse(finalUrl));

    await _videoController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      aspectRatio: _videoController!.value.aspectRatio,
      autoPlay: true,
      looping: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(errorMessage, style: const TextStyle(color: Colors.white)),
        );
      },
    );

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    _videoController?.dispose();
    _chewieController?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
        body: Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.white))),
      );
    }

    // 1. YOUTUBE LAYOUT
    if (_isYouTube && _youtubeController != null) {
      return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.teal,
        ),
        builder: (context, player) {
          return _buildScaffoldLayout(playerContent: player);
        },
      );
    }

    // 2. STANDARD LAYOUT (Chewie)
    return _buildScaffoldLayout(
      playerContent: _chewieController != null
          ? Chewie(controller: _chewieController!)
          : const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  // Unified Scaffold to remove code duplication
  Widget _buildScaffoldLayout({required Widget playerContent}) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Video Area (Flexible)
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Center(child: playerContent),
                  Positioned(
                    top: 10, left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            // Details Area
            Expanded(
              flex: 5,
              child: _buildVideoDescription(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text("Counselor Upload", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(widget.description, style: const TextStyle(color: Colors.black54, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
