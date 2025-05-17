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
          builder: (context, homeProvider, child) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 80.h),
                child: _buildCourses(context, homeProvider),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCourses(BuildContext context, CourseProvider homeProvider) {
    if (homeProvider.isAllLoading) {
      return SizedBox(height: 80.h, child: const Center(child: CircularProgressIndicator()));
    }

    if (homeProvider.errorMessage.isNotEmpty) {
      return SizedBox(
        height: 80.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                homeProvider.errorMessage,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              ElevatedButton(onPressed: homeProvider.getAllCourses, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (homeProvider.allCourses.isEmpty) {
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
      itemCount: homeProvider.allCourses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 0.5.h),
          child: CourseCard(course: homeProvider.allCourses[index]),
        );
      },
    );
  }
}
