import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms1/core/services/validation_service.dart';
import 'package:lms1/core/widgets/custom_loading_dialog.dart';
import 'package:lms1/core/widgets/custom_snackbar.dart';
import 'package:lms1/core/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../student/course/providers/course_provider.dart';
import '../student/course/widgets/course_card.dart';

class CreatedCoursesScreen extends StatelessWidget {
  const CreatedCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create course',
        onPressed: () => _showCreateCourseDialog(context),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<CourseProvider>().getCreatedCourses(context),
        child: Consumer<CourseProvider>(
          builder: (context, courseProvider, child) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 80.h),
                child: _buildCourses(context, courseProvider),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCourses(BuildContext context, CourseProvider courseProvider) {
    if (courseProvider.isCreatedLoading) {
      return SizedBox(height: 80.h, child: const Center(child: CircularProgressIndicator()));
    }

    if (courseProvider.errorMessage.isNotEmpty) {
      return SizedBox(
        height: 80.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                courseProvider.errorMessage,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              ElevatedButton(onPressed: () => courseProvider.getCreatedCourses(context), child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (courseProvider.createdCourses.isEmpty) {
      return SizedBox(
        height: 80.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 10.w, color: Colors.grey),
              SizedBox(height: 2.h),
              Text('No courses found', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 1.h),
              Text(
                'Click on + button to create a course',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courseProvider.createdCourses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 0.5.h),
          child: CourseCard(course: courseProvider.createdCourses[index]),
        );
      },
    );
  }

  void _showCreateCourseDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final textTheme = theme.textTheme;
        final colorScheme = theme.colorScheme;
        final courseProvider = context.watch<CourseProvider>();

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: colorScheme.surfaceContainer,
          title: Text(
            'Create Course',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: titleController,
                  hintText: 'Title',
                  validator: ValidationService.courseValidation,
                ),
                SizedBox(height: 2.h),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  validator: ValidationService.courseValidation,
                ),
                SizedBox(height: 2.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outlineVariant, width: 1),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value:
                        selectedCategory ??
                        (courseProvider.categories.isNotEmpty ? courseProvider.categories.first : null),
                    items:
                        courseProvider.categories.isNotEmpty
                            ? courseProvider.categories
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(
                                      category,
                                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                                    ),
                                  ),
                                )
                                .toList()
                            : [
                              DropdownMenuItem(
                                value: null,
                                child: Text(
                                  'No categories',
                                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                                ),
                              ),
                            ],
                    onChanged:
                        courseProvider.categories.isNotEmpty
                            ? (value) {
                              selectedCategory = value;
                              (context as Element).markNeedsBuild();
                            }
                            : null,
                    underline: const SizedBox(),
                    icon: Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant),
                    borderRadius: BorderRadius.circular(12),
                    dropdownColor: colorScheme.surfaceContainerHighest,
                    hint: Text(
                      'Select category',
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onSurfaceVariant,
                textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();
                if (ValidationService.courseValidation(title) != null ||
                    ValidationService.courseValidation(description) != null ||
                    selectedCategory == null) {
                  context.showCustomSnackBar(message: 'Please fill all fields correctly', type: SnackBarType.error);
                  return;
                }
                context.showDialog(message: 'Creating course...');
                final data = {'title': title, 'description': description, 'category': selectedCategory};
                final response = await context.read<CourseProvider>().createCourse(data);
                if (context.mounted) {
                  context.pop();
                  context.pop();
                  response.match(
                    (err) {
                      context.showCustomSnackBar(message: err, type: SnackBarType.error);
                    },
                    (_) {
                      context.showCustomSnackBar(message: 'Course created successfully', type: SnackBarType.success);
                      context.read<CourseProvider>().getCreatedCourses(context);
                    },
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
                textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
