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
    Color(0xFFFF6B35),
    Color(0xFF2C5E77),
    Color(0xFF34A853),
    Color(0xFFEA4335),
    Color(0xFF9C27B0),
    Color(0xFFFF9800),
    Color(0xFF00BCD4),
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
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Itinerary',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${widget.destination} · ${widget.companion} · ${widget.budget}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: widget.onRestart,
                      child: Icon(
                        Icons.edit,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Day selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        color: isActive ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive ? AppColors.primary : AppColors.cardBorder,
                        ),
                      ),
                      child: Text(
                        'Day ${index + 1}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isActive ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Places count + regenerate + reorder / Drag to reorder banner
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
                      Text(
                        '${currentDayPlaces.length} places planned',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => setState(() => _isReordering = true),
                        icon: const Icon(Icons.swap_vert),
                        color: AppColors.primary,
                        tooltip: 'Reorder places',
                      ),
                      OutlinedButton.icon(
                        onPressed: _regenerateDay,
                        icon: const Icon(Icons.auto_awesome, size: 16),
                        label: const Text('Regenerate Day Plan'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
                  final item = tripDays[selectedDay].removeAt(oldIndex);
                  tripDays[selectedDay].insert(newIndex, item);
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
