import 'package:canteen_frontend_seller/src/core/const/const.dart';
import 'package:flutter/material.dart';

class CustomTextForm extends StatefulWidget {
  CustomTextForm(
      {super.key,
      required this.textController,
      required this.validator,
      required this.hintText});
  TextEditingController textController = TextEditingController();
  FormFieldValidator<String>? validator;
  String hintText;
  @override
  State<CustomTextForm> createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${widget.hintText}:",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: widget.textController,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusSet),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 20,
            ),
          ),
        ),
      ],
    );
  }
}
