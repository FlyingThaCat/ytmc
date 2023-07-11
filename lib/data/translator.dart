import 'dart:convert';

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

// Function to extract artist data from the JSON data
Map<String, dynamic> extractArtist(dynamic rawData) {
  final artistBio = rawData['contents']['singleColumnBrowseResultsRenderer']
          ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']
      ['contents'][7]['musicDescriptionShelfRenderer'];
  final artistName = rawData['header']['musicVisualHeaderRenderer']['title']
      ['runs'][0]['text'];
  final artistBioViewCounter = artistBio['subheader']['runs'][0]['text'];
  final artistBioContent = artistBio['description']['runs'][0]['text'];
  final artistBioContentShort = artistBioContent.substring(0, 80) + '...';
  // TODO: MAYBE ADD EXTRACT THUMBNAIL HERE

  return {
    'artistName': artistName,
    'artistBioViewCounter': artistBioViewCounter,
    'artistBioContent': artistBioContent,
    'artistBioContentShort': artistBioContentShort,
  };
}

// Function to extract latest release data from the JSON data
Map<String, dynamic> extractLatestRelease(dynamic rawData) {
  final latestRelease = rawData['contents']['singleColumnBrowseResultsRenderer']
              ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']
          ['contents'][0]['musicSpotlightShelfRenderer']['contents'][0]
      ['musicSpotlightItemRenderer'];
  final latestReleaseThumbnails = latestRelease['thumbnailRenderer']
      ['musicThumbnailRenderer']['thumbnail']['thumbnails'];
  final latestReleaseTitle = latestRelease['title']['runs'][0]['text'];
  final latestReleaseType = latestRelease['subtitle']['runs'][0]['text'];
  final latestReleaseYear = latestRelease['subtitle']['runs'][2]['text'];
  final latestReleaseBrowseID =
      latestRelease['navigationEndpoint']['browseEndpoint']['browseId'];
  //TODO: MAYBE NEED PARAMS ???

  return {
    'latestReleaseThumbnails': latestReleaseThumbnails,
    'latestReleaseTitle': latestReleaseTitle,
    'latestReleaseType': latestReleaseType,
    'latestReleaseYear': latestReleaseYear,
    'latestReleaseBrowseID': latestReleaseBrowseID,
  };
}

// Function to extract top songs data from the JSON data
Map<String, dynamic> extractTopSongs(dynamic rawData) {
  final topSongs = rawData['contents']['singleColumnBrowseResultsRenderer']
          ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']
      ['contents'][1]['musicShelfRenderer'];
  final topSongsBrowseID = topSongs['moreContentButton']['buttonRenderer']
      ['navigationEndpoint']['browseEndpoint']['browseId'];
  final topSongsParams = topSongs['moreContentButton']['buttonRenderer']
      ['navigationEndpoint']['browseEndpoint']['params'];
  final topSongsList = topSongs['contents'];

  return {
    'topSongsBrowseID': topSongsBrowseID,
    'topSongsParams': topSongsParams,
    'topSongsList': topSongsList,
  };
}

// Function to extract albums data from the JSON data
Map<String, dynamic> extractAlbums(dynamic rawData) {
  final albums = rawData['contents']['singleColumnBrowseResultsRenderer']
          ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']
      ['contents'][2]['musicCarouselShelfRenderer'];
  final albumsBrowseID = albums['header']
                  ['musicCarouselShelfBasicHeaderRenderer']
              ['navigationEndpoint']?['browseEndpoint']?['browseId'];
  final albumsParams = albums['header']['musicCarouselShelfBasicHeaderRenderer']
      ['navigationEndpoint']?['browseEndpoint']?['params'];
  final albumsList = albums['contents'];

  return {
    'albumsBrowseID': albumsBrowseID,
    'albumsParams': albumsParams,
    'albumsList': albumsList,
  };
}

// Function to extract singles data from the JSON data
Map<String, dynamic> extractSingles(dynamic rawData) {
  final singles = rawData['contents']['singleColumnBrowseResultsRenderer']
          ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']
      ['contents'][3]['musicCarouselShelfRenderer'];
  final singlesBrowseID = singles['header']
          ['musicCarouselShelfBasicHeaderRenderer']['navigationEndpoint']
      ['browseEndpoint']['browseId'];
  final singlesParams = singles['header']
          ['musicCarouselShelfBasicHeaderRenderer']['navigationEndpoint']
      ['browseEndpoint']['params'];
  final singlesList = singles['contents'];

  return {
    'singlesBrowseID': singlesBrowseID,
    'singlesParams': singlesParams,
    'singlesList': singlesList,
  };
}

// Function to extract videos data from the JSON data
Map<String, dynamic> extractVideos(dynamic rawData) {
  final videos = rawData['contents']['singleColumnBrowseResultsRenderer']
          ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']
      ['contents'][4]['musicCarouselShelfRenderer'];
  final videosBrowseID = videos['header']
          ['musicCarouselShelfBasicHeaderRenderer']['navigationEndpoint']
      ['browseEndpoint']['browseId'];
  final videosParams = videos['header']['musicCarouselShelfBasicHeaderRenderer']
      ['navigationEndpoint']['browseEndpoint']['params'];
  final videosList = videos['contents'];

  return {
    'videosBrowseID': videosBrowseID,
    'videosParams': videosParams,
    'videosList': videosList,
  };
}

// Function to extract featured on data from the JSON data
Map<String, dynamic> extractFeaturedOn(dynamic rawData) {
  final featuredOn = rawData['contents']['singleColumnBrowseResultsRenderer']
          ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']
      ['contents'][5]['musicCarouselShelfRenderer'];
  return {
    'featuredOnList': featuredOn,
  };
}

// Function to extract related artists data from the JSON data
Map<String, dynamic> extractRelatedArtists(dynamic rawData) {
  final relatedArtists = rawData['contents']
              ['singleColumnBrowseResultsRenderer']['tabs'][0]['tabRenderer']
          ['content']['sectionListRenderer']['contents'][6]
      ['musicCarouselShelfRenderer'];

  return {
    'relatedArtistsList': relatedArtists,
  };
}
