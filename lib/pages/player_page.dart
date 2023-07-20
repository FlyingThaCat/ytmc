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
  final audioPlayer = AudioPlayer();

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
          debugPrint(streamDatas.toString());
          audioPlayer.setUrl(streamDatas['adaptiveFormats'][16]['url']);
          audioPlayer.play();

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
                      borderRadius: BorderRadius.circular(10.0),
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
                  // add control button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          audioPlayer.play();
                        },
                        icon: const Icon(Icons.play_arrow),
                      ),
                      IconButton(
                        onPressed: () {
                          audioPlayer.pause();
                        },
                        icon: const Icon(Icons.pause),
                      ),
                    ],
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
