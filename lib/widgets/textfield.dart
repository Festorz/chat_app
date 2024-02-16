import 'package:flutter/material.dart';

class AppTextFormfield extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final Color color;
  bool hide;
  final bool isPassword;
  final bool autofocus;
  bool showPassword;
  final TextInputType type;
  final int lines;
  final Color inputColor;
  final Color fillColor;
  final Color hintColor;
  final Color iconColor;
  final double width;
  final double padding;
  final double radius;
  final void Function(String)? onchange;

  AppTextFormfield({
    Key? key,
    this.hide = false,
    required this.controller,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.autofocus = false,
    this.fillColor = Colors.white,
    this.color = Colors.black,
    this.lines = 1,
    this.padding = 13,
    this.type = TextInputType.text,
    this.showPassword = false,
    this.hintColor = Colors.black54,
    this.iconColor = Colors.black54,
    this.inputColor = Colors.black54,
    this.radius = 20.0,
    this.width = 1.0,
    this.onchange,
  }) : super(key: key);

  @override
  _AppTextFormfieldState createState() => _AppTextFormfieldState();
}

class _AppTextFormfieldState extends State<AppTextFormfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      keyboardType: widget.type,
      autofocus: widget.autofocus,
      style: TextStyle(color: widget.inputColor, fontSize: 12),
      validator: ((value) {
        if (value == null || value.isEmpty) {
          return 'Please fill in here...';
        }
        return null;
      }),
      controller: widget.controller,
      minLines: 1,
      onChanged: widget.onchange ?? widget.onchange,
      textCapitalization: TextCapitalization.sentences,
      maxLines: widget.lines,
      obscureText: widget.hide,
      decoration: InputDecoration(
          contentPadding:
              EdgeInsets.all(widget.icon == null ? widget.padding : 0),
          suffixIconConstraints: const BoxConstraints(maxHeight: 16),
          suffixIcon: widget.isPassword
              ? IconButton(
                  iconSize: 14,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                      widget.showPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      // size: 12,
                      color: widget.iconColor),
                  onPressed: () {
                    setState(() {
                      widget.hide = !widget.hide;
                      widget.showPassword = !widget.showPassword;
                    });
                  })
              : null,
          // suffixIconColor: Colors.amber,
          isDense: true,
          filled: true,
          isCollapsed: true,
          fillColor: widget.fillColor,
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, size: 10, color: widget.iconColor)
              : null,
          hintText: widget.hint,
          hintStyle: TextStyle(color: widget.hintColor),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            borderSide: BorderSide(color: widget.color, width: widget.width),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide(color: widget.color, width: widget.width)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius),
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide(color: Colors.red, width: widget.width)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide(color: Colors.red, width: widget.width))),
    );
  }
}
