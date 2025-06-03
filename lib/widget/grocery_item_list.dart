import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widget/new_item.dart';

class GroceryItemList extends StatefulWidget {
  const GroceryItemList({super.key});

  @override
  State<GroceryItemList> createState() {
    return _GroceryItemListState();
  }
}

class _GroceryItemListState extends State<GroceryItemList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
      "flutter-prep-546fc-default-rtdb.firebaseio.com",
      "shopping_list.json",
    );
    try {
      final response = await http.get(url);
      if (_error == "null") {
        print(response.body);
        setState(() {
          _isLoading = false;
        });
      }
      final List<GroceryItem> loadedItems = [];
      final Map<String, dynamic> listData = json.decode(response.body) ?? {};
      for (final item in listData.entries) {
        final category =
            categories.entries
                .firstWhere(
                  (catItem) => catItem.value.title == item.value["category"],
                )
                .value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value["name"],
            quantity: item.value["quantity"],
            category: category,
          ),
        );
      }
      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = "Something went wrong! Please try again later.";
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) {
          return const NewItem();
        },
      ),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    final url = Uri.https(
      "flutter-prep-546fc-default-rtdb.firebaseio.com",
      "shopping_list/${item.id}.json",
    );
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text(
        _groceryItems.isEmpty
            ? 'No items added yet!'
            : 'Your items will appear here.',
        style: const TextStyle(fontSize: 20, color: Colors.grey),
      ),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          semanticsLabel: 'Loading groceries...',
          semanticsValue: 'Please wait while we fetch your groceries',
        ),
      );
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: Key(_groceryItems[index].id),
            onDismissed: (direction) {
              _removeItem(_groceryItems[index]);
            },
            child: ListTile(
              leading: Container(
                width: 24,
                height: 24,
                color: _groceryItems[index].category.color,
              ),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_groceryItems[index].name),
              ),
              trailing: Text(_groceryItems[index].quantity.toString()),
            ),
          );
        },
      );
    }
    if (_error != null) {
      content = Center(child: Text(_error!));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        centerTitle: false,
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
