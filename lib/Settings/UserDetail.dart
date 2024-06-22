import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserDetailsPage extends StatefulWidget {
  final dynamic user;

  const UserDetailsPage({super.key, required this.user});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late bool _isBlocked;

  @override
  void initState() {
    super.initState();
    // Assuming 'Blocked' field is boolean or '1' for true and '0' for false
    _isBlocked = widget.user['Blocked'] == '1';
  }

  Future<void> _toggleBlockedStatus(int userID, int blocked) async {
    var url = 'http://192.168.68.111/server/Block_U.php?userID=$userID&blocked=$blocked';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print('User block status updated successfully');
      setState(() {
        _isBlocked = !_isBlocked;
      });
    } else {
      print('Failed to update user block status');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> _confirmToggleBlockedStatus() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text(_isBlocked
              ? 'Are you sure you want to unblock this user?'
              : 'Are you sure you want to block this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      int newBlockedStatus = _isBlocked ? 0 : 1;
      int userID = int.parse(widget.user['UserID']); // Ensure UserID is an int
      await _toggleBlockedStatus(userID, newBlockedStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('User Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  UserInfoTile(label: 'UserID', value: widget.user['UserID']),
                  UserInfoTile(label: 'Username', value: widget.user['Username']),
                  UserInfoTile(label: 'Password', value: widget.user['Password']),
                  UserInfoTile(label: 'Birthday', value: widget.user['birthday']),
                  UserInfoTile(label: 'Email', value: widget.user['Email']),
                  UserInfoTile(label: 'Address', value: widget.user['Address']),
                  UserInfoTile(label: 'Phone', value: widget.user['Phone']),
                  UserInfoTile(label: 'Created At', value: widget.user['created_at']),
                  UserInfoTile(label: 'Email Request', value: widget.user['Email_Requset']),
                  UserInfoTile(label: 'Blocked', value: widget.user['Blocked'].toString()),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _confirmToggleBlockedStatus,
                        child: Text(_isBlocked ? 'Unblock This User' : 'Block This User'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const UserInfoTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
