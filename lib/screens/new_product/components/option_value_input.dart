import 'package:flutter/material.dart';
import 'package:product_variant_gen/screens/new_product/components/user_input_field.dart';

class OptionValueInputRow extends StatelessWidget {
  final TextEditingController controller;
  final Function() onRemoveField;

  const OptionValueInputRow(
      {super.key, required this.controller, required this.onRemoveField});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
              child: UserInputField(
            controller: controller,
            hintText: 'Value',
          )),
          IconButton(onPressed: onRemoveField, icon: Icon(Icons.delete_outline))
        ],
      ),
    );
  }
}