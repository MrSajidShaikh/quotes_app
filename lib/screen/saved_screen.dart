import 'package:flutter/material.dart';
import '../utils/quote_db_helper.dart';

class SavedQuotesScreen extends StatelessWidget {
  const SavedQuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xff015B8A),
          title: const Text('Saved Quotes')),
      body: FutureBuilder<Map<String, List<String>>>(
        future: getSavedQuotesByCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView(
              children: snapshot.data!.entries.map((entry) {
                return ExpansionTile(
                  title: Text(entry.key),
                  children: entry.value.map((quote) {
                    return ListTile(title: Text(quote));
                  }).toList(),
                );
              }).toList(),
            );
          } else {
            return const Center(child: Text('No saved quotes'));
          }
        },
      ),
    );
  }
}