import 'package:flutter/material.dart';

class FeaturedPlaylistsComponent extends StatelessWidget {
  final Map<String, dynamic> featuredPlaylists;

  const FeaturedPlaylistsComponent(
      {super.key, required this.featuredPlaylists});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              itemCount: featuredPlaylists['featuredOnList']?.length ?? 0,
              itemBuilder: (context, index) {
                final featuredChannelsList = featuredPlaylists['featuredOnList'];
                final featuredChannelsListTitle = featuredChannelsList?[index]
                    ['musicTwoRowItemRenderer']['title']['runs'][0]['text'];
                final featuredChannelsListThumbnail =
                    featuredChannelsList?[index]['musicTwoRowItemRenderer']
                            ['thumbnailRenderer']['musicThumbnailRenderer']
                        ['thumbnail']['thumbnails'][2]['url'];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(top: 12, bottom: 2.5, left: 16),
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
                            borderRadius: BorderRadius.circular(10.0),
                            // add background color to list tile
                            image: DecorationImage(
                              image: NetworkImage(
                                featuredChannelsListThumbnail?.toString() ?? '',
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
                                    text:
                                        featuredChannelsListTitle?.toString() ??
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
      ],
    );
  }
}
