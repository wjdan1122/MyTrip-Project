import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../widgets/place_timeline_card.dart';

class ItineraryScreen extends StatefulWidget {
  final String destination;
  final String budget;
  final Set<String> interests;
  final String companion;
  final VoidCallback onRestart;

  const ItineraryScreen({
    super.key,
    required this.destination,
    required this.budget,
    required this.interests,
    required this.companion,
    required this.onRestart,
  });

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  late List<List<Map<String, dynamic>>> tripDays;
  int selectedDay = 0;
  bool _isReordering = false;

  static const List<Color> _dotColors = [
    Color(0xFF1B3A5C), // كحلي غامق
    Color(0xFF1A4B6E),
    Color(0xFF2E6B9E),
    Color(0xFF1D3557),
    Color(0xFF264B73),
    Color(0xFF0F2E4A),
    Color(0xFF1E4D78),
  ];

  static const List<Color> _cardColors = [
    Color(0xFFFFF0E8),
    Color(0xFFE8F0FF),
    Color(0xFFE8F5E9),
    Color(0xFFFCE8E8),
    Color(0xFFF3E5F5),
    Color(0xFFFFF3E0),
    Color(0xFFE0F7FA),
  ];

  @override
  void initState() {
    super.initState();
    _generatePlan();
  }

  void _generatePlan() {
    setState(() {
      tripDays = buildTripPlan(
        destination: widget.destination,
        budget: widget.budget,
        interests: widget.interests.toList(),
        companion: widget.companion,
      );
      selectedDay = 0;
    });
  }

  void _regenerateDay() {
    _generatePlan();
  }

  void _deletePlace(int placeIndex) {
    setState(() {
      tripDays[selectedDay].removeAt(placeIndex);
      if (tripDays[selectedDay].isEmpty) {
        tripDays.removeAt(selectedDay);
        if (selectedDay >= tripDays.length && tripDays.isNotEmpty) {
          selectedDay = tripDays.length - 1;
        }
      }
    });
  }

  void _showPlaceDetail(BuildContext context, Map<String, dynamic> place, int colorIndex) {
    final cardColor = _cardColors[colorIndex % _cardColors.length];
    final dotColor = _dotColors[colorIndex % _dotColors.length];

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image area
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Container(
                height: 180,
                color: cardColor,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.photo_camera_outlined,
                      size: 48,
                      color: dotColor.withValues(alpha: 0.3),
                    ),
                    // Close button
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => Navigator.of(ctx).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.close, size: 18, color: Color(0xFF1B3A5C)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place['name'] as String,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B3A5C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: dotColor),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(place['time'] as String),
                        style: TextStyle(
                          fontSize: 13,
                          color: dotColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    place['description'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String time24) {
    final parts = time24.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts.length > 1 ? parts[1] : '00';
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    if (tripDays.isEmpty) {
      return const Center(child: Text('No itinerary available'));
    }

    final currentDayPlaces = tripDays[selectedDay];

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient Header Card
          Container(
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight, // Approximates 135deg
                colors: [
                  Color(0xFF0D2137),
                  Color(0xFF163352),
                  Color(0xFF1E4D7A),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0D2137).withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Itinerary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${widget.destination} · ${widget.companion} · ${widget.budget}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: widget.onRestart,
                      child: Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Day selector
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(tripDays.length, (index) {
                      final isActive = index == selectedDay;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => selectedDay = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isActive ? Colors.transparent : Colors.white.withValues(alpha: 0.20),
                              ),
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              'Day ${index + 1}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isActive ? const Color(0xFF0D2137) : Colors.white.withValues(alpha: 0.70),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Reorder / Regenerate Day Plan
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _isReordering
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Drag to reorder',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () => setState(() => _isReordering = false),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            visualDensity: VisualDensity.compact,
                          ),
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  )
                : Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: IconButton(
                          onPressed: () => setState(() => _isReordering = true),
                          icon: const Icon(Icons.swap_vert, size: 28),
                          color: AppColors.primary,
                          tooltip: 'Reorder places',
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: _regenerateDay,
                        icon: const Icon(Icons.auto_awesome, size: 16),
                        label: const Text('Regenerate Day Plan'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.cardBorder),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 16),

          // Timeline list
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: currentDayPlaces.length,
              buildDefaultDragHandles: false,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  // Keep times fixed — only swap name, description, and other content
                  final currentDay = tripDays[selectedDay];
                  final oldName = currentDay[oldIndex]['name'];
                  final oldDesc = currentDay[oldIndex]['description'];
                  final newName = currentDay[newIndex]['name'];
                  final newDesc = currentDay[newIndex]['description'];
                  currentDay[oldIndex] = Map.from(currentDay[oldIndex])..["name"] = newName..["description"] = newDesc;
                  currentDay[newIndex] = Map.from(currentDay[newIndex])..["name"] = oldName..["description"] = oldDesc;
                });
              },
              proxyDecorator: (child, index, animation) {
                return Material(
                  color: Colors.transparent,
                  child: child,
                );
              },
              itemBuilder: (context, index) {
                final place = currentDayPlaces[index];
                final colorIndex = index % _dotColors.length;
                return PlaceTimelineCard(
                  key: ValueKey('${place['name']}_$index'),
                  time: _formatTime(place['time'] as String),
                  name: place['name'] as String,
                  description: place['description'] as String,
                  dotColor: _dotColors[colorIndex],
                  cardColor: _cardColors[colorIndex],
                  isLast: index == currentDayPlaces.length - 1,
                  isReordering: _isReordering,
                  index: index,
                  onDelete: () => _deletePlace(index),
                  onEditTime: () {},
                  onRegenerate: () {},
                  onTap: () => _showPlaceDetail(context, place, colorIndex),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
