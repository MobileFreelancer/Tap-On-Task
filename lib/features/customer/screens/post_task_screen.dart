import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/task_model.dart';
import '../../../core/services/task_service.dart';
import '../../../core/widgets/loading_button.dart';

class PostTaskScreen extends StatefulWidget {
  const PostTaskScreen({super.key});

  @override
  State<PostTaskScreen> createState() => _PostTaskScreenState();
}

class _PostTaskScreenState extends State<PostTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final _locationController = TextEditingController();
  TaskCategory _selectedCategory = TaskCategory.cleaning;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(
        title: const Text('Post a Task'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What do you need done?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Describe your task in detail so taskers can understand exactly what\'s needed.',
                style: TextStyle(fontSize: 13, color: AppColors.textGray500),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  hintText: 'e.g., Clean my apartment',
                ),
                validator: (v) => v == null || v.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe what needs to be done in detail...',
                  alignLabelWithHint: true,
                ),
                validator: (v) => v == null || v.isEmpty ? 'Enter a description' : null,
              ),
              const SizedBox(height: 20),
              Text(
                'Category',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              _buildCategoryGrid(),
              const SizedBox(height: 20),
              TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Budget (EGP)',
                  prefixText: 'EGP ',
                  hintText: '0.00',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter a budget';
                  if (double.tryParse(v) == null || double.parse(v) <= 0) return 'Enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'e.g., New Cairo, District 5',
                  prefixIcon: Icon(Icons.location_on_rounded),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Enter a location' : null,
              ),
              const SizedBox(height: 32),
              Consumer<TaskService>(
                builder: (context, taskService, _) => LoadingButton(
                  label: 'Post Task',
                  isLoading: taskService.isLoading,
                  onPressed: _handleSubmit,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = TaskCategory.values;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((cat) {
        final isSelected = _selectedCategory == cat;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primarySurface : AppColors.backgroundWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primaryPurple : AppColors.borderLight,
              ),
            ),
            child: Text(
              cat.name[0].toUpperCase() + cat.name.substring(1),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.primaryPurple : AppColors.textGray600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final taskService = context.read<TaskService>();
    final success = await taskService.createTask(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      budget: double.parse(_budgetController.text.trim()),
      location: _locationController.text.trim(),
    );

    if (success && mounted) {
      context.goNamed('bookingSuccess');
    }
  }
}
