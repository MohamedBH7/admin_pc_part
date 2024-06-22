import 'package:admin_pc_part/Settings/ItemService.dart';
import 'package:flutter/material.dart';

class ManageQuantitiesPage extends StatefulWidget {
  const ManageQuantitiesPage({super.key});

  @override
  _ManageQuantitiesPageState createState() => _ManageQuantitiesPageState();
}

class _ManageQuantitiesPageState extends State<ManageQuantitiesPage> {
  late Future<List<Item>> futureItems;
  final ItemService itemService = ItemService();

  @override
  void initState() {
    super.initState();
    futureItems = itemService.fetchItems();
  }

  void _updateQuantity(String itemId, int quantity) async {
    try {
      await itemService.updateItemQuantity(itemId, quantity);
      setState(() {
        futureItems = itemService.fetchItems();
      });
    } catch (e) {
      print('Failed to update quantity: $e');
    }
  }

  Future<int?> _showUpdateQuantityDialog(BuildContext context, int currentQuantity) async {
    final quantityController = TextEditingController(text: currentQuantity.toString());

    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Quantity'),
          content: TextField(
            controller: quantityController,
            decoration: const InputDecoration(hintText: 'Enter new quantity'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(int.tryParse(quantityController.text));
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Manage Quantities'),
      ),
      body: FutureBuilder<List<Item>>(
        future: futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items found'));
          }

          final items = snapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return Card(
                child: ListTile(
                  leading: Image.network(item.imageUrl),
                  title: Text(item.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category: ${item.category}'),
                      Text('Quantity: ${item.quantityAvailable}'),
                    ],
                  ),
                  trailing: InkWell(
                    onTap: () async {
                      final newQuantity = await _showUpdateQuantityDialog(context, item.quantityAvailable);
                      if (newQuantity != null) {
                        _updateQuantity(item.itemID, newQuantity);
                      }
                    },
                    child: Image.asset('lib/assets/em.png',
                        width: 50, height: 50), // Adjust the size as needed
                  ),

                ),
              );
            },
          );
        },
      ),
    );
  }
}
