import 'package:admin_pc_part/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddItemPage extends StatefulWidget {
  final String category;
  final String userID;

  const AddItemPage({super.key, required this.category, required this.userID});

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController imageURLController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FocusNode _lastFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _lastFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_lastFocusNode.hasFocus) {
      // Close the keyboard when the last text field loses focus
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> addItem() async {
    var url = "${Config.apiBaseUrl}/server/admin_AddItem.php";
    var response = await http.post(Uri.parse(url), body: {
      'category': widget.category,
      'name': nameController.text,
      'description': descriptionController.text,
      'price': priceController.text,
      'quantity': quantityController.text,
      'manufacturer': manufacturerController.text,
      'imageURL': imageURLController.text,
      'review': reviewController.text,
    });

    if (response.statusCode == 200) {
      // Item added successfully, clear text fields and show Snackbar
      clearTextFields();
      _showSnackBar('Item added successfully');
    } else {
      // Error handling
      _showSnackBar('Failed to add item');
    }
  }

  void clearTextFields() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    quantityController.clear();
    manufacturerController.clear();
    imageURLController.clear();
    reviewController.clear();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void dispose() {
    _lastFocusNode.removeListener(_onFocusChange);
    _lastFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Add New Item'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/pc.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputCard(
                  labelText: 'Name',
                  controller: nameController,
                  icon: 'lib/assets/name.png',
                ),
                const SizedBox(height: 10),
                _buildInputCard(
                  labelText: 'Description',
                  controller: descriptionController,
                  icon: 'lib/assets/description.png',
                ),
                const SizedBox(height: 10),
                _buildInputCard(
                  labelText: 'Price',
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  icon: 'lib/assets/price.png',
                ),
                const SizedBox(height: 10),
                _buildInputCard(
                  labelText: 'Quantity Available',
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  icon: 'lib/assets/quantity.png',
                ),
                const SizedBox(height: 10),
                _buildInputCard(
                  labelText: 'Manufacturer',
                  controller: manufacturerController,
                  icon: 'lib/assets/Manufacturer.png',
                ),
                const SizedBox(height: 10),
                _buildInputCard(
                  labelText: 'Image URL',
                  controller: imageURLController,
                  icon: 'lib/assets/img.png',
                ),
                const SizedBox(height: 10),
                _buildInputCard(
                  labelText: 'Review',
                  controller: reviewController,
                  icon: 'lib/assets/review.png',
                  lastFocusNode: _lastFocusNode,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: addItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      child: Text('Add Item', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required String labelText,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int? maxLines,
    required String icon,
    FocusNode? lastFocusNode,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero, // Remove default ListTile padding
              leading: CircleAvatar(
                radius: 20, // Adjust the radius as needed
                child: Image.asset(
                  icon,
                  fit: BoxFit.contain, // Ensure the image fits within the CircleAvatar
                ),
              ),
              title: Text(
                labelText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              focusNode: lastFocusNode,
            ),
          ],
        ),
      ),
    );
  }
}
