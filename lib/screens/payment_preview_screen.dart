import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/payment_service.dart';
import '../models/payment_model.dart';

class PaymentPreviewScreen extends StatefulWidget {
  final String tripId;
  final double amount;
  final String cardHolder;
  final String cardLast4;

  const PaymentPreviewScreen({
    super.key,
    required this.tripId,
    required this.amount,
    required this.cardHolder,
    required this.cardLast4,
  });

  @override
  State<PaymentPreviewScreen> createState() => _PaymentPreviewScreenState();
}

class _PaymentPreviewScreenState extends State<PaymentPreviewScreen> {
  final _paymentService = PaymentService();
  bool _loading = false;
  static const _teal = Color(0xFF2EC4A5);

  Future<void> _confirmPayment() async {
    setState(() => _loading = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final payment = PaymentModel(
        userId: userId,
        tripId: widget.tripId,
        cardHolder: widget.cardHolder,
        cardLast4: widget.cardLast4,
        amount: widget.amount,
      );

      final success = await _paymentService.createPayment(payment);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Thanh toán thành công! 🎉'),
              backgroundColor: _teal));
          // Quay về màn hình chính
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Thanh toán thất bại'), backgroundColor: Colors.red));
        }
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: const Icon(Icons.close, color: Colors.black87, size: 24),
                    ),
                  ),
                  const Text('Payment',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                ],
              ),
            ),
            // Stepper - cả 2 active
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              child: Row(children: [
                _stepCircle(true),
                Expanded(child: Container(height: 2, color: _teal)),
                _stepCircle(true),
              ]),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Payment Method',
                      style: TextStyle(
                          fontSize: 12, color: _teal, fontWeight: FontWeight.w500)),
                  Text('Preview & Check out',
                      style: TextStyle(
                          fontSize: 12, color: _teal, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Order Summary',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 24),
                    _buildRow('Trip ID', '#${widget.tripId.substring(0, 8)}'),
                    _buildRow('Card Holder', widget.cardHolder),
                    _buildRow('Card', '**** **** **** ${widget.cardLast4}'),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('\$${widget.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: _teal)),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _confirmPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _teal,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('CONFIRM & PAY',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2)),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepCircle(bool active) => Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: _teal),
        child: const Icon(Icons.check, color: Colors.white, size: 16),
      );

  Widget _buildRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.black54, fontSize: 14)),
            Text(value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      );
}
