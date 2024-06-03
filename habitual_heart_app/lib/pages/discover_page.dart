import 'package:flutter/material.dart';
import 'package:habitual_heart_app/design/font_style.dart';
import '../models/meditation_tools.dart';
import '../widgets/cardview_discover.dart';
import 'package:habitual_heart_app/data/get_quotes_with_api.dart';
import '/models/quote_model.dart';
import 'meditation_guide_page.dart';

class DiscoverPage extends StatefulWidget {
  static String routeName = '/DiscoverPage';

  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  late Future<QuoteResponse?> quoteFuture;
  final GetQoutesClass qouoteData = GetQoutesClass();

  @override
  void initState() {
    super.initState();
    quoteFuture = qouoteData.getQuote();
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
                        color: Color(0xFFE5FFD0).withOpacity(0.7),// Background color
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
                                  color: Color(0xFF366021,),
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
                "Meditation Tools",
                style: homeSubHeaderText,
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: meditationTools.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                final tool = meditationTools[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MeditationToolCard(
                    title: tool.title,
                    description: tool.description,
                    icon: tool.icon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeditationGuidePage(tool: tool),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
