import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/study_material_model.dart';

class VideoPlayerScreen extends StatefulWidget {
  final StudyMaterial material;

  const VideoPlayerScreen({
    super.key,
    required this.material,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoController = VideoPlayerController.network(widget.material.url);
    
    try {
      await _videoController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoController.value.aspectRatio,
        placeholder: Center(
          child: Image.network(widget.material.thumbnail ?? ''),
        ),
      );
      setState(() => _isInitialized = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.material.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadVideo,
          ),
        ],
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _isInitialized
                ? Chewie(controller: _chewieController!)
                : const Center(child: CircularProgressIndicator()),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.material.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.material.description ?? '',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  if (widget.material.notes != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.material.notes!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadVideo() async {
    // Download video for offline access
    // Implementation
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
} 