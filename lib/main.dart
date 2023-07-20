import 'dart:convert';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'data/constant.dart';
import 'package:http/http.dart' as http;

// PAGES RELATED
import 'data/construct.dart';
import 'pages/ArtistPage.dart';
import 'pages/player_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.blue);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        title: 'YTMC',
        theme: ThemeData(
          colorScheme: lightColorScheme ?? _defaultLightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.dark,
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SearchController controller = SearchController();

  final body = constructAPIBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(children: <Widget>[
          const SizedBox(height: 38.0),
          SearchAnchor.bar(
            constraints: const BoxConstraints(maxHeight: 56, maxWidth: 720),
            searchController: controller,
            isFullScreen: true,
            barHintText: 'Search',
            barLeading: const Icon(Icons.search_rounded),
            barTrailing: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings_rounded),
              )
            ],
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              if (controller.text.isNotEmpty) {
                // add to body input
                body['input'] = controller.value.text;

                // make a request to youtube api
                return [
                  FutureBuilder(
                    future: http.post(
                      Uri.parse(ytmSearchSuggestURL),
                      headers: {'content-type': 'application/json'},
                      body: jsonEncode(body),
                    ),
                    builder: (context, snapshot) {
                      
                      // get the response instance
                      if (snapshot.hasData) {
                        final response = jsonDecode(snapshot.data!.body);
                        List<dynamic> musicSuggestion;

                        // get the search suggestions
                        final searchSuggestions = response['contents'][0]
                            ['searchSuggestionsSectionRenderer']['contents'];

                        // get the music suggestions
                        if (response['contents'].length >= 2) {
                          musicSuggestion = response['contents'][1]
                              ['searchSuggestionsSectionRenderer']['contents'];
                        } else {
                          // Handle the case when index 1 is not available
                          // For example, you can assign an empty list to musicSuggestion
                          musicSuggestion = [];
                        }

                        // make a list of suggestions
                        final List<String> suggestionsList = [];
                        // make a list array of music suggestions
                        final List<Map<String, String>> musicSuggestionsList =
                            [];

                        // add the music suggestions to the list
                        for (var i = 0; i < searchSuggestions.length; i++) {
                          suggestionsList.add(searchSuggestions[i]
                                      ['searchSuggestionRenderer']
                                  ['navigationEndpoint']['searchEndpoint']
                              ['query']);
                        }

                        // add the music suggestions to the list build an object that contains title, artist, explicit and thumbnail
                        for (var i = 0; i < musicSuggestion.length; i++) {
                          // make object
                          final musicObject = {
                            'title': musicSuggestion[i]
                                                ['musicTwoColumnItemRenderer']
                                            ['menu']['menuRenderer']['title']
                                        ['musicMenuTitleRenderer']
                                    ['primaryText']['runs'][0]['text']
                                .toString(),
                            // append artist and ignore if it's null
                            'artist': musicSuggestion[i]
                                                    ['musicTwoColumnItemRenderer']
                                                ['menu']['menuRenderer']
                                            ['title']['musicMenuTitleRenderer']
                                        ['secondaryText']['runs'] !=
                                    null
                                ? musicSuggestion[i]['musicTwoColumnItemRenderer']
                                                ['menu']['menuRenderer']
                                            ['title']['musicMenuTitleRenderer']
                                        ['secondaryText']['runs'][0]['text']
                                    .toString()
                                : '',
                            // 'artist': musicSuggestion[i]
                            //                     ['musicTwoColumnItemRenderer']
                            //                 ['menu']['menuRenderer']['title']
                            //             ['musicMenuTitleRenderer']
                            //         ['secondaryText']['runs'][0]['text']
                            //     .toString(),
                            // // if Explicit was found in thee text then it's explicit
                            // // musicSuggestion[i]['musicTwoColumnItemRenderer']['subtitleBadges'][0]['musicInlineBadgeRenderer']?['accessibilityData']['accessibilityData']['label']
                            // 'explicit': if (musicSuggestion[i]['musicTwoColumnItemRenderer']['subtitleBadges'][0]['musicInlineBadgeRenderer']['accessibilityData']['accessibilityData']['label'].toString().contains('Explicit')) true else false,
                            'thumbnail':
                                musicSuggestion[i]['musicTwoColumnItemRenderer']
                                                                ['menu']
                                                            ['menuRenderer']
                                                        ['title']
                                                    ['musicMenuTitleRenderer']
                                                ['thumbnail']
                                            ['musicThumbnailRenderer']
                                        ['thumbnail']['thumbnails'][0]['url']
                                    .toString()
                          };

                          if (musicSuggestion[i]['musicTwoColumnItemRenderer']
                                  ['subtitleBadges'] !=
                              null) {
                            musicObject['explicit'] =
                                musicSuggestion[i]['musicTwoColumnItemRenderer']
                                                    ['subtitleBadges'][0]
                                                ['musicInlineBadgeRenderer']
                                            ['accessibilityData']
                                        ['accessibilityData']['label']
                                    .toString()
                                    .contains('Explicit')
                                    .toString();
                          } else {
                            musicObject['explicit'] = 'false';
                          }

                          final pageType = musicSuggestion[i]
                                          ['musicTwoColumnItemRenderer']
                                      ['navigationEndpoint']['browseEndpoint']
                                  ?['browseEndpointContextSupportedConfigs']
                              ['browseEndpointContextMusicConfig']['pageType'];
                          final artistPageId = musicSuggestion[i]
                                      ['musicTwoColumnItemRenderer']
                                  ['navigationEndpoint']?['browseEndpoint']
                              ?['browseId'];
                          if (pageType == 'MUSIC_PAGE_TYPE_ARTIST') {
                            musicObject['isArtist'] = 'true';
                            musicObject['artistPageId'] = artistPageId;
                          } else {
                            musicObject['isArtist'] = 'false';
                          }
                          
                          final videoId = musicSuggestion[i]
                                      ['musicTwoColumnItemRenderer']
                                  ['navigationEndpoint']?['watchEndpoint']
                              ?['videoId'];
                          if (videoId != null) {
                            musicObject['videoId'] = videoId;
                          }

                          musicSuggestionsList.add(musicObject);
                        }

                        // return the suggestions but divide them into two search suggestions and music suggestions
                        return Column(
                          children: [
                            const SizedBox(height: 20.0),
                            const Text('Search Suggestions'),
                            const SizedBox(height: 20.0),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: suggestionsList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(Icons.search_rounded),
                                  title: Text(suggestionsList[index]),
                                );
                              },
                            ),
                            const SizedBox(height: 20.0),
                            const Text('Music Suggestions'),
                            const SizedBox(height: 20.0),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: musicSuggestionsList.length,
                              // show the music suggestions with image on the left and title and artist on the right
                              itemBuilder: (context, index) {
                                return ListTile(
                                  // if artist make image circle else make it square
                                  leading: musicSuggestionsList[index]
                                              ['isArtist'] ==
                                          'true'
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            musicSuggestionsList[index]
                                                ['thumbnail']!,
                                          ),
                                        )
                                      : Image.network(
                                          musicSuggestionsList[index]
                                              ['thumbnail']!,
                                          height: 56.0,
                                          width: 56.0,
                                        ),
                                  title: Row(
                                    children: [
                                      Text(
                                        musicSuggestionsList[index]['title']!,
                                      ),
                                      // if the music is explicit then show the explicit icon
                                      if (musicSuggestionsList[index]
                                              ['explicit'] ==
                                          'true')
                                        const Icon(Icons.explicit_rounded)
                                    ],
                                  ),
                                  // if artist is set add handler to artist page
                                  onTap: () {
                                    if (musicSuggestionsList[index]
                                            ['isArtist'] ==
                                        'true') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ArtistPage(
                                            artistPageId:
                                                musicSuggestionsList[index]
                                                    ['artistPageId'],
                                          ),
                                        ),
                                      );
                                    } else {
                                      // else add handler to play the music
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlayerPage(
                                            videoId: musicSuggestionsList[index]
                                                ['videoId'],
                                          ),
                                        ),
                                      );

                                    }
                                  },

                                  // use if statement to check if the artist is empty or not
                                  subtitle: musicSuggestionsList[index]
                                              ['artist'] !=
                                          ''
                                      ? Text(
                                          musicSuggestionsList[index]
                                              ['artist']!,
                                        )
                                      : null,
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
                ];
              } else {
                return <Widget>[
                  const SizedBox(height: 20.0),
                  const Center(
                    child: Text('No suggestions'),
                  )
                ];
              }
            },
          ),

          // add dummy listview scrollable
          Expanded(
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
            ),
          )
        ]),
      )),
    );
  }
}
