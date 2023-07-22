import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

// import data
import '../data/constant.dart';
import '../data/construct.dart';
import '../data/translator.dart';

class PlayerPage extends StatefulWidget {
  final String? videoId;

  const PlayerPage({Key? key, required this.videoId}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final body = constructAPIBody();
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  bool _userTriggeredPlay = false;

  Future<Map<String, dynamic>> fetchData() async {
    // append videoId to body
    body['videoId'] = widget.videoId;
    final response = await http.post(
      Uri.parse(ytmPlayerURL),
      headers: {'content-type': 'application/json'},
      body: jsonEncode(body),
    );
    final data = jsonDecode(response.body);
    return data;
  }

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer(); // Initialize audioPlayer here
    setupAudioPlayer(widget.videoId); // Call the setup method
  }

  @override
  void dispose() {
    audioPlayer.stop(); // Stop the audio when the page is disposed
    audioPlayer.dispose(); // Dispose the audio player
    super.dispose();
  }

  Future<void> setupAudioPlayer(String? videoId) async {
    if (videoId == null) return;

    // Fetch data from the API
    body['videoId'] = videoId;
    final response = await http.post(
      Uri.parse(ytmPlayerURL),
      headers: {'content-type': 'application/json'},
      body: jsonEncode(body),
    );
    final data = jsonDecode(response.body);
    final streamDatas = extractStreamingData(data);
    // debugPrint(streamDatas.toString());

    // Check if the audio player is playing before setting the URL
    if (isPlaying) {
      await audioPlayer.stop(); // Stop the player if it's currently playing
    }

    // Set the new audio URL and start playing
    await audioPlayer.setUrl(streamDatas['adaptiveFormats'][16]['url']);

    // Add a player state listener to update the isPlaying state and the icon
    audioPlayer.playerStateStream.listen((playerState) {
      // Check if the state change was triggered by user interaction
      if (_userTriggeredPlay) {
        setState(() {
          isPlaying = playerState.playing;
        });
      }
    });

    // Update the isPlaying state
    setState(() {
      isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final data = snapshot.data;
          final streamDatas = extractStreamingData(data);
          // debugPrint(streamDatas.toString());

          return Scaffold(
            appBar: AppBar(
              title: Text(
                streamDatas['title'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // add image
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        image: NetworkImage(
                          streamDatas['thumbnails'][3]['url'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // add title
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          streamDatas['title'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // add artist
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          streamDatas['author'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // add control button and progress bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          // Set the userTriggeredPlay variable to true before interaction
                          _userTriggeredPlay = true;

                          // Check if the audio is playing or paused and take the appropriate action
                          if (isPlaying) {
                            await audioPlayer.pause();
                          } else {
                            await audioPlayer.play();
                          }

                          // Reset the userTriggeredPlay variable after interaction
                          _userTriggeredPlay = false;
                        },
                        icon: isPlaying
                            ? const Icon(Icons.pause)
                            : const Icon(Icons.play_arrow),
                      ),
                    ],
                  ),
                  // StreamBuilder to show the progress bar
                  StreamBuilder<Duration?>(
                    stream: audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final position = snapshot.data ?? Duration.zero;
                        final totalDuration =
                            audioPlayer.duration ?? Duration.zero;
                        return Slider(
                          value: position.inMilliseconds.toDouble(),
                          min: 0,
                          max: totalDuration.inMilliseconds.toDouble(),
                          onChanged: (value) {
                            audioPlayer
                                .seek(Duration(milliseconds: value.toInt()));
                          },
                        );
                      } else {
                        return Slider(
                          value: 0,
                          min: 0,
                          max: 1,
                          onChanged: (value) {},
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
