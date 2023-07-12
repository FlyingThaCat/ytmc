import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ytmc/components/singles.dart';

import '../components/albums.dart';
import '../components/latest_release.dart';
import '../components/top_songs.dart';
import '../data/constant.dart';
import '../data/construct.dart';
import '../data/translator.dart';

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
          final featuredOn = extractFeaturedOn(data);
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
  
                    LatestReleaseComponent(latestRelease: latestRelease),
                    TopSongsComponent(topSongs: topSongs),
                    AlbumsComponent(albums: albums),
                    SinglesComponent(singles: singles),

                    

                    // videos
                    const Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 2.5, left: 16),
                      child: Row(
                        children: [
                          Text(
                            'Videos',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // videos Carousel
                    SizedBox(
                      height: 200,
                      child: SizedBox(
                        width: double.infinity,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 2.5),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: videos['videosList']?.length ?? 0,
                          itemBuilder: (context, index) {
                            final videosList = videos['videosList'];
                            final videosListTitle = videosList?[index]
                                    ['musicTwoRowItemRenderer']['title']['runs']
                                [0]['text'];
                            final videosListArtist = videosList?[index]
                                    ['musicTwoRowItemRenderer']['subtitle']
                                ['runs'][0]['text'];
                            final videosViews = videosList?[index]
                                    ['musicTwoRowItemRenderer']['subtitle']
                                ['runs'][2]['text'];
                            final videosListThumbnail = videosList?[index]
                                            ['musicTwoRowItemRenderer']
                                        ['thumbnailRenderer']
                                    ['musicThumbnailRenderer']['thumbnail']
                                ['thumbnails'][0]['url'];
                            return Container(
                              width: 225,
                              margin: EdgeInsets.only(
                                  top: 12, bottom: 2.5, left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // add rounded corners to image and cover
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      width: 225,
                                      height: 127,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        // add background color to list tile
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            videosListThumbnail?.toString() ??
                                                '',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RichText(
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: videosListTitle
                                                        ?.toString() ??
                                                    '',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    videosListArtist?.toString() ?? '',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    videosViews?.toString() ?? '',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Featured channels
                    const Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 2.5, left: 16),
                      child: Row(
                        children: [
                          Text(
                            'Featured on',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Featured channels Carousel
                    SizedBox(
                      height: 230,
                      child: SizedBox(
                        width: double.infinity,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 2.5),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: featuredOn['featuredOnList']?.length ?? 0,
                          itemBuilder: (context, index) {
                            final featuredChannelsList =
                                featuredOn['featuredOnList'];
                            final featuredChannelsListTitle =
                                featuredChannelsList?[index]
                                        ['musicTwoRowItemRenderer']['title']
                                    ['runs'][0]['text'];
                            final featuredChannelsListThumbnail =
                                featuredChannelsList?[index]
                                                ['musicTwoRowItemRenderer']
                                            ['thumbnailRenderer']
                                        ['musicThumbnailRenderer']['thumbnail']
                                    ['thumbnails'][2]['url'];
                            return Container(
                              width: 160,
                              margin: EdgeInsets.only(
                                  top: 12, bottom: 2.5, left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // add rounded corners to image and cover
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      width: 160,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        // add background color to list tile
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            featuredChannelsListThumbnail
                                                    ?.toString() ??
                                                '',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RichText(
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: featuredChannelsListTitle
                                                        ?.toString() ??
                                                    '',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Related artists
                    const Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 2.5, left: 16),
                      child: Row(
                        children: [
                          Text(
                            'Related artists',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Related artists Carousel
                    SizedBox(
                      height: 210,
                      child: SizedBox(
                        width: double.infinity,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 2.5),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: relatedArtists['relatedArtistsList']
                                  ?.length ??
                              0,
                          itemBuilder: (context, index) {
                            final relatedArtistsList =
                                relatedArtists['relatedArtistsList'];
                            final relatedArtistsListTitle =
                                relatedArtistsList?[index]
                                        ['musicTwoRowItemRenderer']['title']
                                    ['runs'][0]['text'];
                            final relatedArtistsListThumbnail =
                                relatedArtistsList?[index]
                                                ['musicTwoRowItemRenderer']
                                            ['thumbnailRenderer']
                                        ['musicThumbnailRenderer']['thumbnail']
                                    ['thumbnails'][1]['url'];
                            return GestureDetector(
                              onTap: () {
                                // go to artist page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArtistPage(
                                      artistPageId: relatedArtistsList?[index]
                                                  ['musicTwoRowItemRenderer']
                                              ['navigationEndpoint']
                                          ['browseEndpoint']['browseId'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                // make rounded image
                                width: 160,
                                margin: const EdgeInsets.only(
                                    top: 12, bottom: 2.5, left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: Container(
                                        width: 160,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          // add background color to list tile
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              relatedArtistsListThumbnail
                                                      ?.toString() ??
                                                  '',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Center(
                                      child: RichText(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: relatedArtistsListTitle
                                                      ?.toString() ??
                                                  '',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Artist bio
                    const Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 2.5, left: 16),
                      child: Row(
                        children: [
                          Text(
                            'Artist bio',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Artist bio
                    Container(
                      width: double.infinity,
                      margin:
                          const EdgeInsets.only(left: 10, top: 2.5, right: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        // show image with rounded corners using original image
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Stack(
                            children: <Widget>[
                              Image.network(
                                thumbails['originThumbnail'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 300,
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.8),
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            artist['artistName'],
                                            style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      artist['artistName'],
                                                    ),
                                                    content: Text(
                                                      artist[
                                                          'artistBioContent'],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Close'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.arrow_forward_rounded,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        artist['artistBioViewCounter'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        artist['artistBioContentShort'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
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
