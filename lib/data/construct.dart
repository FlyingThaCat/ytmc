// make function to create body of request
Map<String, dynamic> constructAPIBody({
  String clientName = 'ANDROID_MUSIC',
  String clientVersion = '5.26.1',
  String platform = 'MOBILE',
  int androidSdkVersion = 31,
}) {
  return {
    'context': {
      'client': {
        'hl': 'en',
        'gl': 'US',
        'clientName': clientName,
        'clientVersion': clientVersion,
        'platform': platform,
        'androidSdkVersion': androidSdkVersion
      },
      'user': {'lockedSafetyMode': false}
    },
  };
}

// make function that saves artist data

