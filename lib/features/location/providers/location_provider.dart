import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  LatLng _selectedLatLng = const LatLng(43.6532, -79.3832); // Default Toronto
  String _selectedAddress = '123 Maple Street, Toronto, ON, Canada';
  bool _useCurrentLocation = false;
  String _searchQuery = '';
  bool _isLoading = false;

  LatLng get selectedLatLng => _selectedLatLng;
  String get selectedAddress => _selectedAddress;
  bool get useCurrentLocation => _useCurrentLocation;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> updateLocationFromLatLng(LatLng latLng) async {
    _selectedLatLng = latLng;
    _isLoading = true;
    notifyListeners();

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        final pm = placemarks.first;
        _selectedAddress = '${pm.street}, ${pm.locality}, ${pm.administrativeArea}, ${pm.country}';
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateLocationFromAddress(String address, LatLng latLng) async {
    _selectedAddress = address;
    _selectedLatLng = latLng;
    notifyListeners();
  }

  Future<void> updateLocationFromAddressText(String address) async {
    _isLoading = true;
    _selectedAddress = address;
    notifyListeners();

    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        _selectedLatLng = LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      debugPrint('Error getting latlng from address: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleUseCurrentLocation(bool value) async {
    _useCurrentLocation = value;
    if (value) {
      await getCurrentLocation();
    }
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition();
      final latLng = LatLng(position.latitude, position.longitude);
      await updateLocationFromLatLng(latLng);
    } catch (e) {
      debugPrint('Error getting current location: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
