import 'package:flutter/foundation.dart';

class LocationProvider extends ChangeNotifier {
  String _selectedLocation = '';
  bool _useCurrentLocation = false;
  String _searchQuery = '';
  List<String> _savedLocations = ['Home', 'Work'];

  String get selectedLocation => _selectedLocation;
  bool get useCurrentLocation => _useCurrentLocation;
  String get searchQuery => _searchQuery;
  List<String> get savedLocations => _savedLocations;

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleUseCurrentLocation(bool value) {
    _useCurrentLocation = value;
    if (value) {
      _selectedLocation = '123 Maple Street, Toronto, ON, Canada';
    }
    notifyListeners();
  }

  void selectLocation(String location) {
    _selectedLocation = location;
    notifyListeners();
  }
}
