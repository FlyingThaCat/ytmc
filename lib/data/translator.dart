// Function to extract thumbnails from the JSON data
Map<String, dynamic> extractThumbnails(dynamic rawData) {
  final thumbnails = rawData['header']['musicVisualHeaderRenderer']['thumbnail']
      ['musicThumbnailRenderer']['thumbnail']['thumbnails'];
  final originThumbnail = thumbnails[0]['url'].toString().split('=');

  return {
    'thumbnails': thumbnails,
    'originThumbnail': originThumbnail[0],
  };
}

// Function to extract latest release data from the JSON data
Map<String, dynamic> extractLatestRelease(dynamic rawData) {
  final sections = rawData['contents']['singleColumnBrowseResultsRenderer']
      ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']['contents'];

  Map<String, dynamic> latestReleaseData = {};

  for (final section in sections) {
    if (section.containsKey('musicSpotlightShelfRenderer')) {
      final musicSpotlightShelfRenderer =
          section['musicSpotlightShelfRenderer'];
      final musicSpotlightItemRenderer = musicSpotlightShelfRenderer['contents']
          [0]['musicSpotlightItemRenderer'];
      final title =
          musicSpotlightItemRenderer['header']['runs'][0]['text'].toLowerCase();

      if (title == 'latest release') {
        final latestReleaseThumbnails =
            musicSpotlightItemRenderer['thumbnailRenderer']
                ['musicThumbnailRenderer']['thumbnail']['thumbnails'];
        final latestReleaseTitle =
            musicSpotlightItemRenderer['title']['runs'][0]['text'];
        final latestReleaseType =
            musicSpotlightItemRenderer['subtitle']['runs'][0]['text'];
        final latestReleaseYear =
            musicSpotlightItemRenderer['subtitle']['runs'][2]['text'];
        final latestReleaseBrowseID =
            musicSpotlightItemRenderer['navigationEndpoint']['browseEndpoint']
                ['browseId'];
        //TODO: MAYBE NEED PARAMS ???

        latestReleaseData = {
          'latestReleaseThumbnails': latestReleaseThumbnails,
          'latestReleaseTitle': latestReleaseTitle,
          'latestReleaseType': latestReleaseType,
          'latestReleaseYear': latestReleaseYear,
          'latestReleaseBrowseID': latestReleaseBrowseID,
        };
        continue;
      }
    }
  }
  return latestReleaseData;
}

Map<String, dynamic> extractTopSongs(dynamic rawData) {
  final sections = rawData['contents']['singleColumnBrowseResultsRenderer']
      ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']['contents'];

  Map<String, dynamic> topSongsData = {};

  for (final section in sections) {
    if (section.containsKey('musicShelfRenderer')) {
      final musicShelfRenderer = section['musicShelfRenderer'];
      final title =
          musicShelfRenderer['title']['runs'][0]['text'].toLowerCase();

      if (title == 'top songs') {
        final topSongs = musicShelfRenderer['contents'];
        final browseId = musicShelfRenderer['moreContentButton']
                ['buttonRenderer']['navigationEndpoint']['browseEndpoint']
            ['browseId'];
        final params = musicShelfRenderer['moreContentButton']['buttonRenderer']
            ['navigationEndpoint']['browseEndpoint']['params'];

        topSongsData = {
          'topSongsBrowseID': browseId,
          'topSongsParams': params,
          'topSongsList': topSongs,
        };
        continue;
      }
    }
  }
  return topSongsData;
}

// Function to extract albums data from the JSON data
Map<String, dynamic> extractAlbums(dynamic rawData) {
  final sections = rawData['contents']['singleColumnBrowseResultsRenderer']
      ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']['contents'];

  Map<String, dynamic> albumsData = {};

  for (final section in sections) {
    if (section.containsKey('musicCarouselShelfRenderer')) {
      final musicCarouselShelfRenderer = section['musicCarouselShelfRenderer'];
      final title = musicCarouselShelfRenderer['header']
                  ['musicCarouselShelfBasicHeaderRenderer']['title']['runs'][0]
              ['text']
          .toLowerCase();

      if (title == 'albums') {
        final albumsBrowseID = musicCarouselShelfRenderer['header']
                ['musicCarouselShelfBasicHeaderRenderer']['navigationEndpoint']
            ?['browseEndpoint']?['browseId'];
        final albumsParams = musicCarouselShelfRenderer['header']
                ['musicCarouselShelfBasicHeaderRenderer']['navigationEndpoint']
            ?['browseEndpoint']?['params'];
        final albumsList = musicCarouselShelfRenderer['contents'];

        albumsData = {
          'albumsBrowseID': albumsBrowseID,
          'albumsParams': albumsParams,
          'albumsList': albumsList,
        };
      }
      continue;
    }
  }
  return albumsData;
}

// Function to extract singles data from the JSON data
Map<String, dynamic> extractSingles(dynamic rawData) {
  final sections = rawData['contents']['singleColumnBrowseResultsRenderer']
      ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']['contents'];

  Map<String, dynamic> singlesData = {};

  for (final section in sections) {
    if (section.containsKey('musicCarouselShelfRenderer')) {
      final musicCarouselShelfRenderer = section['musicCarouselShelfRenderer'];
      final title = musicCarouselShelfRenderer['header']
                  ['musicCarouselShelfBasicHeaderRenderer']['title']['runs'][0]
              ['text']
          .toLowerCase();
      if (title == 'singles') {
        final singlesBrowseID = musicCarouselShelfRenderer['header']
                ['musicCarouselShelfBasicHeaderRenderer']['navigationEndpoint']
            ?['browseEndpoint']?['browseId'];
        final singlesParams = musicCarouselShelfRenderer['header']
                ['musicCarouselShelfBasicHeaderRenderer']['navigationEndpoint']
            ?['browseEndpoint']?['params'];
        final singlesList = musicCarouselShelfRenderer['contents'];

        singlesData = {
          'singlesBrowseID': singlesBrowseID,
          'singlesParams': singlesParams,
          'singlesList': singlesList,
        };
      }
      continue;
    }
  }
  return singlesData;
}

// Function to extract videos data from the JSON data
Map<String, dynamic> extractVideos(dynamic rawData) {
  final sections = rawData['contents']['singleColumnBrowseResultsRenderer']
      ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']['contents'];

  Map<String, dynamic> videosData = {};

  for (final section in sections) {
    if (section.containsKey('musicCarouselShelfRenderer')) {
      final musicCarouselShelfRenderer = section['musicCarouselShelfRenderer'];
      final title = musicCarouselShelfRenderer['header']
                  ['musicCarouselShelfBasicHeaderRenderer']['title']['runs'][0]
              ['text']
          .toLowerCase();

      if (title == 'videos') {
        final videosBrowseID = musicCarouselShelfRenderer['header']
                ['musicCarouselShelfBasicHeaderRenderer']['navigationEndpoint']
            ?['browseEndpoint']?['browseId'];
        final videosParams = musicCarouselShelfRenderer['header']
                ['musicCarouselShelfBasicHeaderRenderer']['navigationEndpoint']
            ?['browseEndpoint']?['params'];
        final videosList = musicCarouselShelfRenderer['contents'];

        videosData = {
          'videosBrowseID': videosBrowseID,
          'videosParams': videosParams,
          'videosList': videosList,
        };
      }
      continue;
    }
  }
  return videosData;
}

// Function to extract featured on data from the JSON data
Map<String, dynamic> extractFeaturedPlaylists(dynamic rawData) {
  final sections = rawData['contents']['singleColumnBrowseResultsRenderer']
      ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']['contents'];

  List<dynamic> featuredOn = [];

  for (final section in sections) {
    if (section.containsKey('musicCarouselShelfRenderer')) {
      final musicCarouselShelfRenderer = section['musicCarouselShelfRenderer'];
      final title = musicCarouselShelfRenderer['header']
                  ['musicCarouselShelfBasicHeaderRenderer']['title']['runs'][0]
              ['text']
          .toLowerCase();

      if (title == 'featured on') {
        final featuredOnList = musicCarouselShelfRenderer['contents'];
        featuredOn = featuredOnList;
      }
      continue;
    }
  }
  return {'featuredOnList': featuredOn};
}

// Function to extract related artists data from the JSON data
Map<String, dynamic> extractRelatedArtists(dynamic rawData) {
  final sections = rawData['contents']['singleColumnBrowseResultsRenderer']
      ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']['contents'];

  List<dynamic> relatedArtists = [];

  for (final section in sections) {
    if (section.containsKey('musicCarouselShelfRenderer')) {
      final musicCarouselShelfRenderer = section['musicCarouselShelfRenderer'];
      final title = musicCarouselShelfRenderer['header']
                  ['musicCarouselShelfBasicHeaderRenderer']['title']['runs'][0]
              ['text']
          .toLowerCase();

      if (title == 'fans might also like') {
        final relatedArtistsList = musicCarouselShelfRenderer['contents'];
        relatedArtists = relatedArtistsList;
      }
    }
  }
  return {
    'relatedArtistsList': relatedArtists,
  };
}

// Function to extract artist data from the JSON data
Map<String, dynamic> extractArtist(dynamic rawData) {
  final sections = rawData['contents']['singleColumnBrowseResultsRenderer']
      ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']['contents'];

  Map<String, dynamic> artistData = {};

  for (final section in sections) {
    if (section.containsKey('musicDescriptionShelfRenderer')) {
      final musicDescriptionShelfRenderer =
          section['musicDescriptionShelfRenderer'];
      final title = musicDescriptionShelfRenderer['header']['runs'][0]['text']
          .toLowerCase();

      if (title == 'about') {
        final artistName = rawData['header']['musicVisualHeaderRenderer']
            ['title']['runs'][0]['text'];
        final artistBioViewCounter =
            musicDescriptionShelfRenderer['subheader']['runs'][0]['text'];
        final artistBioContent =
            musicDescriptionShelfRenderer['description']['runs'][0]['text'];
        final artistBioContentShort = artistBioContent.length > 80 ? artistBioContent.substring(0, 80) + '...' : artistBioContent;
        // TODO: MAYBE ADD EXTRACT THUMBNAIL HERE

        artistData = {
          'artistName': artistName,
          'artistBioViewCounter': artistBioViewCounter,
          'artistBioContent': artistBioContent,
          'artistBioContentShort': artistBioContentShort,
        };
        break;
      }
    }
  }
  return artistData;
}

// Function to extract streaming data from the JSON data
Map<String, dynamic> extractStreamingData(dynamic rawData) {
  Map<String, dynamic> streamingDatas = {};

  //Get Streaming Details
  final videoDetails = rawData['videoDetails'];
  final videoId = videoDetails['videoId'];
  final title = videoDetails['title'];
  final lengthSeconds = videoDetails['lengthSeconds'];
  final channelId = videoDetails['channelId'];
  final thumbnails = videoDetails['thumbnail']['thumbnails'];
  final viewCount = videoDetails['viewCount'];
  final author = videoDetails['author'];

  //Get StreamingData
  final streamingData = rawData['streamingData'];
  final expiresInSeconds = streamingData['expiresInSeconds'];
  final formats = streamingData['formats'];
  final adaptiveFormats = streamingData['adaptiveFormats'];

  streamingDatas = {
    'videoId': videoId,
    'title': title,
    'lengthSeconds': lengthSeconds,
    'channelId': channelId,
    'thumbnails': thumbnails,
    'viewCount': viewCount,
    'author': author,
    'expiresInSeconds': expiresInSeconds,
    'formats': formats,
    'adaptiveFormats': adaptiveFormats,
  };

  return streamingDatas;
}
