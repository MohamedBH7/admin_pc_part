import 'package:admin_pc_part/config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// User model
class User {
  final String userID;
  final String username;
  final String password;
  final String birthday;
  final String email;
  final String address;
  final String phone;
  final DateTime createdAt;
  final String emailRequest;
  final String blocked;

  User({
    required this.userID,
    required this.username,
    required this.password,
    required this.birthday,
    required this.email,
    required this.address,
    required this.phone,
    required this.createdAt,
    required this.emailRequest,
    required this.blocked,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['UserID'] ?? 'N/A', // Changed to 'UserID' to match your database field
      username: json['Username'] ?? 'N/A',
      password: json['Password'] ?? 'N/A', // Changed to 'Password' to match your database field
      birthday: json['birthday'] ?? 'N/A', // Changed to 'Birthday' to match your database field
      email: json['Email'] ?? 'N/A',
      address: json['Address'] ?? 'N/A',
      phone: json['Phone'] ?? 'N/A',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      emailRequest: json['Email_Request'] ?? 'There is No Email Request',
      blocked: json['Blocked'] ?? false, // Changed to 'Blocked' to match your database field
    );
  }
}

// User service
class UserService {
  final String apiUrl = "${Config.apiBaseUrl}/server/email_admin.php";

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> updateEmailRequest(String userId, String newEmailRequest) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'userID': userId,
        'Email_Requset': newEmailRequest,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update email request');
    }
  }

  Future<void> changePassword(String userId, String newPassword) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'userID': userId,
        'Password': newPassword,
      },
    );

    if (response.statusCode != 200) {
      print('Failed to change password: ${response.body}');
      throw Exception('Failed to change password');
    } else {
      print('Password changed successfully: ${response.body}');

    }
  }
}

// Email Requests Page
class EmailRequestsPage extends StatefulWidget {
  final String userID;

  const EmailRequestsPage({super.key, required this.userID});

  @override
  _EmailRequestsPageState createState() => _EmailRequestsPageState();
}

class _EmailRequestsPageState extends State<EmailRequestsPage> {
  late Future<List<User>> futureUsers;
  final UserService userService = UserService();
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    futureUsers = userService.fetchUsers();
  }

  void _updateEmailRequest(String userId, String newEmailRequest) async {
    try {
      await userService.updateEmailRequest(userId, newEmailRequest);
      setState(() {
        futureUsers = userService.fetchUsers();
      });
    } catch (e) {
      print('Failed to update email request: $e');
    }
  }

  void _changePassword(String userId, String newPassword) async {
    try {
      await userService.changePassword(userId, newPassword);
      _updateEmailRequest(userId, ''); // Setting Email_Requset to empty string
    } catch (e) {
      print('Failed to change password: $e');
    }
  }

  void _sortByEmailRequest() {
    setState(() {
      _sortAscending = !_sortAscending;
      futureUsers = userService.fetchUsers().then((users) {
        users.sort((a, b) {
          if (_sortAscending) {
            return a.emailRequest.compareTo(b.emailRequest);
          } else {
            return b.emailRequest.compareTo(a.emailRequest);
          }
        });
        return users;
      });
    });
  }

  Future<String?> _showChangePasswordDialog(BuildContext context) async {
    final passwordController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: TextField(
            controller: passwordController,
            decoration: const InputDecoration(hintText: 'Enter new password'),
            obscureText: true,
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
                Navigator.of(context).pop(passwordController.text);
              },
              child: const Text('Change'),
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
        title: Row(
          children: [
            const Text('Email Requests'),
            const Spacer(),
            InkWell(
              onTap: _sortByEmailRequest,
              child: Image.asset(
                'lib/assets/sort.png',
                width: 24.0,
                height: 24.0,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return Card(
                child: ListTile(
                  title: Text(user.username),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${user.email}'),
                      Text('Phone: ${user.phone}'),
                      Text('Address: ${user.address}'),
                      Text('Birthday: ${user.birthday}'),
                      Text('Email Request: ${user.emailRequest}'),
                    ],
                  ),
                  trailing: InkWell(
                    onTap: () => _updateEmailRequest(user.userID, ''),
                    child: Image.asset(
                      'lib/assets/c.png',
                      width: 24.0,  // Adjust the size as needed
                      height: 24.0,
                    ),
                  ),
                  onTap: () async {
                    final newPassword = await _showChangePasswordDialog(context);
                    if (newPassword != null) {
                      _changePassword(user.userID, newPassword);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
