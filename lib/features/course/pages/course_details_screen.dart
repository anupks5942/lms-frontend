import 'package:flutter/material.dart';
import 'package:lms1/core/widgets/custom_loading_dialog.dart';
import 'package:lms1/core/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/course.dart';
import 'package:intl/intl.dart';
import '../providers/course_provider.dart';

class CourseDetailsScreen extends StatelessWidget {
  final Course course;
  const CourseDetailsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final studentCount = course.students.length;
    final formattedDate = DateFormat('MMM d, yyyy').format(course.createdAt);

    final user = context.read<AuthProvider>().getUser();
    final isEnrolled = course.students.any((student) => student.id == user?.id);

    return Scaffold(
      appBar: AppBar(elevation: 0, title: const Text('Course'), centerTitle: true),
      bottomNavigationBar:
          !isEnrolled
              ? Padding(
                padding: EdgeInsets.all(4.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      context.showDialog(message: 'Enrolling');
                      final response = await context.read<CourseProvider>().enrollIntoCourse(course.id);
                      if (context.mounted) context.hideDialog();
                      response.match(
                        (e) {
                          context.showCustomSnackBar(message: e, type: SnackBarType.error);
                        },
                        (_) {
                          context.showCustomSnackBar(message: 'Enrolled Successfully', type: SnackBarType.success);
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      textStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Enroll Now'),
                  ),
                ),
              )
              : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 20.h,
                decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                child: Center(child: Icon(Icons.book_outlined, size: 10.w, color: colorScheme.onPrimaryContainer)),
              ),
              SizedBox(height: 2.h),
              Text(
                course.title,
                style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onSurface),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 5.w, color: colorScheme.onSurfaceVariant),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      course.teacher.name,
                      style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                'Description',
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
              ),
              SizedBox(height: 1.h),
              Text(
                course.description,
                style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.5),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 6.w,
                        backgroundColor: colorScheme.secondaryContainer,
                        child: Icon(Icons.calendar_today_outlined, size: 4.w, color: colorScheme.onSecondaryContainer),
                      ),
                      SizedBox(width: 2.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Created', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                          Text(
                            formattedDate,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 6.w,
                        backgroundColor: colorScheme.tertiaryContainer,
                        child: Icon(Icons.people_outlined, size: 4.w, color: colorScheme.onTertiaryContainer),
                      ),
                      SizedBox(width: 2.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Students', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                          Text(
                            '$studentCount',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
