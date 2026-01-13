import 'package:firstflutter/models/reel_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoReelItem extends StatefulWidget {
  final ReelModel reel;

  const VideoReelItem({super.key, required this.reel});

  @override
  State<VideoReelItem> createState() => _VideoReelItemState();
}

class _VideoReelItemState extends State<VideoReelItem> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.reel.trailerUrl))
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_initialized)
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
          else
            const CircularProgressIndicator(color: Colors.white),

          // Play/Pause Overlay on Tap
          GestureDetector(
            onTap: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
            child: Container(
              color: Colors.transparent,
              child: _controller.value.isPlaying
                  ? null
                  : const Icon(
                      Icons.play_arrow,
                      size: 64,
                      color: Colors.white54,
                    ),
            ),
          ),
          
          // Overlay Info (Mock TikTok UI)
          Positioned(
            bottom: 20,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '@username',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Watch the trailer! Tap button for full video ->',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    _controller.pause();
                    Navigator.pushNamed(
                      context,
                      'video',
                      arguments: widget.reel,
                    ).then((_) => _controller.play());
                  },
                  icon: const Icon(Icons.movie),
                  label: const Text("Watch Full Video"),
                )
              ],
            ),
          ),
          
          // Side Actions (Mock TikTok UI)
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                _buildAction(Icons.favorite, '1.2M'),
                const SizedBox(height: 20),
                _buildAction(Icons.comment, '45K'),
                const SizedBox(height: 20),
                _buildAction(Icons.share, 'Share'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}
