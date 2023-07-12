import 'package:flutter/material.dart';

class TopSongsComponent extends StatelessWidget {
  final Map<String, dynamic> topSongs;

  const TopSongsComponent({super.key, required this.topSongs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Songs
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

        Column(
          children: [
            ListView.builder(
              padding: const EdgeInsets.only(top: 2.5),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                final topSongsList = topSongs['topSongsList'];
                final topSongsListTitle = topSongsList?[index]
                    ['musicTwoColumnItemRenderer']['title']['runs'][0]['text'];
                final topSongsListSubtitle = topSongsList?[index]
                        ['musicTwoColumnItemRenderer']['subtitle']['runs'][0]
                    ['text'];
                final topSongsListThumbnail = topSongsList?[index]
                            ['musicTwoColumnItemRenderer']['thumbnail']
                        ['musicThumbnailRenderer']['thumbnail']['thumbnails'][1]
                    ['url'];
                return ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
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
            if (topSongs['topSongsParams'] != null) const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Show All'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
