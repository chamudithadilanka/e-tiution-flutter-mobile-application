import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/utils/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ClassSingleVideo extends StatefulWidget {
  final String ClassId;
  const ClassSingleVideo({super.key, required this.ClassId});

  @override
  State<ClassSingleVideo> createState() => _ClassSingleVideoState();
}

class _ClassSingleVideoState extends State<ClassSingleVideo> {
  late YoutubePlayerController _controller;
  ApiService apiService = ApiService();

  List<dynamic> videos = [];
  bool isLoading = true;
  bool isPlaying = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    try {
      final data = await apiService.getVideosByClassId(widget.ClassId);
      videos = data['videos'];
      if (videos.isNotEmpty) {
        final String? firstVideoId = YoutubePlayer.convertUrlToId(
          videos[0]['videoUrl'] ?? '',
        );
        _controller = YoutubePlayerController(
          initialVideoId: firstVideoId ?? '',
          flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
        );
        setState(() {
          currentIndex = 0;
        });
      }
    } catch (e) {
      print("Error loading videos: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Video Tutorial",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (videos.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Video Tutorial")),
        body: Center(child: Text("No videos available")),
      );
    }

    final currentVideo = videos[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Tutorial"),
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          // Main Player Area
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kMainColor, kMainDarkBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    currentVideo['title'] ?? "Video Title",
                    style: TextStyle(
                      color: kMainWhiteColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: YoutubePlayer(controller: _controller),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Video List Section
          SizedBox(height: 10),
          Text(
            "Video Playlist",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              width: double.infinity,
              height: 420,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kMainWhiteColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 2,
                    spreadRadius: 2,
                    color: Colors.black12,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  final String? videoId = YoutubePlayer.convertUrlToId(
                    video['videoUrl'] ?? '',
                  );
                  final String title = video['title'] ?? "No title";
                  final String description =
                      video['description'] ?? "No description";

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Container(
                      height: 75,
                      decoration: BoxDecoration(
                        color: kMainWhiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            spreadRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Image.network(
                              video['thumbnailUrl'] ?? '',
                              width: 60,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 40),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                (isPlaying && currentIndex == index)
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_fill,
                                size: 40,
                                color: kMainColor,
                              ),
                              onPressed: () {
                                if (videoId != null) {
                                  if (currentIndex == index && isPlaying) {
                                    _controller.pause();
                                    setState(() => isPlaying = false);
                                  } else {
                                    _controller.load(videoId);
                                    setState(() {
                                      currentIndex = index;
                                      isPlaying = true;
                                    });
                                    _controller.play();
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
