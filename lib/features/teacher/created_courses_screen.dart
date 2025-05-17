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
        child: const Icon(Icons.add),
        onPressed: () => _showCreateCourseDialog(context),
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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
            ],
          ),
          actions: [
            TextButton(onPressed: context.pop, child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                context.showDialog(message: 'Creating course...');
                final data = {'title': titleController.text.trim(), 'description': descriptionController.text.trim()};
                final response = await context.read<CourseProvider>().createCourse(data);
                if (context.mounted) {
                  context.pop();
                  context.pop();
                }
                response.match(
                  (err) {
                    context.showCustomSnackBar(message: err, type: SnackBarType.error);
                  },
                  (_) {
                    context.showCustomSnackBar(message: 'Course created successfully', type: SnackBarType.success);
                    context.read<CourseProvider>().getCreatedCourses(context);
                  },
                );
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
