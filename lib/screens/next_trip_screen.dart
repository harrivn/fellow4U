import 'package:flutter/material.dart';
import 'payment_checkout_screen.dart';

class NextTripPage extends StatelessWidget {
  final String tripId;
  final double amount;

  const NextTripPage({
    super.key,
    required this.tripId,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, size: 24),
                  ),
                  const Text('Trip Detail',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Icon(Icons.more_horiz, size: 24),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 180,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://th.bing.com/th/id/R.7602ef483a6b870cccd7d8abf7898525?rik=BHWH5rqimys6rg&riu=http%3a%2f%2f2.bp.blogspot.com%2f-UYLkDryiibE%2fUg7pQf0O9II%2fAAAAAAAAAzk%2fwF6hiCsUkkY%2fs1600%2fho-guom-8.jpg&ehk=fFcfZlGjiTlAELOhLs1y1RmxmpKKHAfz5RBG54q5jSM%3d&risl=&pid=ImgRaw&r=0',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Positioned(
                          bottom: 10, left: 12,
                          child: Row(children: [
                            Icon(Icons.location_on, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('Hanoi, Vietnam',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                          ]),
                        ),
                        Positioned(
                          top: 110, right: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF00C9A7), width: 4),
                            ),
                            child: const CircleAvatar(
                              radius: 29,
                              backgroundImage: NetworkImage(
                                'https://tse4.mm.bing.net/th/id/OIP.OnzlYU8LwcfzXSrzV3ne0QHaE8?rs=1&pid=ImgDetMain&o=7&rm=3',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _InfoRow(label: 'Date', value: 'Feb 2, 2020'),
                          const SizedBox(height: 12),
                          const _InfoRow(label: 'Time', value: '8:00AM - 10:00AM'),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Guide',
                                  style: TextStyle(fontSize: 14, color: Colors.black54)),
                              Text('Emmy',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF00C9A7))),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const _InfoRow(label: 'Number of Travelers', value: '2'),
                          const SizedBox(height: 12),
                          const Text('Attractions',
                              style: TextStyle(fontSize: 14, color: Colors.black54)),
                          const SizedBox(height: 8),
                          const Wrap(spacing: 8, runSpacing: 8, children: [
                            _AttractionChip(label: 'Ho Guom'),
                            _AttractionChip(label: 'Ho Hoan Kiem'),
                            _AttractionChip(label: 'Pho 12 Pho Kim Ma'),
                          ]),
                          const SizedBox(height: 20),
                          const Divider(height: 1, color: Color(0xFFEEEEEE)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Fee',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('\$${amount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF00C9A7))),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.chat_bubble_outline,
                                    size: 16, color: Color(0xFF00C9A7)),
                                label: const Text('Chat',
                                    style: TextStyle(color: Color(0xFF00C9A7))),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF00C9A7)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
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
                                        tripId: tripId,
                                        amount: amount,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.credit_card, size: 16),
                                label: const Text('Pay'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00C9A7),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _AttractionChip extends StatelessWidget {
  final String label;
  const _AttractionChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.location_on, size: 12, color: Color(0xFF00C9A7)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
      ]),
    );
  }
}