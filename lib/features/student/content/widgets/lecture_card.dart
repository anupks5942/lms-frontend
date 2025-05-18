import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms1/core/constants/app_routes.dart';
import 'package:sizer/sizer.dart';
import '../models/lecture_model.dart';

class LectureCard extends StatelessWidget {
  final Lecture lecture;

  const LectureCard({super.key, required this.lecture});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      child: InkWell(
        onTap: () {
          context.push(AppRoutes.video, extra: {'youtubeLink': lecture.youtubeLink, 'title': lecture.title});
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lecture.title,
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              Text(
                lecture.description,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Icon(Icons.play_circle_outline, size: 4.w, color: colorScheme.primary),
                  SizedBox(width: 2.w),
                  Text(
                    'Watch Lecture',
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600),
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
