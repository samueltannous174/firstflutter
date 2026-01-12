import 'package:firstflutter/models/reel_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:ui';

class FullVideoScreen extends StatefulWidget {
  final ReelModel reel;

  const FullVideoScreen({super.key, required this.reel});

  @override
  State<FullVideoScreen> createState() => _FullVideoScreenState();
}

class _FullVideoScreenState extends State<FullVideoScreen> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.reel.fullVideoUrl))
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
        if (!widget.reel.isLocked) {
           _controller.play();
           _controller.setLooping(true);
        }
      });
  }
  
  void _contribute() {
     setState(() {
       // Simulate contributing $10
       widget.reel.currentAmount += 10.0;
       
       if (!widget.reel.isLocked) {
         _controller.play();
         _controller.setLooping(true);
       }
     });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Full Video'),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
           // Video Layer
          if (_initialized)
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
          else
            const CircularProgressIndicator(color: Colors.white),

          // BLUR & LOCK OVERLAY
          if (widget.reel.isLocked)
             Positioned.fill(
               child: BackdropFilter(
                 filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                 child: Container(
                   color: Colors.black.withOpacity(0.5),
                   child: const Center(
                     child: Icon(Icons.lock, color: Colors.white, size: 80),
                   ),
                 ),
               ),
             ),
             
           // Bottom Contribution Panel
           Positioned(
             bottom: 40,
             left: 20,
             right: 20,
             child: Column(
               children: [
                 if(widget.reel.isLocked)
                    const Text(
                       "This video is locked. Contribute to reveal!",
                       style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                 const SizedBox(height: 10),
                 LinearProgressIndicator(
                   value: (widget.reel.currentAmount / widget.reel.targetAmount).clamp(0.0, 1.0),
                   backgroundColor: Colors.grey[800],
                   color: Colors.greenAccent,
                   minHeight: 10,
                 ),
                 const SizedBox(height: 10),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(
                       "\$${widget.reel.currentAmount.toStringAsFixed(0)} raised",
                        style: const TextStyle(color: Colors.white70),
                     ),
                      Text(
                       "Goal: \$${widget.reel.targetAmount.toStringAsFixed(0)}",
                        style: const TextStyle(color: Colors.white70),
                     ),
                   ],
                 ),
                 const SizedBox(height: 20),
                 if (widget.reel.isLocked)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      onPressed: _contribute, 
                      child: const Text("Contribute \$10"),
                    )
                 else
                    ElevatedButton(
                       style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      onPressed: () {
                         if(_controller.value.isPlaying) {
                           _controller.pause();
                         } else {
                           _controller.play();
                         }
                      },
                      child: const Text("Pause / Play"),
                    )
               ],
             ),
           )
        ],
      ),
    );
  }
}
