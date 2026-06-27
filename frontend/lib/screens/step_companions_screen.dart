import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/wizard_progress_bar.dart';
import '../widgets/option_card.dart';

class StepCompanionsScreen extends StatelessWidget {
  final String? selectedCompanion;
  final ValueChanged<String> onCompanionSelected;
  final VoidCallback onGenerate;
  final VoidCallback onBack;

  const StepCompanionsScreen({
    super.key,
    required this.selectedCompanion,
    required this.onCompanionSelected,
    required this.onGenerate,
    required this.onBack,
  });

  static const List<Map<String, dynamic>> _companions = [
    {'key': 'Solo', 'icon': Icons.person_outline, 'label': 'Solo', 'subtitle': 'Just you & the world'},
    {'key': 'Family', 'icon': Icons.family_restroom, 'label': 'Family', 'subtitle': 'Fun for everyone'},
    {'key': 'Couple', 'icon': Icons.favorite_outline, 'label': 'Couple', 'subtitle': 'Romantic getaway'},
    {'key': 'Friends', 'icon': Icons.groups_outlined, 'label': 'Friends', 'subtitle': 'Squad adventures'},
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
        const WizardProgressBar(currentStep: 4),
        const SizedBox(height: 16),
        const Text(
          'Who is traveling?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'We\'ll tailor your plan accordingly',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: _companions.map((companion) {
                final key = companion['key'] as String;
                final isSelected = selectedCompanion == key;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: OptionCard(
                    icon: companion['icon'] as IconData,
                    title: companion['label'] as String,
                    subtitle: companion['subtitle'] as String,
                    isSelected: isSelected,
                    showCheckmark: true,
                    accentColor: AppColors.primary,
                    iconBackgroundColor: isSelected ? AppColors.primary.withValues(alpha: 0.12) : const Color(0xFFF0F0F5),
                    onTap: () => onCompanionSelected(key),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // Bottom button
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: selectedCompanion != null ? onGenerate : null,
              icon: const Icon(Icons.auto_awesome, size: 20),
              label: const Text('Generate Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedCompanion != null ? AppColors.primary : AppColors.progressInactive,
                foregroundColor: selectedCompanion != null ? Colors.white : AppColors.textSecondary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                elevation: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
