import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For controlling orientation
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerScreen extends StatefulWidget {
  @override
  _YouTubePlayerScreenState createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        'https://www.youtube.com/watch?v=4w1zYVxAyvQ&list=PLjm_mvBNlvBYgDuCkYL3YntehJ3ldWBA5&index=14',
      )!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    // Lock orientation to landscape when entering the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo recording')),
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
    );
  }

  @override
  void dispose() {
    // Reset orientation to default (allow both portrait and landscape) when leaving the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _controller.dispose();
    super.dispose();
  }
}