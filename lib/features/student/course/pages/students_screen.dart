import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../auth/widgets/user_card.dart';
import '../models/course.dart';

class EnrolledStudentsScreen extends StatelessWidget {
  final Course course;

  const EnrolledStudentsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surfaceContainer,
        title: const Text('Enrolled Students'),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (course.students.isEmpty)
                SizedBox(
                  height: 80.h,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 10.w,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'No students enrolled',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Check back later for updates',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: course.students.length,
                  itemBuilder: (context, index) {
                    return UserCard(student: course.students[index]);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
