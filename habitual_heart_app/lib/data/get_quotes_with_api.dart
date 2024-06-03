import 'dart:convert';
import 'package:http/http.dart' as http;

import '/models/quote_model.dart';

abstract class QoutesData {
  Future<QuoteResponse?> getQuote();
}

class GetQoutesClass implements QoutesData {
  @override
  Future<QuoteResponse?> getQuote() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.quotable.io/random?tags=happiness'),
      );
      if (response.statusCode == 200) {
        return QuoteResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load quote');
      }
    } catch (err) {
      return null;
    }
  }
}
