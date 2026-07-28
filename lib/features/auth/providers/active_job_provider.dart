import 'package:flutter/material.dart';

class StepData {
  final String label;
  final IconData icon;

  StepData({required this.label, required this.icon});
}

class TimelineUpdate {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final bool isCompleted;

  TimelineUpdate({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.isCompleted,
  });
}



class ActiveJobProvider extends ChangeNotifier {
  // Current active step index (0-indexed)
  int _currentStepIndex = 2;

  int get currentStepIndex => _currentStepIndex;

  // Stepper items list
  final List<StepData> _steps = [
    StepData(label: 'Accepted', icon: Icons.check),
    StepData(label: 'Assigned', icon: Icons.check),
    StepData(label: 'On The Way', icon: Icons.directions_car),
    StepData(label: 'In Progress', icon: Icons.build),
    StepData(label: 'Finished', icon: Icons.flag),
  ];

  List<StepData> get steps => _steps;

  // Timeline update history
  final List<TimelineUpdate> _timelineUpdates = [
    TimelineUpdate(
      title: 'Mike is on the way',
      subtitle: 'Mike has started his trip to your location.',
      time: '9:20 AM',
      icon: Icons.directions_car,
      isCompleted: false,
    ),
    TimelineUpdate(
      title: 'Job assigned',
      subtitle: 'Mike has started his trip to your location.',
      time: '9:05 AM',
      icon: Icons.check,
      isCompleted: true,
    ),
    TimelineUpdate(
      title: 'Quote accepted',
      subtitle: 'Mike has started his trip to your location.',
      time: '9:00 AM',
      icon: Icons.check,
      isCompleted: true,
    ),
  ];

  List<TimelineUpdate> get timelineUpdates => _timelineUpdates;

  // --- LOGIC METHODS ---

  // Advance to next step
  void nextStep() {
    if (_currentStepIndex < _steps.length - 1) {
      _currentStepIndex++;
      notifyListeners();
    }
  }

  // Go back to previous step
  void previousStep() {
    if (_currentStepIndex > 0) {
      _currentStepIndex--;
      notifyListeners();
    }
  }

  // Jump to a specific step directly
  void setStep(int index) {
    if (index >= 0 && index < _steps.length) {
      _currentStepIndex = index;
      notifyListeners();
    }
  }

  // Helper getters for UI status dynamic texts
  String get currentStatusTitle {
    switch (_currentStepIndex) {
      case 0:
        return 'Quote Accepted';
      case 1:
        return 'Job Assigned';
      case 2:
        return 'On the way';
      case 3:
        return 'Job in Progress';
      case 4:
        return 'Job Finished';
      default:
        return '';
    }
  }

  String get currentStatusSubtitle {
    switch (_currentStepIndex) {
      case 0:
        return 'Your quote was accepted by the trader.';
      case 1:
        return 'Trader Mike Wilson has been assigned to your job.';
      case 2:
        return 'Mike is on the way to your location and will arrive in';
      case 3:
        return 'Mike is currently working on fixing your kitchen sink.';
      case 4:
        return 'The job has been completed successfully.';
      default:
        return '';
    }
  }
}