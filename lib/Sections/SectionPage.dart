import 'dart:convert';
import 'package:admin_pc_part/Sections/AddItemPage.dart';
import 'package:admin_pc_part/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';

class SectionPage extends StatefulWidget {
  final String userID;

  const SectionPage({super.key, required this.userID});

  @override
  _SectionPageState createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  late Future<List?> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = readData();
  }

  Future<List<Map<String, dynamic>>?> fetchDataForCategory(String category) async {
    var url = "${Config.apiBaseUrl}/server/Category.php?category=$category";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      List<dynamic> decodedData = jsonDecode(res.body);
      List<Map<String, dynamic>> mappedData = decodedData.map<Map<String, dynamic>>((item) => item.cast<String, dynamic>()).toList();
      return mappedData;
    } else {
      throw Exception("Failed to load data for category $category");
    }
  }

  Future<List?> readData() async {
    var url = "${Config.apiBaseUrl}/server/Category.php";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Text('Sections Of Category',style: TextStyle(color: Colors.indigo),),
            SizedBox(width: 8),
          ],
        ),
      ),
      body: Container(

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.indigo],
          ),
          image: DecorationImage(
            image: AssetImage("lib/assets/pc.png"),
            fit: BoxFit.cover,

          ),
        ),
        child: RefreshIndicator(
          onRefresh: () {
            setState(() {
              _dataFuture = readData();
            });
            return _dataFuture;
          },
          child: FutureBuilder<List?>(
            future: _dataFuture,
            builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else {
                List<dynamic>? dataList = snapshot.data;
                List<Map<String, dynamic>> list =
                    dataList?.cast<Map<String, dynamic>>() ?? [];

                Set<String> uniqueCategories = {};
                List<Map<String, dynamic>> uniqueList = [];

                for (var item in list) {
                  String category = item['Category']?.toString() ?? 'N/A';
                  if (!uniqueCategories.contains(category)) {
                    uniqueCategories.add(category);
                    uniqueList.add(item);
                  }
                }

                return ListView.builder(
                  itemCount: uniqueList.length,
                  itemBuilder: (BuildContext ctx, int i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddItemPage(
                              category: uniqueList[i]['Category'],
                              userID: widget.userID, // Pass the userID to AddItemPage
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: FadeIn(
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: ListTile(
                              title: Text(
                                uniqueList[i]['Category']?.toString() ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo, // Text color for better contrast
                                ),
                              ),
                              leading: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Colors.white, Colors.indigo],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Add', // Placeholder for the image
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
