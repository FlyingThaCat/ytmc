import 'package:flutter/material.dart';

class PlayerPage extends StatefulWidget {
  final String? videoId;
  const PlayerPage({super.key, required this.videoId});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Player Page, videoId: ${widget.videoId}'),
      ),
    );
  }
}