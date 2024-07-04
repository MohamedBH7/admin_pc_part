import 'dart:convert';
import 'package:admin_pc_part/config.dart';
import 'package:http/http.dart' as http;
class Item {
  final String itemID;
  final String name;
  final int quantityAvailable;
  final String category;
  final String imageUrl;

  Item({
    required this.itemID,
    required this.name,
    required this.quantityAvailable,
    required this.category,
    required this.imageUrl,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemID: json['itemID'],
      name: json['Name'],
      quantityAvailable: int.parse(json['QuantityAvailable'].toString()),
      category: json['Category'],
      imageUrl: json['ImageURL'],
    );
  }
}


class ItemService {
  final String apiUrl = "${Config.apiBaseUrl}/server/manage_items.php";

  Future<List<Item>> fetchItems() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Item.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<void> updateItemQuantity(String itemId, int quantity) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'itemID': itemId,
        'quantity': quantity.toString(),
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update item quantity');
    }
  }
}