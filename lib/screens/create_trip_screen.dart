// lib/screens/create_trip_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/trip_service.dart';
import '../models/trip_model.dart';
import 'trip_detail_screen.dart';

class AttractionItem {
  final String name;
  final String imagePath;
  bool isSelected;

  AttractionItem({required this.name, required this.imagePath, this.isSelected = false});
}

class CreateNewTripScreen extends StatefulWidget {
  const CreateNewTripScreen({super.key});

  @override
  State<CreateNewTripScreen> createState() => _CreateNewTripScreenState();
}

class _CreateNewTripScreenState extends State<CreateNewTripScreen> {
  int numberOfTravelers = 1;
  final _locationController = TextEditingController(text: 'Danang, Vietnam');
  final _dateController = TextEditingController();
  final _fromTimeController = TextEditingController();
  final _toTimeController = TextEditingController();
  final _feeController = TextEditingController();
  final _tripService = TripService();
  bool _loading = false;

  final List<AttractionItem> attractions = [
    AttractionItem(
      name: 'Dragon Bridge',
      imagePath: 'https://images.pexels.com/photos/1179229/pexels-photo-1179229.jpeg',
      isSelected: true,
    ),
    AttractionItem(
      name: 'Cham Museum',
      imagePath: 'https://images.pexels.com/photos/2161467/pexels-photo-2161467.jpeg',
      isSelected: false,
    ),
    AttractionItem(
      name: 'My Khe Beach',
      imagePath: 'https://images.pexels.com/photos/1032650/pexels-photo-1032650.jpeg',
      isSelected: true,
    ),
  ];

  static const Color primaryTeal = Color(0xFF00C4A0);
  static const Color textGrey = Color(0xFF9E9E9E);
  static const Color textDark = Color(0xFF212121);
  static const Color borderColor = Color(0xFFE0E0E0);

  @override
  void dispose() {
    _locationController.dispose();
    _dateController.dispose();
    _fromTimeController.dispose();
    _toTimeController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  Future<void> _createTrip() async {
    if (_locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Vui lòng nhập địa điểm'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _loading = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final selectedAttractions =
      attractions.where((a) => a.isSelected).map((a) => a.name).toList();

      final trip = TripModel(
        userId: userId,
        location: _locationController.text.trim(),
        date: _dateController.text.trim().isNotEmpty ? _dateController.text.trim() : null,
        fromTime: _fromTimeController.text.trim().isNotEmpty ? _fromTimeController.text.trim() : null,
        toTime: _toTimeController.text.trim().isNotEmpty ? _toTimeController.text.trim() : null,
        numberOfTravelers: numberOfTravelers,
        fee: double.tryParse(_feeController.text) ?? 0,
        guideLanguage: 'Korean, English',
        attractions: selectedAttractions,
      );

      final tripId = await _tripService.createTrip(trip);

      if (!mounted) return;
      if (tripId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TripDetailPage(tripId: tripId)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Center(
                child: Text('Create New Trip',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600, color: textDark)),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildLocationField(),
                    const SizedBox(height: 20),
                    _buildDateField(),
                    const SizedBox(height: 20),
                    _buildTimeField(),
                    const SizedBox(height: 20),
                    _buildTravelersField(),
                    const SizedBox(height: 20),
                    _buildFeeField(),
                    const SizedBox(height: 20),
                    _buildLanguageField(),
                    const SizedBox(height: 20),
                    _buildAttractionsSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _createTrip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryTeal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('DONE',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(label,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: textDark)),
  );

  Widget _buildLocationField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSectionLabel('Where you want to explore'),
      Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: borderColor))),
        child: Row(children: [
          const Icon(Icons.location_on_outlined, size: 18, color: primaryTeal),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _locationController,
              style: const TextStyle(fontSize: 14, color: textDark),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8)),
            ),
          ),
        ]),
      ),
    ]);
  }

  Widget _buildDateField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSectionLabel('Date'),
      Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: borderColor))),
        child: Row(children: [
          const Icon(Icons.calendar_month_outlined, size: 18, color: textGrey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _dateController,
              style: const TextStyle(fontSize: 14, color: textDark),
              decoration: const InputDecoration(
                  hintText: 'mm/dd/yy',
                  hintStyle: TextStyle(color: textGrey, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8)),
            ),
          ),
        ]),
      ),
    ]);
  }

  Widget _buildTimeField() {
    Widget timeBox(TextEditingController ctrl, String hint) => Expanded(
      child: Container(
        decoration:
        const BoxDecoration(border: Border(bottom: BorderSide(color: borderColor))),
        child: Row(children: [
          const Icon(Icons.access_time, size: 18, color: textGrey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: ctrl,
              style: const TextStyle(fontSize: 14, color: textDark),
              decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(color: textGrey, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8)),
            ),
          ),
        ]),
      ),
    );

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSectionLabel('Time'),
      Row(children: [
        timeBox(_fromTimeController, 'From'),
        const SizedBox(width: 16),
        timeBox(_toTimeController, 'To'),
      ]),
    ]);
  }

  Widget _buildTravelersField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSectionLabel('Number of travelers'),
      Row(children: [
        GestureDetector(
          onTap: () {
            if (numberOfTravelers > 1) setState(() => numberOfTravelers--);
          },
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: numberOfTravelers > 1 ? primaryTeal : Colors.grey[300],
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 24),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 50, height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(6)),
          child: Text('$numberOfTravelers',
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600, color: textDark)),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => setState(() => numberOfTravelers++),
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
                color: primaryTeal, borderRadius: BorderRadius.circular(6)),
            child: const Icon(Icons.arrow_drop_up, color: Colors.white, size: 24),
          ),
        ),
      ]),
    ]);
  }

  Widget _buildFeeField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSectionLabel('Fee'),
      Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: borderColor))),
        child: Row(children: [
          Container(
            width: 20, height: 20,
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: textGrey, width: 1.5)),
            child: const Center(
              child: Text('\$',
                  style: TextStyle(
                      fontSize: 11, color: textGrey, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _feeController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 14, color: textDark),
              decoration: const InputDecoration(
                  hintText: 'Fee',
                  hintStyle: TextStyle(color: textGrey, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8)),
            ),
          ),
          const Text('(\$/hour)', style: TextStyle(fontSize: 13, color: textGrey)),
        ]),
      ),
    ]);
  }

  Widget _buildLanguageField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSectionLabel("Guide's Language"),
      Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: borderColor))),
        child: const Row(children: [
          Icon(Icons.language, size: 18, color: textGrey),
          SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('Korean, English', style: TextStyle(fontSize: 14, color: textDark)),
            ),
          ),
        ]),
      ),
    ]);
  }

  Widget _buildAttractionsSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSectionLabel('Attractions'),
      const SizedBox(height: 4),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.55,
        ),
        itemCount: attractions.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 1.5),
              ),
              child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.add, color: primaryTeal, size: 28),
                SizedBox(height: 4),
                Text('Add New',
                    style: TextStyle(
                        color: primaryTeal, fontSize: 13, fontWeight: FontWeight.w500)),
              ]),
            );
          }
          final item = attractions[index - 1];
          return GestureDetector(
            onTap: () => setState(() => item.isSelected = !item.isSelected),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(fit: StackFit.expand, children: [
                Image.network(item.imagePath, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, color: Colors.grey, size: 32))),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.55)],
                      ),
                    ),
                  ),
                ),
                Positioned(bottom: 8, left: 8, right: 8,
                    child: Text(item.name,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600,
                            shadows: [Shadow(blurRadius: 4, color: Colors.black54)]))),
                if (item.isSelected)
                  Positioned(top: 8, right: 8,
                      child: Container(
                        width: 24, height: 24,
                        decoration: const BoxDecoration(color: primaryTeal, shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: Colors.white, size: 16),
                      )),
              ]),
            ),
          );
        },
      ),
    ]);
  }
}