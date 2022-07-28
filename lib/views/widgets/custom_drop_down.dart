import 'package:algoriza_internship_todo/resources/color_manager.dart';
import 'package:algoriza_internship_todo/resources/values_manager.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomDropDown extends StatelessWidget {
  String? dropDownValue;
  late List<String> values;
  late String hintText;
  late Color borderColor;
  Function(String?)? onChanged;

  CustomDropDown({
    Key? key,
    required this.dropDownValue,
    required this.values,
    required this.hintText,
    this.borderColor = ColorManager.grey1,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
      decoration: BoxDecoration(
        color: ColorManager.grey3,
        borderRadius: BorderRadius.circular(AppSize.s10),
        border: Border.all(color: borderColor)
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: dropDownValue??hintText,
          onTap: () => FocusScope.of(context).unfocus(),
          onChanged: onChanged,
          dropdownColor: ColorManager.white,
          borderRadius: BorderRadius.circular(AppSize.s10),
          iconEnabledColor: ColorManager.grey4,
          elevation: 1,
          items: [
            DropdownMenuItem(
              enabled: false,
              value: hintText,
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.p8),
                child: Text(hintText, style: Theme.of(context).textTheme.titleSmall!.copyWith(color: ColorManager.grey)),
              ),
            ),
            for(int i=0; i<values.length; i++) DropdownMenuItem(
              value: values[i],
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.p8),
                child: Text(values[i], style: const TextStyle(color: ColorManager.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}