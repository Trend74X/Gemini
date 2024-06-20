import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String? initialValue;
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final OutlineInputBorder? errorBorder;
  final InputBorder? disabledBorder;
  final Color? cursorColor;
  final Color? filledColor;
  final bool? filled;
  final int? maxLines;
  final double? width;
  final double? height;
  final double? cursorHeight;
  final VoidCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final AutovalidateMode? autoValidateMode;
  final bool? isDisabled;
  final bool? autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? padding;
  final bool? onFocusChangeColor;
  final bool? isDropdown;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.initialValue,
    this.controller,
    this.labelText,
    this.hintText,
    this.labelStyle,
    this.hintStyle,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.disabledBorder,
    this.cursorColor,
    this.maxLines,
    this.width,
    this.height, 
    this.filledColor, 
    this.filled, 
    this.autofocus = false, 
    this.readOnly = false, 
    this.onTap, 
    this.autoValidateMode, 
    this.isDisabled, this.inputFormatters, this.onFieldSubmitted, this.textAlign, this.padding, this.onFocusChangeColor, this.cursorHeight, this.isDropdown, this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  FocusNode focusNode = FocusNode();

  bool isFocused = false;

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Focus(
        focusNode: focusNode,
        onFocusChange: (hasFocus) {
          setState(() {
            isFocused = hasFocus;
          });
        },
        child: TextFormField(
          focusNode: widget.focusNode,
          inputFormatters: widget.inputFormatters ?? [],
          onTap: widget.onTap,
          style: widget.onFocusChangeColor != null && focusNode.hasFocus ? const TextStyle(color: Colors.blue, fontSize: 14) : widget.textStyle,
          autofocus: widget.autofocus!,
          autovalidateMode: widget.autoValidateMode ?? AutovalidateMode.onUserInteraction,
          initialValue: widget.initialValue,
          controller: widget.controller,
          obscureText: widget.obscureText,
          readOnly: widget.readOnly,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          textAlign: widget.textAlign ?? TextAlign.start,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          cursorColor: widget.onFocusChangeColor != null && focusNode.hasFocus ? Colors.blue : widget.cursorColor,
          cursorHeight: widget.cursorHeight,
          cursorWidth: 1.5,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            suffixIcon: widget.isDropdown == true 
              ? const Icon(Icons.arrow_drop_down, color: Colors.grey,)
              : widget.suffixIcon,
            labelText: widget.labelText,
            hintText: widget.hintText,
            labelStyle: widget.labelStyle,
            hintStyle: widget.hintStyle ?? const TextStyle(
              fontSize: 12, 
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: widget.prefixIcon,
            border: widget.border ??  OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Color(0xFFE3E3E3),
                width: 1.2
              ),
            ),
            enabledBorder: widget.enabledBorder ?? OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Color(0xFFE3E3E3) ,
                width: 1.2
              ),
            ),
            focusedBorder: widget.focusedBorder ?? OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Color(0xFF707070),
                width: 1.6
              ),
            ),
            fillColor: widget.filledColor ?? const Color(0xFFEDEFF1),
            filled: true,
            errorBorder: widget.errorBorder ?? const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red, 
                width: 1.2
              ),
            ),
            focusedErrorBorder: widget.errorBorder ?? const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red, 
                width: 1.2
              ),
            ),
            disabledBorder: widget.disabledBorder,
            contentPadding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ),
    );
  }
}