import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../models/task_model.dart';
import 'api_service.dart';
import 'mock_data.dart';
import 'auth_service.dart';

class TaskService extends ChangeNotifier {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  final ApiService _api = ApiService();
  final AuthService _auth = AuthService();

  List<TaskModel> _tasks = [];
  List<TaskModel> _myTasks = [];
  final List<TaskBidModel> _myBids = [];
  bool _isLoading = false;
  String? _error;

  List<TaskModel> get tasks => _tasks;
  List<TaskModel> get myTasks => _myTasks;
  List<TaskBidModel> get myBids => _myBids;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? v) {
    _error = v;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> fetchTasks({TaskCategory? category}) async {
    _setLoading(true);
    _setError(null);
    try {
      if (ApiConfig.useMock) {
        await Future.delayed(const Duration(milliseconds: 500));
        _tasks = category != null
            ? MockData.getTasksByCategory(category)
            : MockData.getOpenTasks();
        _setLoading(false);
        return;
      }

      final data = await _api.getTasks(
        category: category?.name,
        status: 'open',
      );
      _tasks = data.map((json) => TaskModel.fromJson(json as Map<String, dynamic>)).toList();
      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Failed to load tasks.');
    }
  }

  Future<void> fetchMyTasks() async {
    _setLoading(true);
    _setError(null);
    try {
      if (ApiConfig.useMock) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (_auth.isCustomer) {
          _myTasks = MockData.getTasksByCustomer(_auth.currentUser!.id);
        } else {
          _myTasks = MockData.getOpenTasks();
        }
        _setLoading(false);
        return;
      }

      final data = await _api.getTasks();
      _myTasks = data.map((json) => TaskModel.fromJson(json as Map<String, dynamic>)).toList();
      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Failed to load your tasks.');
    }
  }

  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      if (ApiConfig.useMock) {
        await Future.delayed(const Duration(milliseconds: 300));
        return MockData.getTaskById(taskId);
      }

      final data = await _api.getTaskById(taskId);
      return TaskModel.fromJson(data);
    } catch (e) {
      _setError('Failed to load task details.');
      return null;
    }
  }

  Future<bool> createTask({
    required String title,
    required String description,
    required TaskCategory category,
    required double budget,
    required String location,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      if (ApiConfig.useMock) {
        await Future.delayed(const Duration(seconds: 1));
        final newTask = TaskModel(
          id: 'task${DateTime.now().millisecondsSinceEpoch}',
          title: title,
          description: description,
          category: category,
          budget: budget,
          location: location,
          customerId: _auth.currentUser?.id ?? '',
          customerName: _auth.currentUser?.name,
        );
        _myTasks.insert(0, newTask);
        _setLoading(false);
        return true;
      }

      await _api.createTask({
        'title': title,
        'description': description,
        'category': category.name,
        'budget': budget,
        'location': location,
      });
      await fetchMyTasks();
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Failed to create task.');
      return false;
    }
  }

  Future<bool> placeBid({
    required String taskId,
    required double amount,
    String? message,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      if (ApiConfig.useMock) {
        await Future.delayed(const Duration(seconds: 1));
        final bid = TaskBidModel(
          id: 'bid${DateTime.now().millisecondsSinceEpoch}',
          taskId: taskId,
          traderId: _auth.currentUser?.id ?? '',
          traderName: _auth.currentUser?.name,
          amount: amount,
          message: message,
        );
        _myBids.insert(0, bid);
        _setLoading(false);
        return true;
      }

      await _api.placeBid(taskId, amount, message: message);
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Failed to place bid.');
      return false;
    }
  }

  Future<bool> updateTaskStatus(String taskId, String status) async {
    try {
      if (ApiConfig.useMock) {
        await Future.delayed(const Duration(milliseconds: 500));
        final index = _myTasks.indexWhere((t) => t.id == taskId);
        if (index != -1) {
          final updatedStatus = TaskStatus.values.firstWhere(
            (s) => s.name == status,
            orElse: () => TaskStatus.open,
          );
          _myTasks[index] = _myTasks[index].copyWith(status: updatedStatus);
          notifyListeners();
        }
        return true;
      }

      await _api.updateTaskStatus(taskId, status);
      await fetchMyTasks();
      return true;
    } catch (e) {
      _setError('Failed to update task status.');
      return false;
    }
  }
}
