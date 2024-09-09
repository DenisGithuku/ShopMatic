import 'package:flutter/material.dart';

class AddOptionButton extends StatelessWidget {
  final Function() onAddOption;

  const AddOptionButton({super.key, required this.onAddOption});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onAddOption,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.add),
          const Text('Add another option')
        ],
      ),
    );
  }
}
