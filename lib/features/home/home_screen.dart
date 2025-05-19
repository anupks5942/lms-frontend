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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<IconData> get _icons => [Icons.auto_stories, Icons.bookmark, Icons.person];
  late CourseProvider courseR;
  late HomeProvider homeR;
  late TabController _tabController;
  User? user;

  @override
  void initState() {
    super.initState();
    homeR = context.read<HomeProvider>();
    user = context.read<AuthProvider>().getUser();

    _tabController = TabController(length: 3, vsync: this, initialIndex: homeR.selectedIndex);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && homeR.selectedIndex != _tabController.index) {
        homeR.setIndex(_tabController.index);
        _handleTabChange(_tabController.index);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (homeR.selectedIndex != 1) homeR.setIndex(1);
      _handleTabChange(_tabController.index);
    });
  }

  void _handleTabChange(int index) {
    if (index == 0) {
      context.read<CourseProvider>().clearSearch();
      context.read<CourseProvider>().fetchCourses();
    } else if (index == 1) {
      if (user?.role == 'student') {
        context.read<CourseProvider>().getEnrolledCourses(context);
      } else {
        context.read<CourseProvider>().getCreatedCourses(context);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_tabController.index != 1) {
          _tabController.animateTo(1);
        } else {
          _showLogoutDialog(context);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [
                const AllCoursesScreen(),
                user?.role == 'student' ? const MyCoursesScreen() : const CreatedCoursesScreen(),
                const ProfileScreen(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Consumer<HomeProvider>(
          builder: (context, homeW, child) {
            return NavigationBar(
              selectedIndex: homeW.selectedIndex,
              onDestinationSelected: (index) {
                homeR.setIndex(index);
                _handleTabChange(index);
                _tabController.animateTo(index);
              },
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
