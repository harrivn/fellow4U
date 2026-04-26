import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileService {
  final _client = Supabase.instance.client;

  Future<ProfileModel?> getProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;
    final data = await _client.from('profiles').select().eq('id', userId).single();
    return ProfileModel.fromJson(data);
  }

  Future<void> updateProfile(ProfileModel profile) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
    await _client.from('profiles').update(profile.toJson()).eq('id', userId);
  }

  Future<String?> uploadAvatar(Uint8List fileBytes, String fileName) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;
    final path = '$userId/$fileName';
    await _client.storage.from('avatars').uploadBinary(
      path, fileBytes,
      fileOptions: const FileOptions(upsert: true),
    );
    return _client.storage.from('avatars').getPublicUrl(path);
  }
}