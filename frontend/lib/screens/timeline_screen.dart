import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/place_timeline_card.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final List<String> destinations = ['الرياض', 'القصيم', 'جدة', 'أبها', 'الدمام'];
  final List<String> budgets = ['اقتصادي', 'متوسط', 'فخم'];
  final List<String> interests = ['تاريخي', 'أسواق', 'مقاهي', 'رياضة', 'ترفيه', 'طبيعة', 'مطاعم'];
  final List<String> companions = ['فرد', 'زوج', 'أصدقاء', 'عائلة'];

  late String selectedDestination;
  late String selectedBudget;
  late String selectedCompanion;
  late Set<String> selectedInterests;
  List<List<Map<String, dynamic>>> tripDays = [];
  bool showPlan = false;

  @override
  void initState() {
    super.initState();
    selectedDestination = destinations.first;
    selectedBudget = budgets[1];
    selectedCompanion = companions[2];
    selectedInterests = {'تاريخي', 'مقاهي', 'مطاعم'};
  }

  void _generatePlan() {
    setState(() {
      tripDays = buildTripPlan(
        destination: selectedDestination,
        budget: selectedBudget,
        interests: selectedInterests.toList(),
        companion: selectedCompanion,
      );
      showPlan = true;
    });
  }

  void _resetPlanner() {
    setState(() {
      showPlan = false;
      tripDays = [];
    });
  }

  void _deletePlace(int dayIndex, int placeIndex) {
    setState(() {
      tripDays[dayIndex].removeAt(placeIndex);
      if (tripDays[dayIndex].isEmpty) {
        tripDays.removeAt(dayIndex);
      }
    });
  }

  void _reorderPlaces(int dayIndex, int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = tripDays[dayIndex].removeAt(oldIndex);
      tripDays[dayIndex].insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(showPlan ? 'الخطة المقترحة' : 'تخطيط رحلتك الذكية', style: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            if (showPlan)
              IconButton(
                onPressed: _resetPlanner,
                icon: const Icon(Icons.refresh),
                tooltip: 'إعادة الإعداد',
              ),
          ],
        ),
        body: showPlan ? _buildItineraryView() : _buildPlannerForm(),
      ),
    );
  }

  Widget _buildPlannerForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ابدأ رحلتك الذكية', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('سنختار لك 3 أيام من الأماكن المناسبة وفق اهتماماتك وميزانيتك.', style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 16),
                  _buildSectionTitle('1) اختر الوجهة'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: destinations.map((destination) {
                      return ChoiceChip(
                        label: Text(destination),
                        selected: selectedDestination == destination,
                        onSelected: (_) => setState(() => selectedDestination = destination),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('2) ميزانيتك'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: budgets.map((budget) {
                      return ChoiceChip(
                        label: Text(budget),
                        selected: selectedBudget == budget,
                        onSelected: (_) => setState(() => selectedBudget = budget),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('3) اهتماماتك'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: interests.map((interest) {
                      final selected = selectedInterests.contains(interest);
                      return FilterChip(
                        label: Text(interest),
                        selected: selected,
                        onSelected: (_) {
                          setState(() {
                            if (selected) {
                              selectedInterests.remove(interest);
                            } else {
                              selectedInterests.add(interest);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('4) هل تسافر مع من؟'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: companions.map((person) {
                      return ChoiceChip(
                        label: Text(person),
                        selected: selectedCompanion == person,
                        onSelected: (_) => setState(() => selectedCompanion = person),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _generatePlan,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('إنشاء الخطة'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الوجهة: $selectedDestination', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text('الميزانية: $selectedBudget  •  المعاد: $selectedCompanion', style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 6),
                  Text('الاهتمامات: ${selectedInterests.join('، ')}', style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Text('تعديل الخطة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton.icon(
                onPressed: _generatePlan,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة إنشاء'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: DefaultTabController(
            length: tripDays.length,
            child: Column(
              children: [
                TabBar(
                  tabs: List.generate(tripDays.length, (index) => Tab(text: 'اليوم ${index + 1}')),
                  labelColor: Colors.indigo,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.indigo,
                ),
                Expanded(
                  child: TabBarView(
                    children: List.generate(tripDays.length, (dayIndex) {
                      final dayPlaces = tripDays[dayIndex];
                      return ReorderableListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: dayPlaces.length,
                        onReorder: (oldIndex, newIndex) => _reorderPlaces(dayIndex, oldIndex, newIndex),
                        itemBuilder: (context, index) {
                          final place = dayPlaces[index];
                          final dotColor = index == 0 ? Colors.orange : (index == 1 ? Colors.blue : Colors.teal);
                          return Padding(
                            key: ValueKey('${dayIndex}_$index'),
                            padding: const EdgeInsets.only(bottom: 8),
                            child: PlaceTimelineCard(
                              time: place['time'] as String,
                              name: place['name'] as String,
                              description: place['description'] as String,
                              dotColor: dotColor,
                              cardColor: dotColor.withOpacity(0.12),
                              isLast: index == dayPlaces.length - 1,
                              onDelete: () => _deletePlace(dayIndex, index),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
    );
  }
}
