import 'package:flutter/material.dart';

class VideosComponent extends StatelessWidget {
  final Map<String, dynamic> videos;

  const VideosComponent({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              itemCount: videos['videosList']?.length != null
                  ? videos['videosList'].length + 1
                  : 0,
              itemBuilder: (context, index) {
                if (index < videos['videosList']?.length) {
                  final videosList = videos['videosList'];
                  final videosListTitle = videosList?[index]
                      ['musicTwoRowItemRenderer']['title']['runs'][0]['text'];
                  final videosListArtist = videosList?[index]
                          ['musicTwoRowItemRenderer']['subtitle']['runs'][0]
                      ['text'];
                  final videosViews = videosList?[index]
                          ['musicTwoRowItemRenderer']['subtitle']['runs'][2]
                      ['text'];
                  final videosListThumbnail = videosList?[index]
                              ['musicTwoRowItemRenderer']['thumbnailRenderer']
                          ['musicThumbnailRenderer']['thumbnail']['thumbnails']
                      [0]['url'];
                  return Container(
                    width: 225,
                    margin:
                        const EdgeInsets.only(top: 12, bottom: 2.5, left: 16),
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
                              borderRadius: BorderRadius.circular(10.0),
                              // add background color to list tile
                              image: DecorationImage(
                                image: NetworkImage(
                                  videosListThumbnail?.toString() ?? '',
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
                                      text: videosListTitle?.toString() ?? '',
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
                } else {
                  return Container(
                    width: 225,
                    margin:
                        const EdgeInsets.only(top: 12, bottom: 2.5, left: 16),
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
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
