import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/wizard_progress_bar.dart';
import '../widgets/option_card.dart';

class StepBudgetScreen extends StatelessWidget {
  final String? selectedBudget;
  final ValueChanged<String> onBudgetSelected;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepBudgetScreen({
    super.key,
    required this.selectedBudget,
    required this.onBudgetSelected,
    required this.onNext,
    required this.onBack,
  });

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
        const WizardProgressBar(currentStep: 2),
        const SizedBox(height: 16),
        const Text(
          'What is your budget?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Choose the experience that fits you best',
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
              children: [
                OptionCard(
                  icon: Icons.workspace_premium,
                  title: 'Luxury',
                  subtitle: '5-star stays & fine dining',
                  isSelected: selectedBudget == 'Luxury',
                  accentColor: AppColors.luxuryGold,
                  iconBackgroundColor: AppColors.luxuryGoldBg,
                  onTap: () => onBudgetSelected('Luxury'),
                ),
                const SizedBox(height: 12),
                OptionCard(
                  icon: Icons.hotel,
                  title: 'Moderate',
                  subtitle: 'Comfort with great value',
                  isSelected: selectedBudget == 'Moderate',
                  accentColor: AppColors.moderateBlue,
                  iconBackgroundColor: AppColors.moderateBlueBg,
                  onTap: () => onBudgetSelected('Moderate'),
                ),
                const SizedBox(height: 12),
                OptionCard(
                  icon: Icons.savings,
                  title: 'Economy',
                  subtitle: 'Smart travel on a budget',
                  isSelected: selectedBudget == 'Economy',
                  accentColor: AppColors.economyGreen,
                  iconBackgroundColor: AppColors.economyGreenBg,
                  onTap: () => onBudgetSelected('Economy'),
                ),
              ],
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
              onPressed: selectedBudget != null ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedBudget != null ? AppColors.primary : AppColors.progressInactive,
                foregroundColor: selectedBudget != null ? Colors.white : AppColors.textSecondary,
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
