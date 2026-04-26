// lib/services/trip_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/trip_model.dart';

class TripService {
  final _client = Supabase.instance.client;

  // Tạo trip mới, trả về id
  Future<String?> createTrip(TripModel trip) async {
    final data = await _client
        .from('trips')
        .insert(trip.toJson())
        .select('id')
        .single();

    return data['id'] as String?;
  }

  // Lấy danh sách trips của user
  Future<List<TripModel>> getMyTrips() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final data = await _client
        .from('trips')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (data as List).map((e) => TripModel.fromJson(e)).toList();
  }

  // Lấy chi tiết 1 trip
  Future<TripModel?> getTripById(String tripId) async {
    final data = await _client
        .from('trips')
        .select()
        .eq('id', tripId)
        .single();

    return TripModel.fromJson(data);
  }

  // Đánh dấu trip finished
  Future<void> markFinished(String tripId) async {
    await _client
        .from('trips')
        .update({'status': 'finished'})
        .eq('id', tripId);
  }
}
