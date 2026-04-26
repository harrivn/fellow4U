import 'package:flutter/material.dart';
import 'add_photos_screen.dart';

class MyPhotosScreen extends StatefulWidget {
  const MyPhotosScreen({super.key});

  @override
  State<MyPhotosScreen> createState() => _MyPhotosScreenState();
}

class _MyPhotosScreenState extends State<MyPhotosScreen> {
  final List<String> _photos = [
    'https://images.pexels.com/photos/1127119/pexels-photo-1127119.jpeg',
    'https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg',
    'https://images.pexels.com/photos/2161467/pexels-photo-2161467.jpeg',
    'https://images.pexels.com/photos/164175/pexels-photo-164175.jpeg',
    'https://images.pexels.com/photos/3155666/pexels-photo-3155666.jpeg',
    'https://images.pexels.com/photos/3408354/pexels-photo-3408354.jpeg',
  ];

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
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(
              height: 110,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context, MaterialPageRoute(builder: (_) => const AddPhotosScreen())),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF00BFA5), width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Color(0xFF00BFA5), size: 28),
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
                  Expanded(child: _photoTile(_photos[0])),
                  Expanded(child: _photoTile(_photos[1])),
                ],
              ),
            ),
            SizedBox(
              height: 160,
              child: Row(children: [Expanded(flex: 3, child: _photoTile(_photos[2]))]),
            ),
            SizedBox(
              height: 110,
              child: Row(
                children: [
                  Expanded(child: _photoTile(_photos[3])),
                  Expanded(child: _photoTile(_photos[4])),
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
    return Container(
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }
}
