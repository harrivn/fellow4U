import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _retypePasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureRetype = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _retypePasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill in all fields'), backgroundColor: Colors.red));
      return;
    }
    if (_newPasswordController.text != _retypePasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Passwords do not match'), backgroundColor: Colors.red));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password changed successfully'),
        backgroundColor: Color(0xFF00BFA5)));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Change Password',
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _onSave,
            child: const Text('SAVE',
                style: TextStyle(
                    color: Color(0xFF00BFA5), fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildPasswordField(
              label: 'Current Password',
              controller: _currentPasswordController,
              obscure: _obscureCurrent,
              onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
            ),
            const SizedBox(height: 32),
            _buildPasswordField(
              label: 'New Password',
              controller: _newPasswordController,
              obscure: _obscureNew,
              onToggle: () => setState(() => _obscureNew = !_obscureNew),
            ),
            const SizedBox(height: 32),
            _buildPasswordField(
              label: 'Retype New Password',
              controller: _retypePasswordController,
              obscure: _obscureRetype,
              onToggle: () => setState(() => _obscureRetype = !_obscureRetype),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            enabledBorder:
                const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF00BFA5))),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey, size: 20),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }
}
