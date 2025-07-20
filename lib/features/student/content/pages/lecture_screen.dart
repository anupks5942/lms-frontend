import 'package:flutter/material.dart';
import 'package:lms1/features/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../widgets/create_lecture_dialog.dart';
import '../widgets/lecture_card.dart';
import '../providers/lecture_provider.dart';

class LectureScreen extends StatefulWidget {
  final String courseId;

  const LectureScreen({super.key, required this.courseId});

  @override
  LectureScreenState createState() => LectureScreenState();
}

class LectureScreenState extends State<LectureScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LectureProvider>().getLectures(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final user = context.read<AuthProvider>().getUser();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surfaceContainer,
        title: const Text('Lectures'),
      ),
      floatingActionButton:
          user?.role == 'teacher'
              ? FloatingActionButton(
                tooltip: 'Upload lecture',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) =>
                            CreateLectureDialog(courseId: widget.courseId),
                  );
                },
                child: const Icon(Icons.add),
              )
              : null,
      body: Consumer<LectureProvider>(
        builder: (context, lectureProvider, child) {
          return RefreshIndicator(
            onRefresh: () => lectureProvider.getLectures(widget.courseId),
            color: colorScheme.primary,
            backgroundColor: colorScheme.surfaceContainer,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (lectureProvider.isLoading &&
                        lectureProvider.lectures.isEmpty)
                      LinearProgressIndicator(
                        backgroundColor: colorScheme.primary.withValues(
                          alpha: 0.2,
                        ),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    if (lectureProvider.errorMessage.isNotEmpty)
                      SizedBox(
                        height: 80.h,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 10.w,
                                color: colorScheme.error,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                lectureProvider.errorMessage,
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 2.h),
                              ElevatedButton(
                                onPressed:
                                    () => lectureProvider.getLectures(
                                      widget.courseId,
                                    ),
                                child: Text(
                                  'Retry',
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (lectureProvider.lectures.isEmpty &&
                        !lectureProvider.isLoading &&
                        lectureProvider.errorMessage.isEmpty)
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
                                'No lectures found',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (lectureProvider.lectures.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: lectureProvider.lectures.length,
                        itemBuilder: (context, index) {
                          return LectureCard(
                            index: index,
                            lecture: lectureProvider.lectures[index],
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
