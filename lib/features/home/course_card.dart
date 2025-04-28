import 'package:flutter/material.dart';
import 'course.dart';
import 'package:intl/intl.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    var formattedDate = '';
    if (course.createdAt != null && course.createdAt!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(course.createdAt!);
        formattedDate = DateFormat('MMM d, yyyy').format(dateTime);
      } catch (e) {
        formattedDate = course.createdAt!;
      }
    }

    final studentCount = course.studentsList?.length ?? 0;

    return Card(
      color: theme.colorScheme.surface,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
            ),
            child: Text(
              course.title ?? "Untitled Course",
              style: textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  course.description ?? "No description available",
                  style: textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),

                // Teacher and metadata row
                Row(
                  children: [
                    // Teacher info
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Instructor: ${course.teacher?.name ?? 'Unknown'}",
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Students count
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 18,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$studentCount",
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),

                // Date row
                if (formattedDate.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}