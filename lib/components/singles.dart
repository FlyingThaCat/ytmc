import 'package:flutter/material.dart';

class SinglesComponent extends StatelessWidget {
  final Map<String, dynamic> singles;

  const SinglesComponent({super.key, required this.singles});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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

        // Singles Carousel
        SizedBox(
          height: 230,
          child: SizedBox(
            width: double.infinity,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 2.5),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: singles['singlesList']?.length != null
                  ? singles['singlesList'].length + 1
                  : 0,
              itemBuilder: (context, index) {
                if (index < singles['singlesList']?.length) {
                final singlesList = singles['singlesList'];
                final singlesListTitle = singlesList?[index]
                    ['musicTwoRowItemRenderer']['title']['runs'][0]['text'];
                final singlesListYear = singlesList?[index]
                    ['musicTwoRowItemRenderer']['subtitle']['runs'][0]['text'];
                final singlesExplicit = singlesList?[index]
                            ['musicTwoRowItemRenderer']['subtitleBadges']?[0]
                        ['musicInlineBadgeRenderer']['accessibilityData']
                    ['accessibilityData']['label'];
                final singlesListThumbnail = singlesList?[index]
                            ['musicTwoRowItemRenderer']['thumbnailRenderer']
                        ['musicThumbnailRenderer']['thumbnail']['thumbnails'][2]
                    ['url'];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(top: 12, bottom: 2.5, left: 16),
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
                              singlesListThumbnail?.toString() ?? '',
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
                                    text: singlesListTitle?.toString() ?? '',
                                  ),
                                  if (singlesExplicit == 'Explicit')
                                    const WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Icon(Icons.explicit_rounded,
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
                        singlesListYear?.toString() ?? '',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
                } else {
                  if(singles['singlesParam'] != null) {
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
