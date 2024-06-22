import 'dart:convert';
import 'package:admin_pc_part/Settings/BlockedUsersPage.dart';
import 'package:admin_pc_part/Settings/CreateAdminAccountPage.dart';
import 'package:admin_pc_part/Settings/DeletedItemsPage.dart';
import 'package:admin_pc_part/Settings/EmailRequestsPage.dart';
import 'package:admin_pc_part/Settings/ManageQuantitiesPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final String userID;

  const SettingsPage({super.key, required this.userID});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences _prefs;
  late String userID;

  String _selectedLanguage = 'English';
  bool _notificationsEnabled = true;
  String _name = '';
  final String _address = '';
  String _phone = '';
  double _spend = 0;
  String _totalQuantityAvailable = '';
  String _blockedUsers = '';
  String _emailRequests = '';
  List<Map<String, dynamic>> _deletionLogs = [];

  final String _appVersion = '1.0.0';
  final String _appDeveloper = 'Mohamed Alsaffar';
  final String _appRegion = 'Bahrain';
  final String _thecurrency = 'USD';

  @override
  void initState() {
    super.initState();
    initPrefs();
    fetchData();
  }

  void initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = _prefs.getString('selectedLanguage') ?? 'English';
      _notificationsEnabled = _prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  void fetchData() async {
    final response = await http.get(Uri.parse(
        'http://192.168.68.111/server/admin_setting.php?userID=${widget.userID}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        _name = data['userInfo']['Username'] ?? '';
        _phone = data['userInfo']['Phone'] ?? '';
        _blockedUsers = data['blockedUsers'] ?? 'N/A';
        _emailRequests = data['emailRequests'] ?? 'N/A ';
        _totalQuantityAvailable = data['totalQuantityAvailable'] ?? 'N/A';

        _deletionLogs =
            List<Map<String, dynamic>>.from(data['deletionLogs'] ?? []);

        // Ensure data['spend'] is not null and can be parsed to double
        final spendValue = data['spend'];
        _spend = spendValue != null &&
                spendValue is String &&
                double.tryParse(spendValue) != null
            ? double.parse(spendValue)
            : spendValue is double
                ? spendValue
                : 0.0;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Text('Settings Management Page '),
            SizedBox(width: 8),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'App Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('Version: $_appVersion'),
                Text('Developer: $_appDeveloper'),
                Text('Region: $_appRegion'),
                Text('The currency: $_thecurrency'),
                const SizedBox(height: 16),
                const Text(
                  'Language',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: const Text('English'),
                  onTap: () {
                    // Action for changing language
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'User Information ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: Text('Name : $_name'),
                  onTap: () {
                    _editName();
                  },
                ),
                ListTile(
                  title: Text('Phone : $_phone'),
                  onTap: () {
                    _editPhone();
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Create Admin Account',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAdminAccountPage()),
                    );
                  },
                  child: const Text(
                    '\n Create New Account', // The text to display
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Additional Options',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: Text('Blocked Users: $_blockedUsers'),
                  onTap: () {
                    // Action for viewing blocked users
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BlockedUsersPage(userID: widget.userID)),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                      'Email Requests For Reset Password : $_emailRequests'),
                  onTap: () {
                    // Action for viewing email requests
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EmailRequestsPage(userID: widget.userID)),
                    );
                  },
                ),
                ListTile(
                  title: Text('Manage Quantities ($_totalQuantityAvailable) '),
                  onTap: () {
                    // Action for viewing current orders
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageQuantitiesPage()),
                    );
                  },
                  trailing: const ImageIcon(
                    AssetImage('lib/assets/pc.png'),
                    size: 24,
                  ),
                ),
                ListTile(
                  title: Text('Deleted Items (${_deletionLogs.length})'),
                  onTap: () {
                    // Action for viewing deleted items
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DeletedItemsPage(deletionLogs: _deletionLogs)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleNotifications(bool newValue) {
    setState(() {
      _notificationsEnabled = newValue;
      _prefs.setBool('notificationsEnabled', newValue);
    });
  }

  Future<void> _editName() async {
    final newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: TextFormField(
            initialValue: _name,
            decoration: const InputDecoration(hintText: 'Enter your new name'),
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, _name),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newName != null) {
      setState(() {
        _name = newName;
        updateUserInfo('Username', newName);
      });
    }
  }

  Future<void> _editPhone() async {
    final newPhone = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Phone'),
          content: TextFormField(
            initialValue: _phone,
            decoration:
                const InputDecoration(hintText: 'Enter your new phone number'),
            onChanged: (value) {
              setState(() {
                _phone = value;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, _phone),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newPhone != null) {
      setState(() {
        _phone = newPhone;
        updateUserInfo('Phone', newPhone);
      });
    }
  }

  void updateUserInfo(String field, String value) async {
    final uri = Uri.parse('http://192.168.68.111/server/update_admin_info.php');
    final body = {
      'userID': widget.userID,
      'field': field,
      'value': value,
    };

    print('Sending update request: $body');

    try {
      final response = await http.post(uri, body: body);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 'success') {
        print('Update successful: $field = $value');
      } else {
        print('Failed to update $field. Message: ${responseData['message']}');
        _showErrorDialog(responseData['message']);
      }
    } catch (e) {
      print('Error updating $field: $e');
      _showErrorDialog('An error occurred. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
