// frontend/lib/widgets/place_timeline_card.dart

import 'package:flutter/material.dart';

class PlaceTimelineCard extends StatelessWidget {
  final String time;
  final String name;
  final String description;
  final Color dotColor;
  final Color cardColor;
  final bool isLast;

  const PlaceTimelineCard({
    Key? key,
    required this.time,
    required this.name,
    required this.description,
    required this.dotColor,
    required this.cardColor,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Column(
            children: [
              Text(
                time, 
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)
              ),
              const SizedBox(height: 8),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 80, 
                  color: Colors.grey.shade300,
                ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20, right: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(
                        description, 
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.4), 
                        maxLines: 2, 
                        overflow: TextOverflow.ellipsis
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
