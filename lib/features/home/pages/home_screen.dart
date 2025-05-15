import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../core/constants/app_routes.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/course_card.dart';
import '../providers/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeProvider homeProvider;

  @override
  void initState() {
    homeProvider = context.read<HomeProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeProvider.getAllCourses();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              context.read<AuthProvider>().logout();
              context.go(AppRoutes.login);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: RefreshIndicator(
          onRefresh: homeProvider.getAllCourses,
          child: Consumer<HomeProvider>(
            builder: (context, homeProvider, child) {
              if (homeProvider.isLoading) return const Center(child: CircularProgressIndicator());
              if(homeProvider.courses.isEmpty) return const Center(child: Text('No courses found'));

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: homeProvider.courses.length,
                itemBuilder: (context, index) {
                  return CourseCard(course: homeProvider.courses[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
