import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms1/core/widgets/custom_loading_dialog.dart';
import 'package:lms1/core/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../core/services/validation_service.dart';
import '../providers/lecture_provider.dart';

class CreateLectureDialog extends StatefulWidget {
  final String courseId;

  const CreateLectureDialog({super.key, required this.courseId});

  @override
  CreateLectureDialogState createState() => CreateLectureDialogState();
}

class CreateLectureDialogState extends State<CreateLectureDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _youtubeLinkController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _youtubeLinkController.dispose();
    super.dispose();
  }

  Future<void> _createLecture() async {
    if (!_formKey.currentState!.validate()) return;

    final lectureData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'youtubeLink': _youtubeLinkController.text,
    };

    context.showDialog(message: 'Creating lecture...');

    final response = await context.read<LectureProvider>().createLecture(
      widget.courseId,
      lectureData,
    );

    if (mounted) context.hideDialog();

    response.match(
      (err) {
        context.showCustomSnackBar(message: err, type: SnackBarType.error);
      },
      (_) {
        context.showCustomSnackBar(
          message: 'Lecture created successfully',
          type: SnackBarType.success,
        );
        context.pop();
        context.read<LectureProvider>().getLectures(widget.courseId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Lecture',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Lecture Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerLowest,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  validator: ValidationService.requiredValidation,
                ),
                SizedBox(height: 2.h),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerLowest,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  validator: ValidationService.requiredValidation,
                  maxLines: 3,
                ),
                SizedBox(height: 2.h),
                TextFormField(
                  controller: _youtubeLinkController,
                  decoration: InputDecoration(
                    hintText: 'YouTube Link',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerLowest,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'YouTube link is required';
                    }
                    final videoId = YoutubePlayer.convertUrlToId(value);
                    return videoId == null ? 'Invalid YouTube URL' : null;
                  },
                  keyboardType: TextInputType.url,
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.onSurfaceVariant,
                        textStyle: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    SizedBox(width: 2.w),
                    ElevatedButton(
                      onPressed: _createLecture,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.5.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Create',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
