import 'package:flutter/foundation.dart';
import '../../../core/models/service_model.dart';
import '../../../core/models/task_model.dart';

class PostTaskProvider extends ChangeNotifier {
  String _selectedCategoryId = '';
  String _taskDescription = '';
  List<String> _selectedPhotos = [];
  String _location = '';
  DateTime? _preferredDate;
  String _preferredTime = '';
  double _estimatedBudget = 0;
  bool _useCurrentLocation = false;

  PostTaskProvider() {
    // Initial demo data as requested
    _selectedCategoryId = 'plumbing';
    _taskDescription = 'I need a plumber to fix leaking sink in my kitchen. It\'s been dripping for a few days and getting worse.';
    _location = '123 Maple Street, Toronto, ON, Canada';
    _preferredDate = DateTime(2024, 5, 10);
    _preferredTime = '10:00 AM';
    _estimatedBudget = 100.0;
    _selectedPhotos = ['photo1', 'photo2', 'photo3'];
  }

  String get selectedCategoryId => _selectedCategoryId;
  String get taskDescription => _taskDescription;
  List<String> get selectedPhotos => _selectedPhotos;
  String get location => _location;
  DateTime? get preferredDate => _preferredDate;
  String get preferredTime => _preferredTime;
  double get estimatedBudget => _estimatedBudget;
  bool get useCurrentLocation => _useCurrentLocation;

  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void updateDescription(String description) {
    _taskDescription = description;
    notifyListeners();
  }

  void addPhoto(String photoPath) {
    _selectedPhotos.add(photoPath);
    notifyListeners();
  }

  void removePhoto(int index) {
    if (index >= 0 && index < _selectedPhotos.length) {
      _selectedPhotos.removeAt(index);
      notifyListeners();
    }
  }

  void updateLocation(String location) {
    _location = location;
    notifyListeners();
  }

  void setPreferredDate(DateTime date) {
    _preferredDate = date;
    notifyListeners();
  }

  void setPreferredTime(String time) {
    _preferredTime = time;
    notifyListeners();
  }

  void updateBudget(double budget) {
    _estimatedBudget = budget;
    notifyListeners();
  }

  void toggleUseCurrentLocation(bool value) {
    _useCurrentLocation = value;
    if (value) {
      _location = '123 Maple Street';
    }
    notifyListeners();
  }

  void reset() {
    _selectedCategoryId = '';
    _taskDescription = '';
    _selectedPhotos = [];
    _location = '';
    _preferredDate = null;
    _preferredTime = '';
    _estimatedBudget = 0;
    _useCurrentLocation = false;
    notifyListeners();
  }

  bool get isValid {
    return _selectedCategoryId.isNotEmpty &&
        _taskDescription.isNotEmpty &&
        _location.isNotEmpty &&
        _preferredDate != null &&
        _preferredTime.isNotEmpty;
  }
}
