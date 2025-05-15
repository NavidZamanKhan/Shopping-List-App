import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/dummy_items.dart';

class GroceryItemList extends StatelessWidget {
  const GroceryItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          groceryItems
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 24,
                          width: 24,
                          color: item.category.color,
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(item.name),
                      const Spacer(),
                      Text(item.quantity.toString()),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }
}
