import 'package:algoriza_internship_todo/resources/color_manager.dart';
import 'package:algoriza_internship_todo/resources/string_manager.dart';
import 'package:algoriza_internship_todo/resources/values_manager.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final int maxLines;
  String? hintText;
  String? Function(String?)? validator;
  final bool isValidatorRequired;
  final bool isSuffixClear;

  CustomTextFormField({
    Key? key,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.maxLines = 1,
    this.hintText,
    this.validator,
    this.isValidatorRequired = false,
    this.isSuffixClear = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: textInputType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          cursorColor: ColorManager.black,
          validator: isValidatorRequired ? (val) {
            if(val!.trim().isEmpty) {return StringManager.required;}
            return null;
          } : validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorManager.grey3,
            isDense: true,
            contentPadding: const EdgeInsetsDirectional.only(top: AppPadding.p14, bottom: AppPadding.p14, start: AppPadding.p12, end: AppPadding.p40),
            hintText: hintText,
            hintStyle: const TextStyle(color: ColorManager.grey),
            errorStyle: TextStyle(color: ColorManager.red700, fontWeight: FontWeight.bold),
            border: OutlineInputBorder(borderSide: const BorderSide(color: ColorManager.grey1), borderRadius: BorderRadius.circular(AppSize.s10)),
            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: ColorManager.grey1), borderRadius: BorderRadius.circular(AppSize.s10)),
            enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: ColorManager.grey1), borderRadius: BorderRadius.circular(AppSize.s10)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: ColorManager.red700), borderRadius: BorderRadius.circular(AppSize.s10)),
            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: ColorManager.red700), borderRadius: BorderRadius.circular(AppSize.s10)),
          ),
        ),
        if(isSuffixClear) PositionedDirectional(
          top: AppSize.s7,
          end: AppSize.s10,
          child: IconButton(
            onPressed: () => controller.clear(),
            padding: const EdgeInsets.all(AppPadding.p0),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            icon: const Icon(Icons.clear, color: ColorManager.grey4),
          )
        ),
      ],
    );
  }
}