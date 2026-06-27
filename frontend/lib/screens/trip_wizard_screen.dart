import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'step_destination_screen.dart';
import 'step_budget_screen.dart';
import 'step_interests_screen.dart';
import 'step_companions_screen.dart';
import 'itinerary_screen.dart';

class TripWizardScreen extends StatefulWidget {
  const TripWizardScreen({super.key});

  @override
  State<TripWizardScreen> createState() => _TripWizardScreenState();
}

class _TripWizardScreenState extends State<TripWizardScreen> {
  int _currentStep = 0; // 0=budget, 1=interests, 2=companion, 3=itinerary

  // Wizard data - using Arabic keys for mock data compatibility
  String? _selectedDestination;
  String? _selectedBudget;
  final Set<String> _selectedInterests = {};
  String? _selectedCompanion;

  // Mapping from English UI labels to Arabic mock data keys
  static const Map<String, String> _budgetMap = {
    'Luxury': 'فخم',
    'Moderate': 'متوسط',
    'Economy': 'اقتصادي',
  };

  static const Map<String, String> _interestMap = {
    'Historical': 'تاريخي',
    'Shopping': 'أسواق',
    'Cafes': 'مقاهي',
    'Sports': 'رياضة',
    'Entertainment': 'ترفيه',
    'Nature': 'طبيعة',
    'Restaurants': 'مطاعم',
  };

  static const Map<String, String> _companionMap = {
    'Solo': 'فرد',
    'Family': 'عائلة',
    'Couple': 'زوج',
    'Friends': 'أصدقاء',
  };

  void _goToStep(int step) {
    setState(() => _currentStep = step);
  }

  void _resetWizard() {
    setState(() {
      _currentStep = 0;
      _selectedDestination = null;
      _selectedBudget = null;
      _selectedInterests.clear();
      _selectedCompanion = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                )),
                child: child,
              ),
            );
          },
          child: _buildCurrentStep(),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return StepDestinationScreen(
          key: const ValueKey('destination'),
          selectedDestination: _selectedDestination,
          onDestinationSelected: (dest) => setState(() => _selectedDestination = dest),
          onNext: () => _goToStep(1),
        );
      case 1:
        return StepBudgetScreen(
          key: const ValueKey('budget'),
          selectedBudget: _selectedBudget,
          onBudgetSelected: (budget) => setState(() => _selectedBudget = budget),
          onNext: () => _goToStep(2),
          onBack: () => _goToStep(0),
        );
      case 2:
        return StepInterestsScreen(
          key: const ValueKey('interests'),
          selectedInterests: _selectedInterests,
          onInterestToggled: (interest) {
            setState(() {
              if (_selectedInterests.contains(interest)) {
                _selectedInterests.remove(interest);
              } else {
                _selectedInterests.add(interest);
              }
            });
          },
          onNext: () => _goToStep(3),
          onBack: () => _goToStep(1),
        );
      case 3:
        return StepCompanionsScreen(
          key: const ValueKey('companions'),
          selectedCompanion: _selectedCompanion,
          onCompanionSelected: (companion) => setState(() => _selectedCompanion = companion),
          onGenerate: () => _goToStep(4),
          onBack: () => _goToStep(2),
        );
      case 4:
        return ItineraryScreen(
          key: const ValueKey('itinerary'),
          destination: _selectedDestination ?? 'الرياض',
          budget: _budgetMap[_selectedBudget] ?? 'متوسط',
          interests: _selectedInterests.map((e) => _interestMap[e] ?? e).toSet(),
          companion: _companionMap[_selectedCompanion] ?? 'فرد',
          onRestart: _resetWizard,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
