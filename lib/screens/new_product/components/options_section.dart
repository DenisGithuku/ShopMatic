import 'package:flutter/material.dart';
import 'package:shopmatic/screens/new_product/components/add_option_button.dart';
import 'package:shopmatic/screens/new_product/components/option_value_input.dart';
import 'package:shopmatic/screens/new_product/components/user_input_field.dart';

class OptionsSection extends StatelessWidget {
  final Map<TextEditingController, List<TextEditingController>>
      optionControllersMap;
  final Function(TextEditingController) onRemoveField;
  final Function() onStoreOption;
  final Function() onAddOption;
  final Function() onAddOptionValue;

  const OptionsSection(
      {super.key,
      required this.optionControllersMap,
      required this.onRemoveField,
      required this.onStoreOption,
      required this.onAddOption,
      required this.onAddOptionValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Option name'),
                Column(
                  children: [
                    UserInputField(
                      controller: optionControllersMap.entries.last.key,
                      hintText: 'Color',
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Option values'),
                Column(
                  children:
                      optionControllersMap.entries.last.value.map((controller) {
                    return OptionValueInputRow(
                        controller: controller,
                        onRemoveField: onRemoveField(controller));
                  }).toList(),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onAddOptionValue,
                    child: Text('Add value'),
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onStoreOption,
                    child: Text('Done'),
                  ),
                ),
              ],
            ),
          ],
        ),
        AddOptionButton(onAddOption: onAddOption)
      ],
    );
  }
}
