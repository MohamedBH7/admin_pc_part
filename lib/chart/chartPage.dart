import 'package:admin_pc_part/config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChartPage extends StatefulWidget {
  final String userID;

  const ChartPage({super.key, required this.userID});

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  Map<String, dynamic> jsonData = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('${Config.apiBaseUrl}/server/most_selling_items.php'));
      if (response.statusCode == 200) {
        setState(() {
          jsonData = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Widget buildCard(String title, List<dynamic> data) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      color: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.isNotEmpty
                  ? data.map<Widget>((item) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var entry in item.entries)
                    Text(
                      '${entry.key}: ${entry.value ?? "N/A"}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 8),
                ],
              )).toList()
                  : [const Text('No data')],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Sales Report'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/background_1.png'), // Ensure you have this image in your assets folder
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kToolbarHeight + 20),
                buildCard('Total Amount                                                      ', [
                  {'Total Amount': jsonData['totalAmount']}
                ]),
                buildCard('Most User Buy                                                       ', [
                  {
                    'Username': jsonData['mostUserBuy']?['Username'],
                    'Phone': jsonData['mostUserBuy']?['Phone']
                  }
                ]),
                buildCard('Items on Shipping                                                       ', jsonData['itemsOnShipping'] ?? []),
                buildCard('Order Time Most Users Order', [
                  {
                    'PurchaseDate                                                        ': jsonData['orderTimeMostUsersOrder']?['PurchaseDate'],
                    'OrderCount': jsonData['orderTimeMostUsersOrder']?['OrderCount']
                  }
                ]),
                buildCard('Users Cart Items                                                       ', [
                  {
                    'UserID': jsonData['usersCartItems']?['UserID'],
                    'CartItemCount': jsonData['usersCartItems']?['CartItemCount'],
                    'ItemID': jsonData['usersCartItems']?['ItemID'],
                    'Name': jsonData['usersCartItems']?['Name']
                  }
                ]),
                buildCard('Most User Delete Items                                                       ', [
                  {
                    'Username': jsonData['mostUserDeleteItems']?['Username'],
                    'Phone': jsonData['mostUserDeleteItems']?['Phone']
                  }
                ]),
                buildCard('Most Active Users                                                       ', jsonData['mostActiveUsers'] ?? []),
                buildCard('Avg Time Between Purchases                                                        ', [
                  {'AvgTimeBetweenPurchases': jsonData['avgTimeBetweenPurchases']}
                ]),
                buildCard('Items Frequently Deleted                                                        ', jsonData['itemsFrequentlyDeleted'] ?? []),
                buildCard('Users With Highest Cart Value                                                         ', jsonData['usersWithHighestCartValue'] ?? []),
                buildCard('Most Common Purchase Date                                                         ', [
                  {
                    'PurchaseDate                                                        ': jsonData['mostCommonPurchaseDate']?['PurchaseDate'],
                    'TotalPurchases                                                        ': jsonData['mostCommonPurchaseDate']?['TotalPurchases']
                  }
                ]),
                buildCard('Total Revenue By Category                                                       ', jsonData['totalRevenueByCategory'] ?? []),
                buildCard('Total Revenue By Month                                                       ', jsonData['totalRevenueByMonth'] ?? []),
                buildCard('Total Purchases By User                                                       ', jsonData['totalPurchasesByUser'] ?? []),
                buildCard('Abandoned Cart Statistics', [
                  {
                    'TotalCarts ': jsonData['abandonedCartStatistics']?['TotalCarts'],
                    'AbandonedCarts': jsonData['abandonedCartStatistics']?['AbandonedCarts'],
                    'CompletedPurchases ': jsonData['abandonedCartStatistics']?['CompletedPurchases'],
                    'AbandonmentRate                                     ': jsonData['abandonedCartStatistics']?['AbandonmentRate']
                  }
                ]),
                buildCard('Purchases Per Item                                                       ', jsonData['purchasesPerItem'] ?? []),
                buildCard('Unique Purchases By User                                                       ', jsonData['uniquePurchasesByUser'] ?? []),
                buildCard('Location Based Statistics                                                       ', jsonData['locationBasedStatistics'] ?? []),
                buildCard('Avg Purchase Quantities                                                       ', jsonData['avgPurchaseAmountPerItem'] ?? []),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
