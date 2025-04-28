import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_card.dart';
import 'home_provider.dart';

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
        title: Text('Courses'),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () async {
        //       Navigator.pushNamed(context, AppRoutes.login);
        //     },
        //     icon: Icon(Icons.logout),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, homeProvider, child) {
            if (homeProvider.isLoading) return const Center(child: CircularProgressIndicator());

            return ListView.builder(
              itemCount: homeProvider.courses.length,
              itemBuilder: (context, index) {
                return CourseCard(course: homeProvider.courses[index]);
              },
            );
          },
        ),
      ),
    );
  }
}