import 'package:flutter/material.dart';
import 'package:shopmatic/screens/new_product/components/add_option_button.dart';

class OptionChipRow extends StatelessWidget {
  final List<String> values;
  const OptionChipRow({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: values.map(
            (value) {
              return Chip(
                label: Text(value),
              );
            },
          ).toList()),
    );
  }
}

class OptionChipsSection extends StatelessWidget {
  final Map<String, List<String>> optionsMap;
  final Function() onAddOption;

  const OptionChipsSection(
      {super.key, required this.optionsMap, required this.onAddOption});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: optionsMap.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                ),
                OptionChipRow(values: entry.value)
              ],
            );
          }).toList(),
        ),
        AddOptionButton(onAddOption: onAddOption)
      ],
    );
  }
}
