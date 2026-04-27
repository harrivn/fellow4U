import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/payment_model.dart';

class PaymentService {
  final _client = Supabase.instance.client;

  // Tạo payment record
  Future<bool> createPayment(PaymentModel payment) async {
    try {
      await _client.from('payments').insert(payment.toJson());

      // Cập nhật status payment thành success
      await _client
          .from('payments')
          .update({'status': 'success'})
          .eq('trip_id', payment.tripId)
          .eq('user_id', payment.userId);

      return true;
    } catch (_) {
      return false;
    }
  }

  // Lấy lịch sử payment
  Future<List<PaymentModel>> getMyPayments() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final data = await _client
        .from('payments')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (data as List).map((e) => PaymentModel.fromJson(e)).toList();
  }
}
