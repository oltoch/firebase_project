import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyBoardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool label;
  final bool obscureText;
  final bool multiLine;
  final bool enabled;
  final bool readOnly;

  /// A custom TextFormField to accept user input
  const InputWidget(
      {Key? key,
      this.controller,
      this.hintText,
      this.onChanged,
      this.validator,
      this.keyBoardType,
      this.prefix,
      this.suffix,
      this.prefixIcon,
      this.suffixIcon,
      this.label = false,
      this.obscureText = false,
      this.multiLine = false,
      this.enabled = true,
      this.readOnly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54.0,
      child: TextFormField(
        readOnly: readOnly,
        enabled: enabled,
        maxLines: multiLine ? null : 1,
        expands: multiLine ? true : false,
        textAlignVertical: multiLine ? TextAlignVertical.top : null,
        autocorrect: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textCapitalization: TextCapitalization.sentences,
        keyboardType: keyBoardType,
        obscureText: obscureText,
        controller: controller,
        obscuringCharacter: '*',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          height: 19.5 / 16,
        ),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          suffix: suffix,
          prefix: prefix,
          fillColor: const Color(0xFFF3F3F3),
          filled: true,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.0)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 19.0),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 14.0,
            height: 17 / 14.0,
            color: Color(0xFFB6B7B7),
          ),
          labelText: label ? hintText : null,
          labelStyle: const TextStyle(
            fontSize: 14.0,
            height: 17 / 14.0,
            color: Color(0xFFB6B7B7),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.0)),
        ),
        onChanged: (String value) => onChanged?.call(value),
        validator: (String? value) => validator?.call(value),
      ),
    );
  }
}

Widget primaryButton({
  required VoidCallback onPressed,
  Widget? child,
  String? text,
  bool enabled = true,
  EdgeInsetsGeometry? padding,
}) {
  return ElevatedButton(
    onPressed: enabled ? onPressed : null,
    child: Align(
      child: child ??
          Text(
            text ?? ' ',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16, height: 19.2 / 16),
          ),
    ),
    style: ElevatedButton.styleFrom(
      primary: Colors.blue,
      onSurface: Colors.grey.withOpacity(0.8),
      //backgroundColor: kPrimaryColor,
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
