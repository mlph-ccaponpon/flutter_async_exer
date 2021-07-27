import 'dart:convert';

import 'package:flutter_async_exer/model/song.dart';
import 'package:http/http.dart' as http;

class SongService {
  // API key
  static const _apiKey = 'd26122ec2bmsh6f47cfe25b322a4p1532f6jsn626e9029f2aa';

  // Base API url
  static const String _baseUrl = 'shazam.p.rapidapi.com';

  // Base headers for API
  static const Map<String, String> _headers = {
    'x-rapidapi-key': _apiKey,
    'x-rapidapi-host': _baseUrl,
  };

  // Get Recommended Songs from Shazam
  Future<List<Song>> getRecommendedSongs() async {
    Uri uri = Uri.https(
        _baseUrl, '/songs/list-recommendations', {'key': '484129036'});
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      final jsonData = json.decode(response.body);
      List<Song> songList = [];

      for (var track in jsonData['tracks']) {
        Song song = Song(track['key'], track['title'], track['subtitle'],
            track['url'], track['images']['background']);
        songList.add(song);
      }

      return songList;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data');
    }
  }

  // Search for a Song given term from Shazam
  Future<List<Song>> searchSong({term: String}) async {
    Uri uri = Uri.https(_baseUrl, '/search', {'term': term});
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      final jsonData = json.decode(response.body);
      List<Song> songList = [];

      for (var hit in jsonData['tracks']['hits']) {
        var track = hit['track'];
        Song song = Song(track['key'], track['title'], track['subtitle'],
            track['url'], track['images']['background']);
        songList.add(song);
      }

      return songList;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data');
    }
  }
}
