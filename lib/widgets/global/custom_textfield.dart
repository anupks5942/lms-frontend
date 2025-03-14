import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText = '',
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.validator,
    this.onFieldSubmitted,
  });
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;
  final String? Function(String?)? validator;
  final Function(String)? onFieldSubmitted;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = !widget.isPassword;
  }

  @override
  Widget build(BuildContext context) => TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() => _isPasswordVisible = !_isPasswordVisible);
          },
        )
            : (widget.suffixIcon != null ? Icon(widget.suffixIcon) : null),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.w)),
        // contentPadding: EdgeInsets.symmetric(vertical: 1.5.h),
      ),
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
    );
}
