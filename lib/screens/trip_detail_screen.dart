// lib/screens/trip_detail_screen.dart
import 'package:flutter/material.dart';
import '../services/trip_service.dart';
import '../models/trip_model.dart';
import 'next_trip_screen.dart';
import 'payment_checkout_screen.dart';

class TripDetailPage extends StatefulWidget {
  final String tripId;
  const TripDetailPage({super.key, required this.tripId});

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  final _tripService = TripService();
  TripModel? _trip;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTrip();
  }

  Future<void> _loadTrip() async {
    try {
      _trip = await _tripService.getTripById(widget.tripId);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _markFinished() async {
    await _tripService.markFinished(widget.tripId);
    if (mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const NextTripPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
                const Spacer(),
                const Text('Trip Detail',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                const SizedBox(width: 24),
              ]),
              const SizedBox(height: 16),
              _loading
                  ? const Expanded(
                      child: Center(
                          child: CircularProgressIndicator(color: Color(0xFF00C4A0))))
                  : _trip == null
                      ? const Expanded(
                          child: Center(child: Text('Không tìm thấy chuyến đi')))
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildImageSection(),
                                  _buildDetailSection(),
                                ],
                              ),
                            ),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(children: [
      ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Image.network(
          'https://th.bing.com/th/id/R.5b42240afe8f03f8a1baddd46444dc5e?rik=l7mqebDY0ZD8EQ&pid=ImgRaw&r=0',
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        bottom: 16,
        left: 16,
        child: Row(children: [
          const Icon(Icons.location_on, color: Colors.white, size: 18),
          const SizedBox(width: 4),
          Text(_trip?.location ?? '',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ]),
      ),
      const Positioned(
        right: 16,
        bottom: 10,
        child: CircleAvatar(
          radius: 38,
          backgroundColor: Colors.teal,
          child: CircleAvatar(
            radius: 34,
            backgroundImage: NetworkImage(
              'https://tse4.mm.bing.net/th/id/OIP.OnzlYU8LwcfzXSrzV3ne0QHaE8?rs=1&pid=ImgDetMain&o=7&rm=3',
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildDetailSection() {
    final trip = _trip!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (trip.date != null) _buildInfoRow('Date', trip.date!),
        if (trip.fromTime != null && trip.toTime != null)
          _buildInfoRow('Time', '${trip.fromTime} - ${trip.toTime}'),
        if (trip.guideName != null) _buildInfoRow('Guide', trip.guideName!, highlight: true),
        _buildInfoRow('Travelers', '${trip.numberOfTravelers}'),
        if (trip.attractions.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text('Attractions', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: trip.attractions
                .map((a) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal.shade200),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.location_on, color: Colors.teal, size: 14),
                        const SizedBox(width: 4),
                        Text(a, style: const TextStyle(fontSize: 13)),
                      ]),
                    ))
                .toList(),
          ),
        ],
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Fee', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('\$${trip.fee.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal)),
        ]),
        const SizedBox(height: 16),
        const Divider(height: 1),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _markFinished,
              icon: const Icon(Icons.check, color: Colors.black87, size: 18),
              label: const Text('Mark Finished', style: TextStyle(color: Colors.black87)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                side: const BorderSide(color: Colors.black26),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentScreen(
                      tripId: widget.tripId,
                      amount: trip.fee,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.credit_card, size: 18),
              label: const Text('Pay'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _buildInfoRow(String title, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value,
              style: TextStyle(
                  color: highlight ? Colors.teal : Colors.black87,
                  fontWeight: highlight ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
