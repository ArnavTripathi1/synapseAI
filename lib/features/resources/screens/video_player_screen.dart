import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
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

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    if (widget.videoUrl.contains('youtube.com') || widget.videoUrl.contains('youtu.be')) {
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
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Handle S3 / MP4 Files
      _isYouTube = false;
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

      _videoController!.initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          aspectRatio: _videoController!.value.aspectRatio,
          autoPlay: true,
          looping: false,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        );
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    _videoController?.dispose();
    _chewieController?.dispose();
    // Force portrait when leaving the screen
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

    // 1. YOUTUBE LAYOUT (With Fullscreen Builder)
    if (_isYouTube) {
      return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.teal,
          onReady: () {
            // Optional: Actions when player is ready
          },
        ),
        builder: (context, player) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Column(
                children: [
                  // Video Area
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        // The player provided by the builder
                        Center(child: player),
                        // Back Button Overlay (Visible in Portrait)
                        Positioned(
                          top: 10,
                          left: 10,
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
        },
      );
    }

    // 2. STANDARD LAYOUT (For Chewie/S3/MP4)
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Center(child: Chewie(controller: _chewieController!)),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: _buildVideoDescription(),
            ),
          ],
        ),
      ),
    );
  }

  // Extracted widget to avoid duplication between the two layouts
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
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
            ),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.remove_red_eye, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text("1.2k views", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                const SizedBox(width: 16),
                Icon(Icons.favorite, size: 16, color: Colors.pink[400]),
                const SizedBox(width: 4),
                Text("98% helpful", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: const TextStyle(color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border),
                    label: const Text("Save"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text("Share", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
