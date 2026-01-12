import 'package:firstflutter/models/reel_model.dart';
import 'package:firstflutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/video_reel_item.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<ReelModel> _reels = [
    ReelModel(
      id: '1',
      trailerUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      fullVideoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      targetAmount: 50.0,
      currentAmount: 10.0,
    ),
    ReelModel(
      id: '2',
      trailerUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      fullVideoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      targetAmount: 100.0,
      currentAmount: 100.0, // Already unlocked
    ),
     ReelModel(
      id: '3',
      trailerUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      fullVideoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      targetAmount: 200.0,
      currentAmount: 50.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Vertical PageView for Reels
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _reels.length,
            itemBuilder: (context, index) {
              return VideoReelItem(reel: _reels[index]);
            },
          ),

          // Top Overlay with Logout (Replacing AppBar)
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white, shadows: [
                Shadow(blurRadius: 10, color: Colors.black, offset: Offset(0, 1))
              ]),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ),
          
          Positioned(
             top: 40,
             left: 20,
             child: const Text('Reels', style: TextStyle(
               color: Colors.white, 
               fontSize: 22, 
               fontWeight: FontWeight.bold,
                shadows: [
                Shadow(blurRadius: 10, color: Colors.black, offset: Offset(0, 1))
              ]
             ),),
          )
        ],
      ),
    );
  }
}
