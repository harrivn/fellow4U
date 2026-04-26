// lib/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';
import 'my_photos_screen.dart';
import 'change_password_screen.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileModel? profile;
  const EditProfileScreen({super.key, this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  final _profileService = ProfileService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.profile?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: widget.profile?.lastName ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    try {
      final updated = ProfileModel(
        id: widget.profile?.id ?? '',
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        avatarUrl: widget.profile?.avatarUrl,
        role: widget.profile?.role ?? 'Traveler',
      );
      await _profileService.updateProfile(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Cập nhật thành công'),
            backgroundColor: Color(0xFF00BFA5)));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
        title: const Text('Edit Profile',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _loading ? null : _save,
            child: _loading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Color(0xFF00BFA5)))
                : const Text('SAVE',
                    style: TextStyle(
                        color: Color(0xFF00BFA5),
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.profile?.avatarUrl ??
                              'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const MyPhotosScreen())),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00BFA5),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child:
                            const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(child: _buildTextField('First Name', _firstNameController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Last Name', _lastNameController)),
                ],
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ChangePasswordScreen())),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: const Text('Change Password',
                      style: TextStyle(
                          color: Color(0xFF00BFA5),
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            enabledBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF00BFA5))),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ],
    );
  }
}
