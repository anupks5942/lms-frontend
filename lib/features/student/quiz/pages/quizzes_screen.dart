import 'package:flutter/material.dart';
import 'package:lms1/features/student/quiz/providers/quizzes_provider.dart';
import 'package:lms1/features/student/quiz/widgets/quiz_card.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class QuizzesScreen extends StatefulWidget {
  final String courseId;
  const QuizzesScreen({super.key, required this.courseId});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().getAllQuizzes(widget.courseId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Quizzes'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<QuizProvider>().getAllQuizzes(widget.courseId),
        child: Consumer<QuizProvider>(
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

  Widget _buildCourses(BuildContext context, QuizProvider courseProvider) {
    if (courseProvider.isLoading) {
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
              ElevatedButton(
                onPressed: () => courseProvider.getAllQuizzes(widget.courseId),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (courseProvider.quizzes.isEmpty) {
      return SizedBox(
        height: 80.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 10.w, color: Colors.grey),
              SizedBox(height: 2.h),
              Text('No quizzes found', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 1.h),
              Text(
                'Quizzes will appear once the teacher creates',
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
      itemCount: courseProvider.quizzes.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 0.5.h),
          child: QuizCard(quiz: courseProvider.quizzes[index]),
        );
      },
    );
  }
}
