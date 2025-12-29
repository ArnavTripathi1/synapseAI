import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticleDetailScreen extends StatefulWidget {
  final String title;
  final String category;
  final String readTime;
  final String imageUrl; // Optional: In future, fetch from metadata

  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.category,
    required this.readTime,
    this.imageUrl =
        'https://img.freepik.com/free-vector/organic-flat-people-meditating-illustration_23-2148906556.jpg',
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  bool isBookmarked = false;
  bool isPlaying = false; // Simulation for Text-to-Speech status

  // Placeholder text - This is what you will replace with S3 data later
  final String _dummyContent = """
Anxiety often feels like a storm in your mind—loud, chaotic, and overwhelming. But just like a storm, it passes. The key is finding an anchor while you wait for the skies to clear.

Here are three science-backed grounding techniques you can use right now:

1. The 5-4-3-2-1 Technique
This is the gold standard for immediate grounding. Look around you and identify:
• 5 things you can see.
• 4 things you can touch.
• 3 things you can hear.
• 2 things you can smell.
• 1 thing you can taste.

This forces your brain to switch from "fight or flight" mode (Amygdala) to "observation" mode (Prefrontal Cortex).

2. Box Breathing
Control your breath, control your nervous system. 
• Inhale for 4 seconds.
• Hold for 4 seconds.
• Exhale for 4 seconds.
• Hold for 4 seconds.
Repeat this cycle 4 times. This physically slows down your heart rate.

3. Cold Water Shock
Splash ice-cold water on your face or hold an ice cube in your hand. The intense sensation activates the "Mammalian Dive Reflex," which instantly lowers your heart rate and parasympathetic nervous system activity.

Remember, you are not your thoughts. You are the observer of your thoughts.
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. App Bar with Image Background
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                  size: 20,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? Colors.teal : Colors.black87,
                    size: 20,
                  ),
                ),
                onPressed: () => setState(() => isBookmarked = !isBookmarked),
              ),
              const SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(widget.imageUrl, fit: BoxFit.cover),
                  // Gradient overlay for text readability if title was here
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Content Body
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              transform: Matrix4.translationValues(0, -20, 0), // Overlap effect
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta Tags
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA1C4FD).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.category.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.readTime,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Title
                  Text(
                    widget.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Author Row + Play Button
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=32',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dr. Sarah Jensen",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            "Clinical Psychologist",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),

                      // Audio Player Button
                      GestureDetector(
                        onTap: () => setState(() => isPlaying = !isPlaying),
                        child: AnimatedContainer(
                          duration: 300.ms,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isPlaying
                                ? const Color(0xFFA1C4FD)
                                : const Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: isPlaying
                                ? Colors.white
                                : const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  // MAIN CONTENT
                  Text(
                    _dummyContent,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      height: 1.8, // Important for readability
                      color: const Color(0xFF334155), // Slate 700
                    ),
                  ).animate().fadeIn(delay: 300.ms),

                  const SizedBox(height: 40),

                  // Feedback Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Was this helpful?",
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _FeedbackButton(
                              icon: FontAwesomeIcons.thumbsUp,
                              label: "Yes",
                            ),
                            const SizedBox(width: 20),
                            _FeedbackButton(
                              icon: FontAwesomeIcons.thumbsDown,
                              label: "No",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeedbackButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
