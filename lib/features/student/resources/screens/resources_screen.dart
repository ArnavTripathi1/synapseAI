import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// --- IMPORTS FOR NAVIGATION ---
import 'article_reading_screen.dart'; // Ensure this matches your filename
import 'video_player_screen.dart';    // Ensure this matches your filename

// --- DATA MODEL ---
class ResourceItem {
  final String title;
  final String type; // 'video' or 'article'
  final String category;
  final String duration; // "5 min watch" or "3 min read"
  final String url; // YouTube URL or Empty for article
  final String description;

  ResourceItem({
    required this.title,
    required this.type,
    required this.category,
    required this.duration,
    required this.url,
    required this.description,
  });
}

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  int _selectedIndex = 0;

  // --- MOCK DATA SEPARATED BY TYPE ---

  final List<String> _categories = ["All", "Anxiety", "Sleep", "Depression", "Focus"];

  final List<ResourceItem> _videos = [
    ResourceItem(
      title: "Feeling UGLY? It’s Not You — It’s SOCIAL MEDIA",
      type: "video",
      category: "Stress",
      duration: "5 min watch",
      url: "https://www.youtube.com/watch?v=NiELZ38O1CM", // Psych2Go Example
      description: "Have you ever felt worse about yourself after scrolling online?\nLike suddenly, everyone looks better… happier… more put together than you?\n\nYou’re not imagining it.\nAnd there’s nothing wrong with you.",
    ),
    ResourceItem(
      title: "Grounding for Panic Attacks",
      type: "video",
      category: "Anxiety",
      duration: "5 min watch",
      url: "https://www.youtube.com/watch?v=qQML3_k-yDw", // Therapy in a Nutshell Example
      description: "Learn how to stop a panic attack in its tracks with these physiological techniques.",
    ),
    ResourceItem(
      title: "Sleep Music: Delta Waves",
      type: "video",
      category: "Sleep",
      duration: "60 min listen",
      url: "https://www.youtube.com/watch?v=M2FwUj93oDo", // Sleep Music Example
      description: "Deep sleep music to help you fall asleep fast and wake up refreshed.",
    ),
  ];

  final List<ResourceItem> _articles = [
    ResourceItem(
      title: "Why do I feel lonely?",
      type: "article",
      category: "Social",
      duration: "4 min read",
      url: "",
      description: "Exploring the psychology behind loneliness in the digital age.",
    ),
    ResourceItem(
      title: "The Science of Dopamine",
      type: "article",
      category: "Focus",
      duration: "6 min read",
      url: "",
      description: "How to manage your dopamine levels for better study sessions.",
    ),
    ResourceItem(
      title: "Cognitive Distortions 101",
      type: "article",
      category: "Therapy",
      duration: "5 min read",
      url: "",
      description: "Identifying the lies your brain tells you when you are stressed.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // 1. App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: const Color(0xFFF8FAFC),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                "Wellness Library",
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF1E293B),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),

          // 2. Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search videos, articles...",
                    hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[400]),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFA1C4FD)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ).animate().fadeIn().slideY(begin: 0.2, end: 0),
          ),

          // 3. Category Chips
          SliverToBoxAdapter(
            child: Container(
              height: 60,
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: AnimatedContainer(
                      duration: 300.ms,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFA1C4FD) : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.2),
                        ),
                        boxShadow: isSelected
                            ? [BoxShadow(color: const Color(0xFFA1C4FD).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))]
                            : [],
                      ),
                      child: Text(
                        _categories[index],
                        style: GoogleFonts.plusJakartaSans(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 4. Featured Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArticleDetailScreen(
                        title: "Understanding Panic Attacks",
                        category: "Anxiety",
                        readTime: "5 min read",
                      ),
                    ),
                  );
                },
                child: const FeaturedResourceCard(
                  title: "Understanding Panic Attacks",
                  subtitle: "5 techniques to ground yourself instantly.",
                  imageColor: Color(0xFFC2E9FB),
                  readTime: "Featured Article",
                ),
              ),
            ).animate().fadeIn(delay: 200.ms),
          ),

          // 5. SECTION: WATCH & LEARN (VIDEOS)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text(
                "Watch & Learn",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ResourceListItem(item: _videos[index], index: index),
                  );
                },
                childCount: _videos.length,
              ),
            ),
          ),

          // 6. SECTION: READ & REFLECT (ARTICLES)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text(
                "Read & Reflect",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ResourceListItem(item: _articles[index], index: index),
                  );
                },
                childCount: _articles.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

// --- WIDGETS ---

class FeaturedResourceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color imageColor;
  final String readTime;

  const FeaturedResourceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageColor,
    required this.readTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: imageColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: imageColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.orangeAccent),
                      const SizedBox(width: 6),
                      Text(
                        readTime,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: const Color(0xFF1E293B).withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResourceListItem extends StatelessWidget {
  final ResourceItem item;
  final int index;

  const ResourceListItem({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final isVideo = item.type == 'video';

    return GestureDetector(
      onTap: () {
        if (isVideo) {
          // NAVIGATE TO VIDEO PLAYER
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                videoUrl: item.url,
                title: item.title,
                description: item.description,
              ),
            ),
          );
        } else {
          // NAVIGATE TO ARTICLE READER
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(
                title: item.title,
                category: item.category,
                readTime: item.duration,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Box
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isVideo ? Colors.red.shade50 : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isVideo ? FontAwesomeIcons.play : FontAwesomeIcons.bookOpen,
                color: isVideo ? Colors.redAccent : const Color(0xFFA1C4FD),
                size: 18,
              ),
            ),
            const SizedBox(width: 16),
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "${item.category} • ${item.duration}",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[300]),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (50 * index).ms).slideX();
  }
}
