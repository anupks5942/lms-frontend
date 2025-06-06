import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms1/core/widgets/custom_loading_dialog.dart';
import 'package:lms1/core/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/widgets/success_dialog.dart';
import '../../../auth/providers/auth_provider.dart';
import '../models/quiz.dart';
import '../providers/quizzes_provider.dart';

class AttemptQuizScreen extends StatefulWidget {
  final Quiz quiz;
  const AttemptQuizScreen({super.key, required this.quiz});

  @override
  State<AttemptQuizScreen> createState() => _AttemptQuizScreenState();
}

class _AttemptQuizScreenState extends State<AttemptQuizScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().initializeAnswers(
        widget.quiz.questions.length,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final quizProvider = context.watch<QuizProvider>();
    final user = context.read<AuthProvider>().getUser();
    final selectedAnswers = quizProvider.selectedAnswers;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.quiz.title, overflow: TextOverflow.ellipsis),
      ),
      bottomNavigationBar:
          user?.role == 'student'
              ? Padding(
                padding: EdgeInsets.all(4.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        selectedAnswers.contains(null)
                            ? null
                            : () async {
                              context.showDialog(message: 'Submitting...');
                              final response = await context
                                  .read<QuizProvider>()
                                  .submitQuiz(widget.quiz.id, selectedAnswers);
                              if (context.mounted) {
                                context.hideDialog();
                                response.match(
                                  (err) {
                                    context.showCustomSnackBar(
                                      message: err,
                                      type: SnackBarType.error,
                                    );
                                  },
                                  (score) {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => SuccessDialog(
                                            message: 'You scored $score marks!',
                                            onOkPressed: () {
                                              context.pop();
                                              context.pop();
                                              context
                                                  .read<QuizProvider>()
                                                  .getAllQuizzes(
                                                    widget.quiz.course.id,
                                                  );
                                            },
                                          ),
                                    );
                                  },
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      textStyle: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Submit Quiz'),
                  ),
                ),
              )
              : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Questions',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.quiz.questions.length,
                itemBuilder: (context, index) {
                  final question = widget.quiz.questions[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. ${question.questionText}',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Column(
                            children:
                                question.options.map((option) {
                                  return RadioListTile<String>(
                                    value: option,
                                    groupValue:
                                        selectedAnswers.isNotEmpty
                                            ? selectedAnswers[index]
                                            : null,
                                    onChanged: (value) {
                                      context.read<QuizProvider>().updateAnswer(
                                        index,
                                        value,
                                      );
                                    },
                                    title: Text(
                                      option,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    activeColor: colorScheme.primary,
                                    contentPadding: EdgeInsets.zero,
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
