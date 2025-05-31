import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/data/dummy_items.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:shopping_list_app/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _title = "";
  var _enteredAmount = 1;
  var _selecedCategory = categories[Categories.fruit]!;
  var _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      final url = Uri.https(
        "flutter-prep-546fc-default-rtdb.firebaseio.com",
        "shopping_list.json",
      );
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": _title,
          "quantity": _enteredAmount,
          "category": _selecedCategory.title,
        }),
      );

      final Map<String, dynamic> resData = json.decode(response.body);

      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(
        GroceryItem(
          id: resData["name"],
          name: _title,
          quantity: _enteredAmount,
          category: _selecedCategory,
        ),
      );
      // Navigator.of(context).pop(
      //   GroceryItem(
      //     id: DateTime.now().toString(),
      //     name: _title,
      //     quantity: _enteredAmount,
      //     category: _selecedCategory,
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text("Title"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    contentPadding: EdgeInsets.all(10),
                    hintText: "Enter a title",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length == 1 ||
                        value.trim().length > 50) {
                      return "Please enter a valid title";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),

                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text("Amount"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),

                          prefixText: "\$",
                        ),
                        initialValue: _enteredAmount.toString(),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return "Please enter a valid amount";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredAmount = int.parse(value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          label: const Text("Category"),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      color: category.value.color,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(category.value.title),
                                ],
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selecedCategory = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:
                          _isSending == true
                              ? null
                              : () {
                                _formKey.currentState!.reset();
                              },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: _isSending ? null : _saveItem,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child:
                          _isSending
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              )
                              : const Text("Add Item"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
