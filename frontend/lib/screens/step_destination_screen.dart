import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/wizard_progress_bar.dart';
import '../widgets/option_card.dart';

class StepDestinationScreen extends StatelessWidget {
  final String? selectedDestination;
  final ValueChanged<String> onDestinationSelected;
  final VoidCallback onNext;

  const StepDestinationScreen({
    super.key,
    required this.selectedDestination,
    required this.onDestinationSelected,
    required this.onNext,
  });

  static const List<Map<String, dynamic>> _destinations = [
    {'key': 'الرياض', 'icon': Icons.location_city, 'label': 'Riyadh', 'subtitle': 'The capital city'},
    {'key': 'القصيم', 'icon': Icons.grass, 'label': 'Qassim', 'subtitle': 'Heart of agriculture'},
    {'key': 'جدة', 'icon': Icons.beach_access, 'label': 'Jeddah', 'subtitle': 'Red Sea gateway'},
    {'key': 'أبها', 'icon': Icons.landscape, 'label': 'Abha', 'subtitle': 'Mountain breeze'},
    {'key': 'الدمام', 'icon': Icons.water, 'label': 'Dammam', 'subtitle': 'Eastern coast'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
        const WizardProgressBar(currentStep: 1),
        const SizedBox(height: 16),
        const Text(
          'Where are you going?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Pick your dream destination',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView.separated(
              itemCount: _destinations.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final dest = _destinations[index];
                final key = dest['key'] as String;
                final isSelected = selectedDestination == key;
                return OptionCard(
                  icon: dest['icon'] as IconData,
                  title: dest['label'] as String,
                  subtitle: dest['subtitle'] as String,
                  isSelected: isSelected,
                  showCheckmark: true,
                  accentColor: AppColors.primary,
                  iconBackgroundColor: isSelected
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : const Color(0xFFF0F0F5),
                  onTap: () => onDestinationSelected(key),
                );
              },
            ),
          ),
        ),
        // Bottom button
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: selectedDestination != null ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedDestination != null
                    ? AppColors.primary
                    : AppColors.progressInactive,
                foregroundColor: selectedDestination != null
                    ? Colors.white
                    : AppColors.textSecondary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Next',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, size: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
