import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms1/core/widgets/custom_loading_dialog.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/services/validation_service.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../providers/quizzes_provider.dart';

class CreateQuizScreen extends StatefulWidget {
  final String courseId;

  const CreateQuizScreen({super.key, required this.courseId});

  @override
  CreateQuizScreenState createState() => CreateQuizScreenState();
}

class CreateQuizScreenState extends State<CreateQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().initializeQuizCreation();
    });
    _titleController.addListener(() {
      context.read<QuizProvider>().updateQuizTitle(_titleController.text);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().resetQuizCreation();
    });
    super.dispose();
  }

  Future<void> _submitQuiz() async {
    if (!_formKey.currentState!.validate()) return;

    final quizProvider = context.read<QuizProvider>();
    if (!quizProvider.validateQuiz()) {
      context.showCustomSnackBar(
        message: 'Please ensure all questions have at least two options and a correct answer',
        type: SnackBarType.error,
      );
      return;
    }

    context.showDialog(message: 'Creating quiz...');

    final quizData = quizProvider.getQuizData();
    final response = await quizProvider.createQuiz(widget.courseId, quizData);

    if (mounted) context.hideDialog();

    response.match(
      (err) {
        context.showCustomSnackBar(message: err, type: SnackBarType.error);
      },
      (_) {
        context.showCustomSnackBar(message: 'Quiz created successfully', type: SnackBarType.success);
        quizProvider.getAllQuizzes(widget.courseId);
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surfaceContainer,
        title: Text(
          'Create Quiz',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
        ),
        leading: IconButton(icon: Icon(Icons.arrow_back, color: colorScheme.onSurface), onPressed: () => context.pop()),
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Quiz Title',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
                    ),
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                    validator: ValidationService.requiredValidation,
                  ),
                  SizedBox(height: 2.h),
                  ...quizProvider.quizQuestions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final question = entry.value;
                    return _buildQuestionForm(index, question, quizProvider, theme, textTheme, colorScheme);
                  }),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => quizProvider.addQuestion(),
                        icon: Icon(Icons.add, size: 4.w),
                        label: Text('Add Question', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      if (quizProvider.quizQuestions.length > 1)
                        TextButton(
                          onPressed: () => quizProvider.removeQuestion(quizProvider.quizQuestions.length - 1),
                          style: TextButton.styleFrom(
                            foregroundColor: colorScheme.error,
                            textStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          child: const Text('Remove Last Question'),
                        ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: _submitQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: Size(double.infinity, 6.h),
                    ),
                    child: Text(
                      'Create Quiz',
                      style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onPrimary),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionForm(
    int index,
    QuestionFormData question,
    QuizProvider quizProvider,
    ThemeData theme,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Card(
      elevation: 2,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${index + 1}',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
            ),
            SizedBox(height: 1.h),
            TextFormField(
              controller: question.questionController,
              decoration: InputDecoration(
                hintText: 'Enter question',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                filled: true,
                fillColor: colorScheme.surfaceContainerLowest,
                contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
              ),
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
              validator: ValidationService.requiredValidation,
              onChanged: (value) => quizProvider.updateQuestionText(index, value),
            ),
            SizedBox(height: 2.h),
            Text(
              'Options',
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
            ),
            ...question.optionControllers.asMap().entries.map((entry) {
              final optIndex = entry.key;
              final controller = entry.value;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Option ${optIndex + 1}',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerLowest,
                          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                          hintStyle: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                        ),
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                        validator: ValidationService.requiredValidation,
                        onChanged: (value) => quizProvider.updateOption(index, optIndex, value),
                      ),
                    ),
                    if (question.optionControllers.length > 2)
                      IconButton(
                        icon: Icon(Icons.delete, color: colorScheme.error, size: 5.w),
                        onPressed: () => quizProvider.removeOption(index, optIndex),
                      ),
                  ],
                ),
              );
            }),
            SizedBox(height: 1.h),
            TextButton.icon(
              onPressed: () => quizProvider.addOption(index),
              icon: Icon(Icons.add, color: colorScheme.primary, size: 4.w),
              label: Text(
                'Add Option',
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Correct Answer',
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
            ),
            PopupMenuButton<String>(
              initialValue: question.correctAnswer,
              onSelected: (value) => quizProvider.updateCorrectAnswer(index, value),
              itemBuilder: (context) {
                return question.optionControllers.asMap().entries.where((e) => e.value.text.trim().isNotEmpty).map((e) {
                  final optionText = e.value.text.trim();
                  return PopupMenuItem<String>(
                    value: optionText,
                    child: Row(
                      children: [
                        if (question.correctAnswer == optionText) ...[
                          const Icon(Icons.check, size: 18),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            optionText,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
              color: colorScheme.surfaceContainerLowest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colorScheme.outlineVariant),
              ),
              constraints: const BoxConstraints(minWidth: double.infinity), // Optional
              child: Container(
                height: 50, // Match other inputs
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.outlineVariant, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        question.correctAnswer?.isNotEmpty == true ? question.correctAnswer! : 'Select correct answer',
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color:
                              question.correctAnswer?.isNotEmpty == true
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant, size: 5.w),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
