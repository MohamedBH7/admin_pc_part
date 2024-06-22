import 'package:flutter/material.dart';
import 'DetailsPage.dart';
// Importing http as an alias to avoid conflict with the class name

class CategoryPage extends StatefulWidget {
  final String category;
  final Future<List<Map<String, dynamic>>?> Function(String) fetchData; // Function to fetch data from the database
  final String userID; // New parameter

  // Updated constructor to accept the userID parameter
  const CategoryPage({super.key, required this.category, required this.fetchData, required this.userID});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Future<List<Map<String, dynamic>>?> _dataFuture;
  final TextEditingController _searchController = TextEditingController();
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _dataFuture = widget.fetchData(widget.category);
  }

  Future<void> _refreshData() async {
    setState(() {
      _dataFuture = widget.fetchData(widget.category);
    });
  }

  List<Map<String, dynamic>> _sortData(List<Map<String, dynamic>> data, String sortField, bool ascending) {
    data.sort((a, b) {
      double aValue = double.parse(a[sortField] ?? '0');
      double bValue = double.parse(b[sortField] ?? '0');
      return ascending ? bValue.compareTo(aValue) : aValue.compareTo(bValue);
    });
    return data;
  }

  List<Map<String, dynamic>> _filterData(List<Map<String, dynamic>> data, String keyword) {
    return data.where((item) {
      return item['Name']?.toLowerCase().contains(keyword.toLowerCase()) ?? false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _searching
            ? TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const ImageIcon(AssetImage('lib/assets/x.png')), // Cancel icon
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searching = false;
                  _dataFuture = widget.fetchData(widget.category);
                });
              },
            ),
          ),
          onChanged: (value) {
            setState(() {
              _searching = true;
            });
          },
        )
            : Text(widget.category),
        actions: [
          IconButton(
            icon: _searching ? const ImageIcon(AssetImage('lib/assets/x.png')) : const ImageIcon(AssetImage('lib/assets/search.png')), // Search icon
            onPressed: () {
              setState(() {
                if (_searching) {
                  _searchController.clear();
                  _dataFuture = widget.fetchData(widget.category);
                }
                _searching = !_searching;
              });
            },
          ),
          IconButton(
            icon: const ImageIcon(AssetImage('lib/assets/sort.png')), // Sort icon
            onPressed: () async {
              List<Map<String, dynamic>>? data = await _dataFuture;
              setState(() {
                _dataFuture = Future.value(_sortData(data!, 'Price', false)); // Sorting by price high to low
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<Map<String, dynamic>>?>(
          future: _dataFuture,
          builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              List<Map<String, dynamic>> list = snapshot.data ?? [];

              List<Map<String, dynamic>> filteredList = _searching ? _filterData(list, _searchController.text) : list;

              return ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (BuildContext ctx, int i) {
                  return GestureDetector(
                    onTap: () {
                      // Define the action to be taken when the item is clicked
                      // For example, you can navigate to another page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(
                            category: filteredList[i]['Category'] ?? '',
                            description: filteredList[i]['Description'] ?? '',
                            imageURL: filteredList[i]['ImageURL'] ?? '',
                            price: filteredList[i]['Price'] ?? '',
                            review: filteredList[i]['review'] ?? '',
                            quantityAvailable: filteredList[i]['QuantityAvailable'] ?? '',
                            name: filteredList[i]['Name'] ?? '',
                            itemID: filteredList[i]['ItemID'] ?? '',
                            userID: widget.userID, // userID is already ensured to be non-null
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          children: [
                            ListTile(
                              title: Text(
                                filteredList[i]['Name']?.toString() ?? 'N/A',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(filteredList[i]["Description"]?.toString() ?? 'N/A'),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  filteredList[i]["ImageURL"] ?? '', // Provide a default value if imageURL is null
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  filteredList[i]['Price']?.toString() ?? 'N/A',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
