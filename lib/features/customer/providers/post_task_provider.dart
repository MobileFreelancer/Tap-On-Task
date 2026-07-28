import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/models/api_category_model.dart';
import '../../../core/services/api_service.dart';

class PostTaskProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  final ImagePicker _picker = ImagePicker();
  
  List<ApiCategory> _categories = [];
  bool _isLoadingCategories = false;
  String? _categoryError;

  bool _isPosting = false;
  String? _postError;

  String _selectedCategoryId = '';
  String _selectedSubcategoryId = '';
  String _taskDescription = '';
  List<String> _selectedPhotos = [];
  String _location = '123 Maple Street, Toronto, ON, Canada';
  DateTime? _preferredDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  double _estimatedBudget = 100.0;
  bool _useCurrentLocation = false;

  PostTaskProvider() {
    _preferredDate = DateTime.now();
    _startTime = const TimeOfDay(hour: 10, minute: 0);
    _endTime = const TimeOfDay(hour: 12, minute: 0);
    
    // Fetch categories on init
    fetchCategories();
  }

  // Getters
  List<ApiCategory> get categories => _categories;
  bool get isLoadingCategories => _isLoadingCategories;
  String? get categoryError => _categoryError;

  bool get isPosting => _isPosting;
  String? get postError => _postError;

  String get selectedCategoryId => _selectedCategoryId;
  String get selectedSubcategoryId => _selectedSubcategoryId;
  String get taskDescription => _taskDescription;
  List<String> get selectedPhotos => _selectedPhotos;
  String get location => _location;
  DateTime? get preferredDate => _preferredDate;
  TimeOfDay? get startTime => _startTime;
  TimeOfDay? get endTime => _endTime;
  double get estimatedBudget => _estimatedBudget;
  bool get useCurrentLocation => _useCurrentLocation;

  String get formattedDate => _preferredDate != null
      ? DateFormat('MMM dd, yyyy').format(_preferredDate!)
      : 'Select Date';

  String formattedTime(BuildContext context) {
    if (_startTime != null && _endTime != null) {
      return '${_startTime!.format(context)} - ${_endTime!.format(context)}';
    } else if (_startTime != null) {
      return _startTime!.format(context);
    }
    return 'Select Time';
  }

  // API Calls
  Future<void> fetchCategories() async {
    _isLoadingCategories = true;
    _categoryError = null;
    notifyListeners();

    try {
      _categories = await _api.getCategories();
    } catch (e) {
      _categoryError = e.toString();
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  /// Helper to format TimeOfDay into "g:i A" (e.g., 1:30 PM) as required by the API
  String _formatTimeForApi(TimeOfDay? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    // 'h:mm a' matches 'g:i A' (12-hour format, no leading zero on hour, uppercase AM/PM)
    return DateFormat('h:mm a').format(dt).toUpperCase();
  }

  Future<bool> addJob(BuildContext context) async {
    _isPosting = true;
    _postError = null;
    notifyListeners();

    try {
      final String formattedPrefDate = DateFormat('yyyy-MM-dd').format(_preferredDate ?? DateTime.now());
      
      final String startTimeStr = _formatTimeForApi(_startTime);
      final String endTimeStr = _formatTimeForApi(_endTime);

      final Map<String, dynamic> jobData = {
        'category_id': _selectedCategoryId,
        'subcategory_id': _selectedSubcategoryId,
        'description': _taskDescription,
        'preferred_date': formattedPrefDate,
        'preferred_time_start': startTimeStr,
        'preferred_time_end': endTimeStr,
        'location_type': 'custom',
        'address': _location,
        'latitude': 43.6532,
        'longitude': 79.3832,
        'budget_type': 'fixed',
        'budget_amount': _estimatedBudget,
        'status': 'draft',
        'photos': _selectedPhotos,
      };

      final response = await _api.addJob(jobData);
      
      if (response['status'] == 'success') {
        return true;
      } else {
        _postError = response['message'] ?? 'Failed to add job';
        return false;
      }
    } catch (e) {
      _postError = e.toString();
      return false;
    } finally {
      _isPosting = false;
      notifyListeners();
    }
  }

  // State Updates
  void selectCategory(String categoryId) {
    if (_selectedCategoryId != categoryId) {
      _selectedCategoryId = categoryId;
      _selectedSubcategoryId = '';
      notifyListeners();
    }
  }

  void selectSubcategory(String subcategoryId) {
    _selectedSubcategoryId = subcategoryId;
    notifyListeners();
  }

  void updateDescription(String description) {
    _taskDescription = description;
    notifyListeners();
  }

  void updateLocation(String location) {
    _location = location;
    notifyListeners();
  }

  void updateBudget(double budget) {
    _estimatedBudget = budget;
    notifyListeners();
  }

  void toggleUseCurrentLocation(bool value) {
    _useCurrentLocation = value;
    if (value) {
      _location = 'Current Location Address'; 
    }
    notifyListeners();
  }

  // Image Management Logic
  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        _selectedPhotos.addAll(images.map((image) => image.path));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    }
  }

  void removePhoto(int index) {
    if (index >= 0 && index < _selectedPhotos.length) {
      _selectedPhotos.removeAt(index);
      notifyListeners();
    }
  }

  // Date & Time Selection Logic
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _preferredDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _preferredDate) {
      _preferredDate = picked;
      notifyListeners();
    }
  }

  Future<void> selectTimeRange(BuildContext context) async {
    // Select Start Time
    final TimeOfDay? startPicked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
      helpText: 'SELECT START TIME',
    );
    
    if (startPicked == null) return;

    // Select End Time
    if (context.mounted) {
      final TimeOfDay? endPicked = await showTimePicker(
        context: context,
        initialTime: _endTime ?? TimeOfDay(hour: (startPicked.hour + 2) % 24, minute: startPicked.minute),
        helpText: 'SELECT END TIME',
      );

      if (endPicked != null) {
        _startTime = startPicked;
        _endTime = endPicked;
        notifyListeners();
      }
    }
  }

  void reset() {
    _selectedCategoryId = '';
    _selectedSubcategoryId = '';
    _taskDescription = '';
    _selectedPhotos = [];
    _location = '123 Maple Street, Toronto, ON, Canada';
    _preferredDate = DateTime.now();
    _startTime = const TimeOfDay(hour: 10, minute: 0);
    _endTime = const TimeOfDay(hour: 12, minute: 0);
    _estimatedBudget = 100.0;
    _useCurrentLocation = false;
    notifyListeners();
  }

  bool get isValid {
    return _selectedCategoryId.isNotEmpty &&
        _selectedSubcategoryId.isNotEmpty &&
        _taskDescription.isNotEmpty &&
        _location.isNotEmpty &&
        _preferredDate != null &&
        _startTime != null &&
        _endTime != null;
  }
}
