import 'package:flutter/material.dart';

class OptionsHeader extends StatelessWidget {
  final bool optionsEnabled;
  final Function(bool?) onToggleOptions;

  const OptionsHeader(
      {super.key, required this.optionsEnabled, required this.onToggleOptions});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Checkbox(value: optionsEnabled, onChanged: onToggleOptions),
        const Text(
          style: TextStyle(
            fontSize: 12.0,
          ),
          'This product has options like size or color',
        )
      ],
    );
  }
}
