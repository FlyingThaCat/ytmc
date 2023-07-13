import 'package:flutter/material.dart';

class AlbumsComponent extends StatelessWidget {
  final Map<String, dynamic> albums;

  const AlbumsComponent({super.key, required this.albums});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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

        SizedBox(
          height: 230,
          child: SizedBox(
            width: double.infinity,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 2.5),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: albums['albumsList']?.length != null
                  ? albums['albumsList'].length + 1
                  : 0,
              itemBuilder: (context, index) {
                if (index < albums['albumsList']?.length) {
                  final albumsList = albums['albumsList'];
                  final albumsListTitle = albumsList?[index]
                      ['musicTwoRowItemRenderer']['title']['runs'][0]['text'];
                  final albumsListYear = albumsList?[index]
                          ['musicTwoRowItemRenderer']['subtitle']['runs'][2]
                      ['text'];
                  final albumsExplicit = albumsList?[index]
                              ['musicTwoRowItemRenderer']['subtitleBadges']?[0]
                          ['musicInlineBadgeRenderer']['accessibilityData']
                      ['accessibilityData']['label'];
                  final albumsListThumbnail = albumsList?[index]
                              ['musicTwoRowItemRenderer']['thumbnailRenderer']
                          ['musicThumbnailRenderer']['thumbnail']['thumbnails']
                      [1]['url'];
                  return Container(
                    width: 160,
                    margin:
                        const EdgeInsets.only(top: 12, bottom: 2.5, left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
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
                                      text: albumsListTitle?.toString() ?? '',
                                    ),
                                    if (albumsExplicit == 'Explicit')
                                      const WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Icon(
                                            Icons.explicit_rounded,
                                            size: 14,
                                          ),
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
                } else {
                  if (albums['albumsParams'] != null) {
                    return GestureDetector(
                      onTap: () {
                        // Handle "Show More" functionality
                      },
                      child: Container(
                        width: 160,
                        height: 160,
                        margin: const EdgeInsets.only(
                            top: 12, bottom: 2.5, left: 16),
                        child: Column(
                          children: [
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.5),
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.5),
                                  ],
                                ),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Show More',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
