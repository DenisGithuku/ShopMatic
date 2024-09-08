import 'dart:core';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:product_variant_gen/data/model.dart';
import 'package:product_variant_gen/data/product_db.dart';
import 'package:product_variant_gen/repository/product_repository.dart';
import 'package:product_variant_gen/screens/new_product/components/add_option_button.dart';
import 'package:product_variant_gen/screens/new_product/components/image_widget.dart';
import 'package:product_variant_gen/screens/new_product/components/options_header.dart';

import 'components/user_input_field.dart';

class NewProductScreen extends StatefulWidget {
  @override
  _NewProductScreenState createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  //Get access to repository
  late ProductRepository _productRepository;

  // Controllers for text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  bool? _optionsEnabled = false;
  bool? _allVariantsEnabled = false;
  Map<String, bool> _enabledVariantsMap = {};

  // option controllers
  Map<TextEditingController, List<TextEditingController>>
      _optionsControllersMap = {
    TextEditingController(): [TextEditingController()]
  };

  Map<String, List<String>> _optionsMap = {};
  Map<String, List<TextEditingController>> _variantsMap = {};

  XFile? _imageFile;
  final picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _optionsControllersMap.forEach((key, value) {
      key.dispose();
      for (var element in value) {
        element.dispose();
      }
    });
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _productRepository = ProductRepository(ProductDbManager());
  }

  void _onAddOptionField() {
    setState(() {
      final optionController = TextEditingController();
      _optionsControllersMap[optionController] = [TextEditingController()];
    });
  }

  void _removeOption(TextEditingController optionController) {
    setState(() {
      _optionsControllersMap.remove(optionController);
    });
  }

  void _onStoreOption(Map<String, List<String>> option) {
    setState(() {
      var trimmedOptions = option.map(
          (key, value) => MapEntry(key, value.map((e) => e.trim()).toList()));
      _optionsMap.addAll(trimmedOptions);
      _generateVariantCombinations();
    });
    _optionsControllersMap.clear();
    _optionsControllersMap.forEach((key, value) {
      key.dispose();
      for (var value in value) {
        value.dispose();
      }
    });
  }

  void _onToggleAllVariants(bool value) {
    setState(() {
      _allVariantsEnabled = value;
      if (value) {
        var enabledEntries =
            _variantsMap.keys.map((key) => MapEntry(key, true));
        _enabledVariantsMap.addEntries(enabledEntries);
      } else {
        _enabledVariantsMap.clear();
      }
    });
  }

  void _onToggleVariant(String variant) {
    setState(() {
      // check if variant exists
      if (!_enabledVariantsMap.containsKey(variant)) {
        _enabledVariantsMap[variant] = true;
      } else {
        // Toggle enabled state
        _enabledVariantsMap.remove(variant);
        if (_enabledVariantsMap.entries.isEmpty) _allVariantsEnabled = false;
      }
    });
  }

  Map<String, List<String>> convertOptionsMap(
      Map<TextEditingController, List<TextEditingController>> originalMap) {
    return originalMap.map((keyController, valueControllers) {
      // Convert key to String
      String key = keyController.text;

      // Convert list of value Controllers to list of Strings
      List<String> value = valueControllers.map((e) => e.text).toList();

      return MapEntry(key, value);
    });
  }

  void _onAddOptionValueField(TextEditingController optionController) {
    setState(() {
      final valueController = TextEditingController();
      _optionsControllersMap[optionController]!.add(valueController);
    });
  }

  void _removeOptionValue(TextEditingController optionController,
      TextEditingController valueController) {
    setState(() {
      _optionsControllersMap[optionController]?.remove(valueController);
      valueController.dispose();

      // Check if the optionController has no more values
      if (_optionsControllersMap[optionController]?.isEmpty ?? true) {
        _optionsControllersMap.remove(optionController);
        optionController.dispose();
      }

      // Check if there are no more controllers
      if (_optionsControllersMap.isEmpty && _optionsMap.isEmpty) {
        _optionsEnabled = false;
      }

      _generateVariantCombinations();
    });
  }

  void _generateVariantCombinations() {
    _variantsMap.clear(); // Clear existing variants

    final variantSet = <String>{}; // To track unique combinations
    bool hasDetailedCombinations =
        false; // Flag to check if detailed combinations are present

    // Extract the option keys and their corresponding values
    final options = _optionsMap.entries.toList();

    // Iterate through all combinations of values
    for (int i = 0; i < options.length; i++) {
      final values1 = options[i].value;

      for (int j = i + 1; j < options.length; j++) {
        final values2 = options[j].value;

        for (final value1 in values1) {
          for (final value2 in values2) {
            // Create combination keys for detailed combinations
            final combination1 = '${value1}/${value2}';
            final combination2 = '${value2}/${value1}';

            // Add the combination to the set if it's not already present
            if (!variantSet.contains(combination1) &&
                !variantSet.contains(combination2)) {
              variantSet.add(combination1);
              _variantsMap[combination1] = [
                TextEditingController(),
                TextEditingController()
              ];
              hasDetailedCombinations =
                  true; // Set the flag if a detailed combination is added
            }
          }
        }
      }
    }

    // If no detailed combinations are present, generate simple combinations (single options)
    if (!hasDetailedCombinations) {
      for (var option in options) {
        for (var value in option.value) {
          final simpleCombination = value;

          if (!variantSet.contains(simpleCombination)) {
            variantSet.add(simpleCombination);
            _variantsMap[simpleCombination] = [TextEditingController()];
          }
        }
      }
    }
  }

  void onToggleVariants(bool value) {
    setState(() {
      _allVariantsEnabled = value;
    });
  }

  Future<void> _onSave() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
              child: Text('Saving product')
          );
        }
    );
    try {
      var product = Product(
          id: UniqueKey().toString(),
          name: _titleController.text,
          description: _descriptionController.text,
          price: double.tryParse(_priceController.text) ?? 0.0,
          category: _categoryController.text,
          options: _mapOptions(),
          variants: _mapVariants(),
          image: _imageFile?.path);

      _productRepository.insertProduct(product);
      _onShowSnackBar(context, 'Product saved successfully!');
    } catch(e) {
      _onShowSnackBar(context, 'Failed to save product!');
      debugPrint(e.toString());
    } finally {
      Navigator.pop(context);
    }
  }

  List<Option> _mapOptions() {
    return _optionsMap.entries.map((optionMap) {
      return Option(name: optionMap.key, values: optionMap.value);
    }).toList();
  }

  List<Variant> _mapVariants() {
    List<Variant> variantList = [];

    _variantsMap.forEach((variantName, controllers) {
      // Ensure the variant is enabled before mapping
      if (_enabledVariantsMap.containsKey(variantName)) {
        // Retrieve data from controllers
        final priceController = controllers[0];
        final stockController = controllers[1];

        // Parse price and stock, with fallback values
        final price = double.tryParse(priceController.text.trim()) ?? 0.0;
        final stock = int.tryParse(stockController.text.trim()) ?? 0;

        // Create a Variant instance
        variantList.add(
          Variant(
            id: UniqueKey().toString(), // Generate a unique ID
            name: variantName, price: price, stock: stock,
          ),
        );
      }
    });

    return variantList;
  }

  void _onToggleOptions(bool value) {
    setState(() {
      _optionsEnabled = value;
      if (_optionsMap.entries.isEmpty &&
          _optionsControllersMap.entries.isEmpty) {
        final optionController = TextEditingController(text: 'Color');
        _optionsControllersMap[optionController] = [
          TextEditingController(text: 'Black')
        ];
      }
    });
  }

  Future<void> _onPickImage() async {
    // request permissions
    var permissionStatus = await Permission.storage.request();

    if (permissionStatus.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } else if (permissionStatus.isDenied) {
      // Permission denied, show message to user
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Storage permission is required to select images')));
    } else if (permissionStatus.isPermanentlyDenied) {
      // Permission was permanently denied, open app settings.
      openAppSettings();
    }
  }

  void _onShowSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  bool _validateUserData() {
    var variantsAreValid = _enabledVariantsMap.entries.isNotEmpty &&
        _enabledVariantsMap.entries.every((enabledVariant) {
          var variant = _variantsMap[enabledVariant.key];
          return variant != null &&
              variant.every((field) => field.text.trim().isNotEmpty);
        });

    return _titleController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty &&
        _priceController.text.trim().isNotEmpty &&
        _categoryController.text.trim().isNotEmpty &&
        _imageFile != null &&
        variantsAreValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new product'),
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (_validateUserData() == false) {
                  _onShowSnackBar(
                      context, 'Invalid data please check your details');
                } else {
                  _onSave();
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageWidget(
                      imagePath: _imageFile?.path, onPickImage: _onPickImage),
                  SizedBox(
                    height: 10.0,
                  ),
                  UserInputField(
                    controller: _titleController,
                    hintText: 'Title',
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  UserInputField(
                    controller: _descriptionController,
                    hintText: 'Description',
                    minLines: 2,
                    maxLines: 6,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: UserInputField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          hintText: 'Price',
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: UserInputField(
                          controller: _categoryController,
                          hintText: 'Category',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  OptionsHeader(
                      optionsEnabled: _optionsEnabled!,
                      onToggleOptions: (value) => _onToggleOptions(value!)),
                  if (_optionsEnabled == true)
                    if (_optionsControllersMap.isNotEmpty &&
                        _optionsMap.isNotEmpty)
                      // column with both chips and input and saved options
                      Column(
                        children: [
                          Column(
                            children: [
                              Column(
                                children: _optionsMap.entries.map((entry) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.key,
                                      ),
                                      OptionChipRow(
                                        values: entry.value,
                                      )
                                    ],
                                  );
                                }).toList(),
                              ),
                              Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Option name'),
                                      Column(
                                        children: [
                                          UserInputField(
                                              controller: _optionsControllersMap
                                                  .entries.last.key,
                                              hintText: 'Size')
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Option values'),
                                      Column(
                                        children: _optionsControllersMap
                                            .entries.last.value
                                            .map((controller) {
                                          return OptionValueInputRow(
                                              controller: controller,
                                              onRemoveField: () {
                                                _removeOptionValue(
                                                  _optionsControllersMap
                                                      .entries.last.key,
                                                  _optionsControllersMap
                                                      .entries.last.value
                                                      .firstWhere((element) =>
                                                          element.text ==
                                                          controller.text),
                                                );
                                              });
                                        }).toList(),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            if (_optionsControllersMap.entries
                                                .any((element) => element.value
                                                    .any((element) => element
                                                        .text
                                                        .trim()
                                                        .isEmpty))) {
                                              _onShowSnackBar(
                                                  context, 'Invalid value');
                                              return;
                                            }
                                            _onAddOptionValueField(
                                                _optionsControllersMap
                                                    .entries.last.key);
                                          },
                                          child: Text('Add value'),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16.0,
                                      ),
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            if (_optionsControllersMap
                                                    .isEmpty ||
                                                _optionsControllersMap.entries
                                                    .any(
                                                  (option) {
                                                    return option.value.any(
                                                        (element) => element
                                                            .text
                                                            .trim()
                                                            .isEmpty);
                                                  },
                                                )) {
                                              _onShowSnackBar(
                                                  context, 'Invalid option');
                                              return;
                                            }
                                            var options = convertOptionsMap(
                                                _optionsControllersMap);
                                            _onStoreOption(options);
                                          },
                                          child: Text('Done'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          AddOptionButton(onAddOption: () {
                            if (_optionsControllersMap.entries.any((option) {
                              return option.key.text.trim().isEmpty ||
                                  option.value.any((optionValue) =>
                                      optionValue.text.trim().isEmpty);
                            })) {
                              _onShowSnackBar(context, 'Invalid option');
                            } else {
                              var options =
                                  convertOptionsMap(_optionsControllersMap);
                              _onStoreOption(options);
                              _onAddOptionField();
                            }
                          })
                        ],
                      )
                    else if (_optionsControllersMap.isNotEmpty &&
                        _optionsMap.isEmpty)
                      // column with input only
                      Column(
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
                                        controller: _optionsControllersMap
                                            .entries.last.key,
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
                                    children: _optionsControllersMap
                                        .entries.last.value
                                        .map((controller) {
                                      return OptionValueInputRow(
                                          controller: controller,
                                          onRemoveField: () {
                                            _removeOptionValue(
                                              _optionsControllersMap
                                                  .entries.last.key,
                                              _optionsControllersMap
                                                  .entries.last.value
                                                  .firstWhere((element) =>
                                                      element.text ==
                                                      controller.text),
                                            );
                                          });
                                    }).toList(),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        if (_optionsControllersMap.entries.any(
                                            (element) => element.value.any(
                                                (element) => element.text
                                                    .trim()
                                                    .isEmpty))) {
                                          _onShowSnackBar(
                                              context, 'Invalid value');
                                          return;
                                        }
                                        _onAddOptionValueField(
                                            _optionsControllersMap
                                                .entries.last.key);
                                      },
                                      child: Text('Add value'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        if (_optionsControllersMap.isEmpty ||
                                            _optionsControllersMap.entries.any(
                                              (option) {
                                                return option.value.any(
                                                    (element) => element.text
                                                        .trim()
                                                        .isEmpty);
                                              },
                                            )) {
                                          _onShowSnackBar(
                                              context, 'Invalid option');
                                          return;
                                        }
                                        var options = convertOptionsMap(
                                            _optionsControllersMap);

                                        _onStoreOption(options);
                                      },
                                      child: Text('Done'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          AddOptionButton(onAddOption: () {
                            if (_optionsControllersMap.entries.any((option) {
                              return option.key.text.trim().isEmpty ||
                                  option.value.any((optionValue) =>
                                      optionValue.text.trim().isEmpty);
                            })) {
                              _onShowSnackBar(context, 'Invalid option');
                            } else {
                              var options =
                                  convertOptionsMap(_optionsControllersMap);
                              _onStoreOption(options);
                              _onAddOptionField();
                            }
                          })
                        ],
                      )
                    else
                      // column with saved options only
                      OptionChipsSection(
                          optionsMap: _optionsMap,
                          onAddOption: () {
                            if (_optionsControllersMap.entries.any((option) {
                              return option.key.text.trim().isEmpty ||
                                  option.value.any((optionValue) =>
                                      optionValue.text.trim().isEmpty);
                            })) {
                              _onShowSnackBar(context, 'Invalid option');
                            } else {
                              var options =
                                  convertOptionsMap(_optionsControllersMap);
                              _onStoreOption(options);
                              _onAddOptionField();
                            }
                          })
                  else
                    SizedBox(
                      height: 0.0,
                    ),
                  if (_optionsEnabled ?? true && _optionsMap.isNotEmpty)
                    VariantsTable(
                        variants: _variantsMap,
                        enabledVariants: _enabledVariantsMap,
                        allVariantsEnabled: _allVariantsEnabled!,
                        onToggleAllVariants: (value) =>
                            _onToggleAllVariants(value),
                        onToggleVariant: (value) => _onToggleVariant(value))
                  else
                    SizedBox(height: 0.0)
                ],
              ),
            ),
          ),
      );
  }
}

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

class ControllersSection extends StatelessWidget {
  final Map<TextEditingController, List<TextEditingController>>
      optionControllersMap;
  final Function(TextEditingController) onRemoveField;
  final Function() onStoreOption;
  final Function() onAddOption;
  final Function() onAddOptionValue;

  const ControllersSection(
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
