import 'package:admin_pc_part/config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeletedItemsPage extends StatefulWidget {
  final List<Map<String, dynamic>> deletionLogs;

  const DeletedItemsPage({super.key, required this.deletionLogs});

  @override
  _DeletedItemsPageState createState() => _DeletedItemsPageState();
}

class _DeletedItemsPageState extends State<DeletedItemsPage> {
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDeletedItems();
  }

  Future<void> fetchDeletedItems() async {
    try {
      final response = await http.get(Uri.parse('${Config.apiBaseUrl}/server/fetch_deleted_items.php'));
      if (response.statusCode == 200) {
        setState(() {
          items = json.decode(response.body);
          isLoading = false;
        });
      } else {
        showError('Failed to load deleted items');
      }
    } catch (e) {
      showError('Failed to load deleted items');
    }
  }

  Future<void> updateItem(String action, String logID, {String? quantity, String? price}) async {
    print('Action: $action, LogID: $logID, Quantity: $quantity, Price: $price');  // Debug print

    try {
      final response = await http.post(
        Uri.parse('${Config.apiBaseUrl}/server/update_deleted_items.php'),
        body: {
          'action': action,
          'LogID': logID,
          if (quantity != null) 'QuantityAvailable': quantity,
          if (price != null) 'Price': price,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.body)));
        fetchDeletedItems();  // Refresh the list
      } else {
        showError('Failed to update item');
      }
    } catch (e) {
      showError('Failed to update item');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void showRestoreDialog(String logID) {
    final quantityController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restore Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Restore'),
              onPressed: () {
                final quantity = quantityController.text;
                final price = priceController.text;
                updateItem('restore', logID, quantity: quantity, price: price);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(String logID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: const Text('Are you sure you want to delete this item permanently?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                updateItem('delete', logID);
                Navigator.of(context).pop();
              },
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
        centerTitle: true,
        title: const Text('Deleted Items'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              title: Text(item['Name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ItemID: ${item['ItemID']}'),
                  Text('Description: ${item['Description']}'),
                  Text('Price: \$${item['Price']}'),
                  Text('Quantity Available: ${item['QuantityAvailable']}'),
                  Text('Manufacturer: ${item['Manufacturer']}'),
                  item['ImageURL'] != null && item['ImageURL'].isNotEmpty
                      ? Image.network(item['ImageURL'], height: 100, width: 100)
                      : const SizedBox(),
                  Text('Review: ${item['review']}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Image.asset('lib/assets/restore.png', height: 30, width: 30),
                    onPressed: () => showRestoreDialog(item['LogID']),
                  ),
                  IconButton(
                    icon: Image.asset('lib/assets/del.png', height: 30, width: 30),
                    onPressed: () => showDeleteDialog(item['LogID']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
