import '../models/user_model.dart';
import '../models/task_model.dart';

class MockData {
  MockData._();

  static final _users = {
    'customer1': UserModel(
      id: 'customer1',
      phoneNumber: '01012345678',
      name: 'Ahmed Hassan',
      email: 'ahmed@example.com',
      role: UserRole.customer,
      rating: 4.8,
      taskCount: 12,
      completedTasks: 10,
      isVerified: true,
    ),
    'trader1': UserModel(
      id: 'trader1',
      phoneNumber: '01087654321',
      name: 'Mohamed Ali',
      email: 'mohamed@example.com',
      role: UserRole.trader,
      rating: 4.5,
      taskCount: 45,
      completedTasks: 40,
      isVerified: true,
    ),
  };

  static final _tasks = [
    TaskModel(
      id: 'task1',
      title: 'Clean my apartment',
      description: 'Need a thorough cleaning for a 2-bedroom apartment. Includes kitchen, bathroom, and living room. Looking for someone with experience and their own equipment.',
      category: TaskCategory.cleaning,
      budget: 350.0,
      location: 'New Cairo, District 5',
      customerId: 'customer1',
      customerName: 'Ahmed Hassan',
      bidCount: 3,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    TaskModel(
      id: 'task2',
      title: 'Fix leaking faucet',
      description: 'Kitchen faucet is leaking. Need a plumber to fix it ASAP. Parts will be provided.',
      category: TaskCategory.repairs,
      budget: 200.0,
      location: 'Heliopolis, Cairo',
      customerId: 'customer1',
      customerName: 'Ahmed Hassan',
      bidCount: 5,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    TaskModel(
      id: 'task3',
      title: 'Moving assistance',
      description: 'Need help moving furniture from 3rd floor apartment to ground floor. About 10 large items.',
      category: TaskCategory.moving,
      budget: 500.0,
      location: 'Sheikh Zayed, Giza',
      customerId: 'customer1',
      customerName: 'Ahmed Hassan',
      bidCount: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    TaskModel(
      id: 'task4',
      title: 'Deliver documents',
      description: 'Urgent document delivery from Maadi to Nasr City. Must be delivered within 2 hours.',
      category: TaskCategory.delivery,
      budget: 150.0,
      location: 'Maadi, Cairo',
      customerId: 'customer1',
      customerName: 'Ahmed Hassan',
      bidCount: 7,
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    TaskModel(
      id: 'task5',
      title: 'Grocery shopping',
      description: 'Need someone to do weekly grocery shopping. Will provide the list. Budget around 800 EGP.',
      category: TaskCategory.shopping,
      budget: 100.0,
      location: '6th October, Giza',
      customerId: 'customer1',
      customerName: 'Ahmed Hassan',
      bidCount: 4,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  static List<UserModel> getUsers() => _users.values.toList();

  static UserModel? getUserById(String id) => _users[id];

  static List<TaskModel> getTasks() => _tasks;

  static List<TaskModel> getOpenTasks() =>
      _tasks.where((t) => t.status == TaskStatus.open).toList();

  static List<TaskModel> getTasksByCategory(TaskCategory category) =>
      _tasks.where((t) => t.category == category).toList();

  static List<TaskModel> getTasksByCustomer(String customerId) =>
      _tasks.where((t) => t.customerId == customerId).toList();

  static TaskModel? getTaskById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  static UserModel get defaultCustomer => _users['customer1']!;
  static UserModel get defaultTrader => _users['trader1']!;
}
