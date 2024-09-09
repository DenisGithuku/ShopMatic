import 'package:flutter/material.dart';
import 'package:shopmatic/screens/new_product/components/user_input_field.dart';


class VariantsTable extends StatelessWidget {
  final Map<String, List<TextEditingController>> variants;
  final Map<String, bool> enabledVariants;
  final bool allVariantsEnabled;
  final Function(bool) onToggleAllVariants;
  final Function(String) onToggleVariant;

  const VariantsTable(
      {super.key,
      required this.variants,
      required this.enabledVariants,
      required this.allVariantsEnabled,
      required this.onToggleAllVariants,
      required this.onToggleVariant});

  @override
  Widget build(BuildContext context) {
    return Table(columnWidths: const <int, TableColumnWidth>{
      0: FixedColumnWidth(40.0),
      // Adjust as needed
      1: FlexColumnWidth(),
      2: FixedColumnWidth(80.0),
      3: FixedColumnWidth(80.0),
    }, children: [
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 16.0),
            child: Checkbox(
              value: allVariantsEnabled,
              onChanged: (value) => onToggleAllVariants(value!),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child:
                Text('Variant', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child:
                Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      for (var variant in variants.entries)
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 16.0),
              child: Checkbox(
                value: enabledVariants.keys.contains(variant.key),
                onChanged: (value) => onToggleVariant(variant.key),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0),
              child: Text(variant.key),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: UserInputField(
                controller: variant.value.first,
                hintText: '0.0',
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: UserInputField(
                controller: variant.value.last,
                hintText: '0',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
    ]);
  }
}
