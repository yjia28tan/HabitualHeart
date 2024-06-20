import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  final String apiKey = 'AIzaSyBNrqXbZwtTrB_gLVZkpPbp7X5TdHDnqRU';
  final String channelId = 'UCN4vyryy6O4GlIXcXTIuZQQ';

  Future<List<Map<String, String>>> fetchMeditationVideos() async {
  final url =
  'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&type=video&key=$apiKey&maxResults=10&q=meditation';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body)['items'];
    return data.map((item) {
      final videoId = item['id']['videoId'].toString();
      final title = item['snippet']['title'].toString();
      return {
        'videoId': videoId,
        'title': title
      };
      }).toList();
    } else {
        throw Exception('Failed to load videos');
      }
    }
  }
