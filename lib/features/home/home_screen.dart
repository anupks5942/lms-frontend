import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lms1/features/auth/providers/auth_provider.dart';
import 'package:lms1/features/student/course/pages/all_courses_screen.dart';
import 'package:lms1/features/student/course/pages/my_courses_screen.dart';
import 'package:lms1/features/home/home_provider.dart';
import 'package:lms1/features/teacher/created_courses_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../auth/models/user.dart';
import '../student/course/providers/course_provider.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<IconData> get _icons => [Icons.auto_stories, Icons.bookmark, Icons.person];
  late CourseProvider courseR;
  late HomeProvider homeR;
  User? user;

  @override
  void initState() {
    homeR = context.read<HomeProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (homeR.selectedIndex != 1) {
        homeR.setIndex(1);
      }
      user = context.read<AuthProvider>().getUser();
      if (user?.role == 'student') {
        context.read<CourseProvider>().getEnrolledCourses(context);
      } else {
        context.read<CourseProvider>().getCreatedCourses(context);
      }
      context.read<CourseProvider>().fetchCourses();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (homeR.selectedIndex != 1) {
          homeR.setIndex(1);
        } else {
          _showLogoutDialog(context);
        }
      },
      child: Scaffold(
        body: Consumer<HomeProvider>(
          builder: (context, homeW, _) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0),
                child: IndexedStack(
                  index: homeW.selectedIndex,
                  children: [
                    const AllCoursesScreen(),
                    user?.role == 'student' ? const MyCoursesScreen() : const CreatedCoursesScreen(),
                    const ProfileScreen(),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Consumer<HomeProvider>(
          builder: (context, homeW, child) {
            return NavigationBar(
              selectedIndex: homeW.selectedIndex,
              onDestinationSelected: (index) {
                homeW.setIndex(index);
                if (homeW.selectedIndex == 0) {
                  context.read<CourseProvider>().fetchCourses();
                } else if (homeW.selectedIndex == 1) {
                  context.read<CourseProvider>().getEnrolledCourses(context);
                }
              },
              animationDuration: const Duration(milliseconds: 1000),
              destinations: [
                NavigationDestination(icon: Icon(_icons[0]), label: 'Explore'),
                NavigationDestination(icon: Icon(_icons[1]), label: 'My Courses'),
                NavigationDestination(icon: Icon(_icons[2]), label: 'Profile'),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Exit'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: [
            TextButton(onPressed: dialogContext.pop, child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                dialogContext.pop();
                SystemNavigator.pop();
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }
}
