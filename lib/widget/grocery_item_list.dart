import 'package:flutter/material.dart';
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
  final List<GroceryItem> _groceryItems = [];

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
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: Key(_groceryItems[index].id),
            onDismissed: (direction) {
              setState(() {
                _groceryItems.removeAt(index);
              });
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
