import 'package:firstflutter/models/reel_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/reel_service.dart';
import '../widgets/video_reel_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ReelService _reelService = ReelService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Vertical PageView for Reels from Firestore
          StreamBuilder<List<ReelModel>>(
            stream: _reelService.getAllReels(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              final reels = snapshot.data ?? [];

              if (reels.isEmpty) {
                return const Center(
                  child: Text(
                    'No reels found',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              }

              return PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: reels.length,
                itemBuilder: (context, index) {
                  return VideoReelItem(reel: reels[index]);
                },
              );
            },
          ),

          // Top Overlay with Logout (Replacing AppBar)
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.logout,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                        blurRadius: 10,
                        color: Colors.black,
                        offset: Offset(0, 1))
                  ]),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: const Text(
              'Reels',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                        blurRadius: 10,
                        color: Colors.black,
                        offset: Offset(0, 1))
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
