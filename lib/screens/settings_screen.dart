import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../models/profile_model.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _profileService = ProfileService();
  final _authService = AuthService();
  ProfileModel? _profile;
  bool _loading = true;
  bool notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    try {
      _profile = await _profileService.getProfile();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Settings',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00BFA5)))
          : Column(
        children: [
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF00BFA5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(
                        _profile?.avatarUrl ??
                            'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _profile?.fullName.isNotEmpty == true
                            ? _profile!.fullName.toUpperCase()
                            : 'USER',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _profile?.role ?? 'Traveler',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(profile: _profile),
                      ),
                    );
                    await _loadProfile();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1),
                    ),
                    child: const Text('EDIT PROFILE',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSettingItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              hasSwitch: true),
          _buildSettingItem(
              icon: Icons.language, title: 'Languages', hasArrow: true),
          _buildSettingItem(
              icon: Icons.payment, title: 'Payment', hasArrow: true),
          _buildSettingItem(
              icon: Icons.shield_outlined,
              title: 'Privacy & Policies',
              hasArrow: true),
          _buildSettingItem(
              icon: Icons.feedback_outlined,
              title: 'Feedback',
              hasArrow: true),
          _buildSettingItem(
              icon: Icons.bar_chart_outlined,
              title: 'Usage',
              hasArrow: true),
          const Spacer(),
          TextButton(
            onPressed: _signOut,
            child: const Text('Sign out',
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    bool hasSwitch = false,
    bool hasArrow = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.black87, size: 24),
          const SizedBox(width: 16),
          Expanded(
              child: Text(title,
                  style: const TextStyle(color: Colors.black87, fontSize: 16))),
          if (hasSwitch)
            Switch(
              value: notificationsEnabled,
              onChanged: (value) => setState(() => notificationsEnabled = value),
              activeThumbColor: const Color(0xFF00BFA5),
            ),
          if (hasArrow)
            const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
        ],
      ),
    );
  }
}