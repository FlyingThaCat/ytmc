import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// import data
import '../data/constant.dart';
import '../data/construct.dart';
import '../data/translator.dart';

// import components
import '../components/artist_bio.dart';
import '../components/featured_playlists.dart';
import '../components/singles.dart';
import '../components/videos.dart';
import '../components/albums.dart';
import '../components/latest_release.dart';
import '../components/related_artists.dart';
import '../components/top_songs.dart';

class ArtistPage extends StatefulWidget {
  final String? artistPageId;
  const ArtistPage({Key? key, required this.artistPageId}) : super(key: key);

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  final body = constructAPIBody();

  Future<Map<String, dynamic>> fetchData() async {
    // append browseId to body
    body['browseId'] = widget.artistPageId;
    final response = await http.post(
      Uri.parse(ytmBrowseURL),
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
          debugPrint(widget.artistPageId.toString());
          final data = snapshot.data;

          final thumbails = extractThumbnails(data);
          final artist = extractArtist(data);
          final latestRelease = extractLatestRelease(data);
          final topSongs = extractTopSongs(data);
          final albums = extractAlbums(data);
          final singles = extractSingles(data);
          final videos = extractVideos(data);
          final featuredPlaylists = extractFeaturedPlaylists(data);
          final relatedArtists = extractRelatedArtists(data);
          

          return Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      // show image in full width
                      flexibleSpace: Stack(
                        children: <Widget>[
                          Image.network(
                            thumbails['originThumbnail'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 300,
                          ),
                          // add gradient to image
                          Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  // get color from theme and add Opacity
                                  Theme.of(context).scaffoldBackgroundColor,
                                  // Colors.black.withOpacity(1),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                artist['artistName'],
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.play_arrow_rounded),
                                iconSize: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share_rounded),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search_rounded),
                        ),
                      ],
                    ),
                    if (latestRelease.isNotEmpty)
                      LatestReleaseComponent(latestRelease: latestRelease),
                    if (topSongs.isNotEmpty)
                      TopSongsComponent(topSongs: topSongs),
                    if (albums.isNotEmpty) AlbumsComponent(albums: albums),
                    if (singles.isNotEmpty) SinglesComponent(singles: singles),
                    if (videos.isNotEmpty) VideosComponent(videos: videos),
                    if (featuredPlaylists.isNotEmpty)
                      FeaturedPlaylistsComponent(
                          featuredPlaylists: featuredPlaylists),
                    if (relatedArtists.isNotEmpty)
                      RelatedArtistsComponent(relatedArtists: relatedArtists),
                    if (artist.isNotEmpty && thumbails.isNotEmpty)
                      ArtistBioComponent(
                          artistBio: artist, thumbails: thumbails),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
