import 'package:flutter/material.dart';
import 'package:habitual_heart_app/design/font_style.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import '../models/meditation_tools.dart';
import '../widgets/cardview_discover.dart';
import 'package:habitual_heart_app/data/get_quotes_with_api.dart';
import '/models/quote_model.dart';
import '/pages/meditation_guide_page.dart';
import 'package:habitual_heart_app/data/youtube_service.dart'; // Import YouTube service

class DiscoverPage extends StatefulWidget {
  static String routeName = '/DiscoverPage';

  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  late Future<QuoteResponse?> quoteFuture;
  final GetQoutesClass qouoteData = GetQoutesClass();
  final YouTubeService _youTubeService = YouTubeService();
  Future<List<Map<String, String>>>? videoFuture;

  @override
  void initState() {
    super.initState();
    quoteFuture = qouoteData.getQuote();
    videoFuture = _youTubeService.fetchMeditationVideos();
  }

  Future<void> _launchURL(String url) async {
    try {
      bool launched = await launch(url);
      if (!launched) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
      // Fallback to opening in web browser if YouTube app cannot handle the URL
      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: false);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // disable back button
        title: Text(
          "Discover",
          style: headerText,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<QuoteResponse?>(
              future: quoteFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Failed to load quote');
                } else if (snapshot.hasData) {
                  final quote = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFE5FFD0).withOpacity(0.7), // Background color
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Daily Quote",
                              style: homeSubHeaderText,
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.person_pin_sharp,
                                  color: Color(0xFF366021),
                                ),
                                Text(
                                  ' ${quote?.author ?? 'Unknown'}',
                                  style: homeSubHeaderText,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            quote?.content ?? 'No quote available',
                            style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Text('No quote available');
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Meditation Guides",
                style: homeSubHeaderText,
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: meditationTools.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.75, // Adjust this ratio as per your design
              ),
              itemBuilder: (context, index) {
                final tool = meditationTools[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MeditationGuidePage(tool: tool),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MeditationToolCard(
                      backgroundImage: tool.backgroundImage,
                      iconData: tool.icon,
                      title: tool.title,
                      description: tool.description,
                    ),
                  ),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Meditation Videos",
                style: homeSubHeaderText,
              ),
            ),
            FutureBuilder<List<Map<String, String>>>(
              future: videoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Failed to load videos');
                } else if (snapshot.hasData) {
                  final videos = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      return ListTile(
                        title: Text(video['title']!),
                        onTap: () {
                          final url = 'https://www.youtube.com/watch?v=${video['videoId']}';
                          _launchURL(url);
                        },
                      );
                    },
                  );
                } else {
                  return Text('No videos available');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
