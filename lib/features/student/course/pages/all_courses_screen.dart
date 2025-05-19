import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../widgets/course_card.dart';
import '../providers/course_provider.dart';

class AllCoursesScreen extends StatefulWidget {
  const AllCoursesScreen({super.key});

  @override
  AllCoursesScreenState createState() => AllCoursesScreenState();
}

class AllCoursesScreenState extends State<AllCoursesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final courseProvider = context.watch<CourseProvider>();
    _searchController.text = courseProvider.searchQuery;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: courseProvider.fetchCourses,
        color: colorScheme.primary,
        backgroundColor: colorScheme.surfaceContainer,
        child: Column(
          children: [
            SizedBox(height: 1.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'All Courses',
                    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                  ),
                ),
                if (courseProvider.searchQuery.isNotEmpty || courseProvider.selectedCategory != 'All') ...[
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      courseProvider.clearSearch();
                      courseProvider.setCategory('All');
                    },
                    child: Text(
                      'Reset Filters',
                      style: textTheme.titleSmall?.copyWith(color: colorScheme.error, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 5.h,
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search courses...',
                        prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
                        suffixIcon:
                            courseProvider.searchQuery.isNotEmpty
                                ? IconButton(
                                  icon: Icon(Icons.clear, color: colorScheme.onSurfaceVariant),
                                  onPressed: () {
                                    _searchController.clear();
                                    courseProvider.clearSearch();
                                  },
                                )
                                : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceContainer,
                        hintStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                      ),
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                      onChanged: courseProvider.setSearchQuery,
                      maxLines: 1,
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                PopupMenuButton<String>(
                  initialValue: courseProvider.selectedCategory,
                  onSelected: (value) => courseProvider.setCategory(value),
                  constraints: BoxConstraints(minWidth: 48.w),
                  itemBuilder: (context) {
                    return ['All', ...courseProvider.categories].map((category) {
                      return PopupMenuItem<String>(
                        value: category,
                        child: Row(
                          children: [
                            if (courseProvider.selectedCategory == category) ...[
                              const Icon(Icons.check, size: 18),
                              const SizedBox(width: 6),
                            ],
                            Text(category, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  color: colorScheme.surfaceContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: Container(
                    width: 48.w,
                    height: 5.h,
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.outlineVariant, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            courseProvider.selectedCategory ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                          ),
                        ),
                        Icon(Icons.filter_list, color: colorScheme.onSurfaceVariant, size: 5.w),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Expanded(
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
          ],
        ),
      ),
    );
  }

  Widget _buildCourses(BuildContext context, CourseProvider courseProvider) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    if (courseProvider.isAllLoading) {
      return SizedBox(height: 80.h, child: Center(child: CircularProgressIndicator(color: colorScheme.primary)));
    }

    if (courseProvider.errorMessage.isNotEmpty) {
      return SizedBox(
        height: 80.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 10.w, color: colorScheme.error),
              SizedBox(height: 2.h),
              Text(
                courseProvider.errorMessage,
                style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              ElevatedButton(
                onPressed: () => courseProvider.fetchCourses(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: Text(
                  'Retry',
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onPrimary),
                ),
              ),
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
              Icon(Icons.info_outline, size: 10.w, color: colorScheme.onSurfaceVariant),
              SizedBox(height: 2.h),
              Text(
                'No courses found',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
              ),
              SizedBox(height: 1.h),
              Text(
                'Try a different search or filter',
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w400),
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
        return CourseCard(course: courseProvider.allCourses[index]);
      },
    );
  }
}
