import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../auth/providers/auth_provider.dart';
import '../models/quiz.dart';
import 'package:intl/intl.dart';

import '../providers/quizzes_provider.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  const QuizCard({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final questionCount = quiz.questions.length;
    final formattedDate = DateFormat('MMM d, yyyy').format(quiz.createdAt);
    final user = context.read<AuthProvider>().getUser();
    final isAttempted = context.read<QuizProvider>().hasUserAttemptedQuiz(quiz, user?.id ?? '');

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      child: Stack(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap:
                isAttempted
                    ? null
                    : () {
                      context.push(AppRoutes.quiz, extra: quiz);
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
                          child: Icon(Icons.quiz_outlined, size: 6.w, color: colorScheme.onPrimaryContainer),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quiz.title,
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.question_answer_outlined, size: 4.w, color: colorScheme.onSurfaceVariant),
                          SizedBox(width: 2.w),
                          Text(
                            '$questionCount Questions',
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
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
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isAttempted)
            Positioned(
              top: 1.w,
              right: 1.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'Attempted',
                  style: textTheme.labelSmall?.copyWith(color: colorScheme.onPrimary, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
