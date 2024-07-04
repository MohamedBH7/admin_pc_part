import 'package:admin_pc_part/Settings/UserDetail.dart';
import 'package:admin_pc_part/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BlockedUsersPage extends StatefulWidget {
  final String userID;

  const BlockedUsersPage({super.key, required this.userID});

  @override
  _BlockedUsersPageState createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  List<dynamic> users = [];
  String filter = 'All';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
    await http.get(Uri.parse('${Config.apiBaseUrl}/server/Block_U.php'));

    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> toggleBlockedStatus(
      int userID, bool currentBlockedStatus) async {
    final response = await http.get(Uri.parse(
        '${Config.apiBaseUrl}/block_U.php?userID=$userID&blocked=${!currentBlockedStatus}'));

    if (response.statusCode == 200) {
      // Update UI
      fetchData();
    } else {
      throw Exception('Failed to toggle blocked status');
    }
  }

  List<dynamic> filterUsers() {
    switch (filter) {
      case 'Blocked':
        return users.where((user) => user['Blocked'] == '1').toList();
      case 'Email Request':
        return users.where((user) => user['Email_Requset'].isNotEmpty).toList();
      case 'First Date':
      // Assuming 'created_at' is in format 'YYYY-MM-DD HH:MM:SS'
        return users.where((user) => user['created_at'].startsWith('2024-04-25')).toList();
      default:
        return users;
    }
  }

  Future<void> _refreshData() async {
    await fetchData();
  }

  void _showUserData(dynamic user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsPage(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Users'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            DropdownButton<String>(
              value: filter,
              onChanged: (String? value) {
                setState(() {
                  filter = value!;
                });
              },
              items: <String>[
                'All',
                'Blocked',
                'Email Request',
                'First Date'
              ].map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ),
              ).toList(),
              icon: Image.asset(
                'lib/assets/sort.png', // Replace 'filter.png' with your image asset path
                width: 24,
                height: 24,
              ),
            ),
            Expanded(
              child: users.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: filterUsers().length,
                itemBuilder: (context, index) {
                  final user = filterUsers()[index];
                  return Card(
                    child: ListTile(
                      title: Text(user['Username']),
                      subtitle: Text(user['Email']),
                      onTap: () {
                        _showUserData(user);
                      },
                      trailing: GestureDetector(
                        onTap: () {
                          toggleBlockedStatus(
                              user['UserID'], user['Blocked'] == '1');
                        },
                        child: Image.asset(
                          'lib/assets/user.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


