import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_photos_screen.dart';

class MyPhotosScreen extends StatefulWidget {
  const MyPhotosScreen({super.key});

  @override
  State<MyPhotosScreen> createState() => _MyPhotosScreenState();
}

class _MyPhotosScreenState extends State<MyPhotosScreen> {
  List<String> _photos = [
    'https://images.pexels.com/photos/1127119/pexels-photo-1127119.jpeg',
    'https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg',
    'https://images.pexels.com/photos/2161467/pexels-photo-2161467.jpeg',
    'https://images.pexels.com/photos/164175/pexels-photo-164175.jpeg',
    'https://images.pexels.com/photos/3155666/pexels-photo-3155666.jpeg',
    'https://images.pexels.com/photos/3408354/pexels-photo-3408354.jpeg',
  ];

  bool _uploading = false;

  // Mở AddPhotosScreen và nhận ảnh được chọn về
  Future<void> _openAddPhotos() async {
    final selected = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(builder: (_) => const AddPhotosScreen()),
    );
    if (selected != null && selected.isNotEmpty && mounted) {
      setState(() {
        // Thêm ảnh mới vào đầu danh sách, tránh trùng
        for (final url in selected) {
          if (!_photos.contains(url)) {
            _photos.insert(0, url);
          }
        }
      });
    }
  }

  // Chọn ảnh từ gallery điện thoại làm avatar
  Future<void> _pickAndSetAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (picked == null) return;

    setState(() => _uploading = true);
    try {
      final bytes = await picked.readAsBytes();
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      final path = '$userId/avatar_$userId.jpg';

      await Supabase.instance.client.storage.from('avatars').uploadBinary(
        path,
        bytes,
        fileOptions:
        const FileOptions(upsert: true, contentType: 'image/jpeg'),
      );

      final avatarUrl = Supabase.instance.client.storage
          .from('avatars')
          .getPublicUrl(path);

      await Supabase.instance.client
          .from('profiles')
          .update({'avatar_url': avatarUrl}).eq('id', userId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Cập nhật ảnh đại diện thành công!'),
            backgroundColor: Color(0xFF00BFA5)));
        Navigator.pop(context, avatarUrl);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  // Bấm vào ảnh trong danh sách để đặt làm avatar
  Future<void> _setAsAvatar(String url) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    setState(() => _uploading = true);
    try {
      await Supabase.instance.client
          .from('profiles')
          .update({'avatar_url': url}).eq('id', userId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Đã đặt làm ảnh đại diện!'),
            backgroundColor: Color(0xFF00BFA5)));
        Navigator.pop(context, url);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Photos',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: _uploading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF00BFA5)),
            SizedBox(height: 16),
            Text('Đang cập nhật...'),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Nút chọn ảnh từ điện thoại làm avatar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pickAndSetAvatar,
                icon: const Icon(Icons.photo_library, size: 18),
                label: const Text('Chọn từ thiết bị làm Avatar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BFA5),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Hướng dẫn
            const Text(
              'Hoặc bấm vào ảnh bên dưới để đặt làm avatar',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Row 1: Add Photos + 2 ảnh
            SizedBox(
              height: 110,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _openAddPhotos,
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF00BFA5), width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add,
                                color: Color(0xFF00BFA5), size: 28),
                            SizedBox(height: 4),
                            Text('Add Photos',
                                style: TextStyle(
                                    color: Color(0xFF00BFA5),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_photos.isNotEmpty)
                    Expanded(child: _photoTile(_photos[0])),
                  if (_photos.length > 1)
                    Expanded(child: _photoTile(_photos[1])),
                ],
              ),
            ),

            // Row 2: ảnh rộng
            if (_photos.length > 2)
              SizedBox(
                height: 160,
                child: Row(children: [
                  Expanded(flex: 3, child: _photoTile(_photos[2]))
                ]),
              ),

            // Row 3: 3 ảnh nhỏ
            if (_photos.length > 3)
              SizedBox(
                height: 110,
                child: Row(
                  children: [
                    if (_photos.length > 3)
                      Expanded(child: _photoTile(_photos[3])),
                    if (_photos.length > 4)
                      Expanded(child: _photoTile(_photos[4])),
                    if (_photos.length > 5)
                      Expanded(child: _photoTile(_photos[5])),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _photoTile(String url) {
    return GestureDetector(
      onTap: () => _setAsAvatar(url),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
            ),
          ),
          // Icon gợi ý bấm để đặt avatar
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.person_pin,
                  color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}