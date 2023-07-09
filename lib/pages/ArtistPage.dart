import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ArtistPage extends StatefulWidget {
  final String? artistPageId;
  const ArtistPage({Key? key, required this.artistPageId}) : super(key: key);

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  final Map<String, dynamic> body = {
    'context': {
      'client': {
        'hl': 'en',
        'gl': 'US',
        'clientName': 'ANDROID_MUSIC',
        'clientVersion': '5.26.1',
        'platform': 'MOBILE',
        'androidSdkVersion': '31'
      },
      'user': {'lockedSafetyMode': false}
    },
  };

  final response = {
    'thumbnails': [],
    'originThumbnail': '',
    'artistName': '',
    'latestRelease': {},
    'topSongs': {},
    'albums': {},
    'singles': [],
    'videos': [],
    'featuredChannels': [],
    'relatedArtists': [],
    'artistBio': [],
  };

  Future<Map<String, dynamic>> fetchData() async {
    // append browseId to body
    body['browseId'] = widget.artistPageId;
    final response = await http.post(
      Uri.parse(
          'https://music.youtube.com/youtubei/v1/browse?key=AIzaSyAOghZGza2MQSZkY_zfZ370N-PUdXEo8AI'),
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

          // Get thumbnails
          final thumbnails = data?['header']['musicVisualHeaderRenderer']
                  ['thumbnail']['musicThumbnailRenderer']['thumbnail']
              ['thumbnails'];
          response['thumbnails'] = thumbnails;

          // Get origin thumbnail by removing the =w1440-h810-p-l90-rj from the url
          final originThumbnail = thumbnails[0]['url'].toString().split('=');
          response['originThumbnail'] = originThumbnail[0];

          // Get artist name
          final artistName = data?['header']['musicVisualHeaderRenderer']
              ['title']['runs'][0]['text'];
          response['artistName'] = artistName;

          // Handle latest release
          final latestRelease = data?['contents']
                          ['singleColumnBrowseResultsRenderer']['tabs'][0]
                      ['tabRenderer']['content']['sectionListRenderer']
                  ['contents'][0]['musicSpotlightShelfRenderer']['contents'][0]
              ['musicSpotlightItemRenderer'];
          // Get latest release thumbnails
          final latestReleaseThumbnails = latestRelease['thumbnailRenderer']
              ['musicThumbnailRenderer']['thumbnail']['thumbnails'];
          // Get latest release title
          final latestReleaseTitle = latestRelease['title']['runs'][0]['text'];
          // Get latest release type
          final latestReleaseType =
              latestRelease['subtitle']['runs'][0]['text'];
          // Get latest release year
          final latestReleaseYear =
              latestRelease['subtitle']['runs'][2]['text'];
          // Get latest release browseId
          final latestReleaseBrowseId =
              latestRelease['navigationEndpoint']['browseEndpoint']['browseId'];

          // Add latest release to response
          response['latestRelease'] = {
            'thumbnails': latestReleaseThumbnails,
            'title': latestReleaseTitle,
            'releaseType': latestReleaseType,
            'releaseYear': latestReleaseYear,
            'browseId': latestReleaseBrowseId,
          };

          // Handle top songs
          final topSongs = data?['contents']
                      ['singleColumnBrowseResultsRenderer']['tabs'][0]
                  ['tabRenderer']['content']['sectionListRenderer']['contents']
              [1]['musicShelfRenderer'];

          // Add top songs browseId to response
          final topSongsBrowseId = topSongs['moreContentButton']
                  ['buttonRenderer']['navigationEndpoint']['browseEndpoint']
              ['browseId'];

          // Get top songs
          final topSongsList = topSongs['contents'];

          // Add top songs to response
          response['topSongs'] = {
            'browseId': topSongsBrowseId,
            'list': topSongsList,
          };

          // Handle albums
          final albums = data?['contents']['singleColumnBrowseResultsRenderer']
                  ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']
              ['contents'][2]['musicCarouselShelfRenderer'];

          // get albums browseId to response
          final albumsBrowseId = albums['header']
                  ['musicCarouselShelfBasicHeaderRenderer']
              ['navigationEndpoint']['browseEndpoint']['browseId'];

          // get albums list
          final albumsList = albums['contents'];

          // add albums to response
          response['albums'] = {
            'browseId': albumsBrowseId,
            'list': albumsList,
          };

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
                            response['originThumbnail']?.toString() ?? '',
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
                                response['artistName'].toString(),
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
                    // Latest release
                    const Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 2.5, left: 16),
                      child: Row(
                        children: [
                          Text(
                            'Latest release',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin:
                          const EdgeInsets.only(left: 10, top: 2.5, right: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      (response['latestRelease'] as Map<String,
                                                      dynamic>?)?['thumbnails']
                                                  ?[2]['url']
                                              ?.toString() ??
                                          '',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (response['latestRelease'] as Map<
                                                    String, dynamic>?)?['title']
                                                ?.toString() ??
                                            '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        (response['latestRelease'] as Map<
                                                    String,
                                                    dynamic>?)?['releaseType']
                                                ?.toString() ??
                                            '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        (response['latestRelease'] as Map<
                                                    String,
                                                    dynamic>?)?['releaseYear']
                                                ?.toString() ??
                                            '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon:
                                          const Icon(Icons.arrow_back_rounded),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Latest release
                    const Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 2.5, left: 16),
                      child: Row(
                        children: [
                          Text(
                            'Top songs',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      padding: const EdgeInsets.only(top: 2.5),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: (response['topSongs']
                                  as Map<String, dynamic>?)?['list']
                              ?.length ??
                          0,
                      itemBuilder: (context, index) {
                        final topSongsList = (response['topSongs']
                            as Map<String, dynamic>?)?['list'];
                        final topSongsListTitle = topSongsList?[index]
                                ['musicTwoColumnItemRenderer']['title']['runs']
                            [0]['text'];
                        final topSongsListSubtitle = topSongsList?[index]
                                ['musicTwoColumnItemRenderer']['subtitle']
                            ['runs'][0]['text'];
                        final topSongsListThumbnail = topSongsList?[index]
                                    ['musicTwoColumnItemRenderer']['thumbnail']
                                ['musicThumbnailRenderer']['thumbnail']
                            ['thumbnails'][1]['url'];
                        return ListTile(
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              // add background color to list tile
                              image: DecorationImage(
                                image: NetworkImage(
                                  topSongsListThumbnail?.toString() ?? '',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            topSongsListTitle?.toString() ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            topSongsListSubtitle?.toString() ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),

                    // Albums Carousel
                    const Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 2.5, left: 16),
                      child: Row(
                        children: [
                          Text(
                            'Albums',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Albums Carousel
                    SizedBox(
                      height: 230,
                      child: SizedBox(
                        width: double.infinity,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 2.5),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: (response['albums']
                                      as Map<String, dynamic>?)?['list']
                                  ?.length ??
                              0,
                          itemBuilder: (context, index) {
                            final albumsList = (response['albums']
                                as Map<String, dynamic>?)?['list'];
                            final albumsListTitle = albumsList?[index]
                                    ['musicTwoRowItemRenderer']['title']['runs']
                                [0]['text'];
                            final albumsListYear = albumsList?[index]
                                    ['musicTwoRowItemRenderer']['subtitle']
                                ['runs'][2]['text'];
                            final albumsExplicit = albumsList?[index]
                                                ['musicTwoRowItemRenderer']
                                            ['subtitleBadges']?[0]
                                        ['musicInlineBadgeRenderer']
                                    ['accessibilityData']['accessibilityData']
                                ['label'];
                            final albumsListThumbnail = albumsList?[index]
                                            ['musicTwoRowItemRenderer']
                                        ['thumbnailRenderer']
                                    ['musicThumbnailRenderer']['thumbnail']
                                ['thumbnails'][2]['url'];
                            return Container(
                              width: 160,
                              margin: const EdgeInsets.only(
                                  left: 10, top: 2.5, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      // add background color to list tile
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          albumsListThumbnail?.toString() ?? '',
                                        ),
                                        fit: BoxFit.cover,
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
                                                text: albumsListTitle
                                                        ?.toString() ??
                                                    '',
                                              ),
                                              if (albumsExplicit == 'Explicit')
                                                const WidgetSpan(
                                                  alignment:
                                                      PlaceholderAlignment
                                                          .middle,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.only(
                                                            left: 5),
                                                    child: Icon(
                                                        Icons.explicit_rounded,
                                                        size: 14),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    albumsListYear?.toString() ?? '',
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

                    // Singles Carousel
                    const Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 2.5, left: 16),
                      child: Row(
                        children: [
                          Text(
                            'Singles',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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
