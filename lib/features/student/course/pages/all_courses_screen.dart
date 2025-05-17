import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../widgets/course_card.dart';
import '../providers/course_provider.dart';

class AllCoursesScreen extends StatelessWidget {
  const AllCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<CourseProvider>().getAllCourses();
        },
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
    if (courseProvider.isAllLoading) {
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
              ElevatedButton(onPressed: courseProvider.getAllCourses, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (courseProvider.allCourses.isEmpty) {
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
                'Pull to refresh or check back later',
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
      itemCount: courseProvider.allCourses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 0.5.h),
          child: CourseCard(course: courseProvider.allCourses[index]),
        );
      },
    );
  }
}
