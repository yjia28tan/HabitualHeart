import 'package:flutter/material.dart';
import 'package:habitual_heart_app/design/font_style.dart';
import '../widgets/cardview_discover.dart';
import 'package:habitual_heart_app/data/get_quotes_with_api.dart';
import '/models/quote_model.dart';

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
      body: Column(
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
                        Text(
                          quote?.content ?? 'No quote available',
                          style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '- ${quote?.author ?? 'Unknown'}',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Meditation Tools",
                    style: homeSubHeaderText,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MeditationToolCard(
                    title: 'Mindfulness',
                    description: 'Practice mindfulness meditation',
                    icon: Icons.bubble_chart_rounded,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MeditationToolCard(
                    title: 'Breathing Exercise',
                    description: 'Practice deep breathing exercises',
                    icon: Icons.air,
                  ),
                ),
                // Add more meditation tools here
              ],
            ),
          ),
        ],
      ),
    );
  }
}
