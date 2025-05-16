import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms1/core/constants/app_routes.dart';
import 'package:sizer/sizer.dart';
import '../models/course.dart';
import 'package:intl/intl.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final studentCount = course.students.length;
    final formattedDate = DateFormat('MMM d, yyyy').format(course.createdAt);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          context.push(AppRoutes.courseDetails, extra: course);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => CourseDetailsScreen(course: course)),
          // );
        },
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 12.w,
                      height: 12.w,
                      color: colorScheme.primaryContainer,
                      child: Icon(Icons.book_outlined, size: 6.w),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: textTheme.titleLarge?.copyWith(
                            // fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          course.teacher.name,
                          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                course.description,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.5),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 4.w, color: colorScheme.onSurfaceVariant),
                      SizedBox(width: 2.w),
                      Text(
                        formattedDate,
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.people_outlined, size: 4.w, color: colorScheme.onSurfaceVariant),
                      SizedBox(width: 2.w),
                      Text(
                        '$studentCount Students',
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurfaceVariant,
                        ),
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
