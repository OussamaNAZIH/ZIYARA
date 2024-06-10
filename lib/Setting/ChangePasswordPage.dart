import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  late String _currentPassword;
  late String _newPassword;
  late String _confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Current Password',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: TextStyle(
                    color: Colors.grey[500],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 219, 219, 219),
                      width: 2,
                    ),
                  ),
                ),
                obscureText: true,
                onChanged: (value) {
                  _currentPassword = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              const Text(
                'New Password',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(
                    color: Colors.grey[500],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 219, 219, 219),
                      width: 2,
                    ),
                  ),
                ),
                obscureText: true,
                onChanged: (value) {
                  _newPassword = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  labelStyle: TextStyle(
                    color: Colors.grey[500],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 219, 219, 219),
                      width: 2,
                    ),
                  ),
                ),
                obscureText: true,
                onChanged: (value) {
                  _confirmPassword = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password.';
                  } else if (value != _newPassword) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      // Reauthenticate user
                      var user = _auth.currentUser;
                      var credential = EmailAuthProvider.credential(
                          email: user!.email!, password: _currentPassword);
                      await user.reauthenticateWithCredential(credential);

                      // Update password
                      await user.updatePassword(_newPassword);

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Password updated successfully.'),
                        ),
                      );
                    } catch (error) {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Failed to update password. Verify your Password '),
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  'Change Password',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(
                      0xFF06B3C4), // Utiliser la couleur principale pour le bouton
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
