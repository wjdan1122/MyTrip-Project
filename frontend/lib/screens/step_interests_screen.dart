import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/wizard_progress_bar.dart';
import '../widgets/option_card.dart';

class StepInterestsScreen extends StatelessWidget {
  final Set<String> selectedInterests;
  final ValueChanged<String> onInterestToggled;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepInterestsScreen({
    super.key,
    required this.selectedInterests,
    required this.onInterestToggled,
    required this.onNext,
    required this.onBack,
  });

  static const List<Map<String, dynamic>> _interests = [
    {'key': 'Historical', 'icon': Icons.account_balance, 'label': 'Historical'},
    {'key': 'Shopping', 'icon': Icons.shopping_bag_outlined, 'label': 'Shopping'},
    {'key': 'Cafes', 'icon': Icons.coffee, 'label': 'Cafes'},
    {'key': 'Sports', 'icon': Icons.sports_soccer, 'label': 'Sports'},
    {'key': 'Entertainment', 'icon': Icons.theater_comedy, 'label': 'Entertainment'},
    {'key': 'Nature', 'icon': Icons.park, 'label': 'Nature'},
    {'key': 'Restaurants', 'icon': Icons.restaurant, 'label': 'Restaurants'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top row: Back button on the left
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 24, 0),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios, size: 16),
                label: const Text('Back'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        const WizardProgressBar(currentStep: 3),
        const SizedBox(height: 16),
        const Text(
          'What do you like to do?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Pick as many as you like',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _interests.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final interest = _interests[index];
              final key = interest['key'] as String;
              final isSelected = selectedInterests.contains(key);
              return OptionCard(
                icon: interest['icon'] as IconData,
                title: interest['label'] as String,
                isSelected: isSelected,
                showCheckmark: true,
                accentColor: AppColors.primary,
                iconBackgroundColor: isSelected ? AppColors.primary.withValues(alpha: 0.12) : const Color(0xFFF0F0F5),
                onTap: () => onInterestToggled(key),
              );
            },
          ),
        ),
        // Bottom button
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: selectedInterests.isNotEmpty ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedInterests.isNotEmpty ? AppColors.primary : AppColors.progressInactive,
                foregroundColor: selectedInterests.isNotEmpty ? Colors.white : AppColors.textSecondary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Next', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
