import 'package:flutter/material.dart';
import '../pages/ArtistPage.dart';

class RelatedArtistsComponent extends StatelessWidget {
  final Map<String, dynamic> relatedArtists;

  const RelatedArtistsComponent({super.key, required this.relatedArtists});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              itemCount: relatedArtists['relatedArtistsList']?.length ?? 0,
              itemBuilder: (context, index) {
                final relatedArtistsList = relatedArtists['relatedArtistsList'];
                final relatedArtistsListTitle = relatedArtistsList?[index]
                    ['musicTwoRowItemRenderer']['title']['runs'][0]['text'];
                final relatedArtistsListThumbnail = relatedArtistsList?[index]
                            ['musicTwoRowItemRenderer']['thumbnailRenderer']
                        ['musicThumbnailRenderer']['thumbnail']['thumbnails'][1]
                    ['url'];
                return GestureDetector(
                  onTap: () {
                    // go to artist page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArtistPage(
                          artistPageId: relatedArtistsList?[index]
                                      ['musicTwoRowItemRenderer']
                                  ['navigationEndpoint']['browseEndpoint']
                              ['browseId'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    // make rounded image
                    width: 160,
                    margin:
                        const EdgeInsets.only(top: 12, bottom: 2.5, left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              // add background color to list tile
                              image: DecorationImage(
                                image: NetworkImage(
                                  relatedArtistsListThumbnail?.toString() ?? '',
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
                                  text:
                                      relatedArtistsListTitle?.toString() ?? '',
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
      ],
    );
  }
}
