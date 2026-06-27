// frontend/lib/screens/timeline_screen.dart

import 'package:flutter/material.dart';
// استدعاء ملف البيانات والبطاقة
import '../data/mock_data.dart';
import '../widgets/place_timeline_card.dart';

class TimelineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List places = mockTripData['days'][0]['places'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Your Itinerary', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: ListView.builder(
          itemCount: places.length,
          itemBuilder: (context, index) {
            final place = places[index];
            
            final dotColor = index == 0 ? Colors.orange : (index == 1 ? Colors.blue : Colors.teal);
            final cardColor = dotColor.withOpacity(0.1); 

            return PlaceTimelineCard(
              time: place['time'],
              name: place['name'],
              description: place['description'],
              dotColor: dotColor,
              cardColor: cardColor,
              isLast: index == places.length - 1, 
            );
          },
        ),
      ),
    );
  }
}
