import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/vowora_theme.dart';
import '../models/wedding_booking_model.dart';

class VoworaPaymentGatewaySheet extends StatefulWidget {
  final double payableAmount;
  final String serviceTitle;
  final String weddingId;
  final Function(PaymentRecordModel record) onPaymentCompleted;

  const VoworaPaymentGatewaySheet({
    super.key,
    required this.payableAmount,
    required this.serviceTitle,
    required this.weddingId,
    required this.onPaymentCompleted,
  });

  static void show(
    BuildContext context, {
    required double payableAmount,
    required String serviceTitle,
    required String weddingId,
    required Function(PaymentRecordModel record) onPaymentCompleted,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF141210),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: VoworaPaymentGatewaySheet(
            payableAmount: payableAmount,
            serviceTitle: serviceTitle,
            weddingId: weddingId,
            onPaymentCompleted: onPaymentCompleted,
          ),
        );
      },
    );
  }

  @override
  State<VoworaPaymentGatewaySheet> createState() =>
      _VoworaPaymentGatewaySheetState();
}

class _VoworaPaymentGatewaySheetState
    extends State<VoworaPaymentGatewaySheet> {
  int _selectedCategoryTab = 1; // 0: Card, 1: Mobile Banking, 2: Net Banking, 3: More
  String _selectedMobileProvider = 'bKash';
  String _paymentType = '50% Advance (Half Payment)';

  final TextEditingController _trxIdCtrl =
      TextEditingController(text: '8N7X2P9Q1M');
  final TextEditingController _phoneCtrl =
      TextEditingController(text: '+880 1712345678');
  final TextEditingController _cardNumberCtrl =
      TextEditingController(text: '4111 2222 3333 4444');
  final TextEditingController _cardExpiryCtrl =
      TextEditingController(text: '12/28');
  final TextEditingController _cardCvcCtrl =
      TextEditingController(text: '888');

  final List<Map<String, dynamic>> _mobileProviders = [
    {'name': 'bKash', 'icon': '💖', 'color': const Color(0xFFE2136E), 'merchant': '01711223344'},
    {'name': 'Rocket', 'icon': '🟣', 'color': const Color(0xFF8C3494), 'merchant': '01911223344'},
    {'name': 'Nagad', 'icon': '🟠', 'color': const Color(0xFFF7941D), 'merchant': '01811223344'},
    {'name': 'Upay', 'icon': '🟡', 'color': const Color(0xFFFFC20E), 'merchant': '01611223344'},
    {'name': 'CellFin', 'icon': '💚', 'color': const Color(0xFF008037), 'merchant': '01511223344'},
    {'name': 'CashBaba', 'icon': '🟢', 'color': const Color(0xFF00A859), 'merchant': '01311223344'},
    {'name': 'Rainbow', 'icon': '🌈', 'color': const Color(0xFFE81123), 'merchant': '01411223344'},
    {'name': 'Tap', 'icon': '🔴', 'color': const Color(0xFFED1C24), 'merchant': '01700000000'},
    {'name': 'OK Wallet', 'icon': '💛', 'color': const Color(0xFFF9A825), 'merchant': '01800000000'},
    {'name': 'Pathao Pay', 'icon': '💙', 'color': const Color(0xFF0072CE), 'merchant': '01900000000'},
  ];

  @override
  void dispose() {
    _trxIdCtrl.dispose();
    _phoneCtrl.dispose();
    _cardNumberCtrl.dispose();
    _cardExpiryCtrl.dispose();
    _cardCvcCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double actualPayable = _paymentType == '50% Advance (Half Payment)'
        ? (widget.payableAmount * 0.5)
        : widget.payableAmount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modal Top Drag Indicator
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Merchant Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: VoworaColors.champagneGold.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_rounded,
                      color: VoworaColors.champagneGold,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VOWORA Gateway',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Ref: ${widget.weddingId}',
                        style: GoogleFonts.plusJakartaSans(
                          color: VoworaColors.champagneGold,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white60),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Total Amount & Installment Selector Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: VoworaColors.champagneGold.withValues(alpha: 0.35),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'You are paying',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6FCFB0).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Pay with Bangla QR ✓',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF6FCFB0),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    Text(
                      '৳${actualPayable.toStringAsFixed(0)}',
                      style: GoogleFonts.playfairDisplay(
                        color: VoworaColors.champagneGold,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${widget.serviceTitle})',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.white.withValues(alpha: 0.12)),
                const SizedBox(height: 6),

                // Installment / Advance Option Chips
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('50% Half Advance'),
                        selected: _paymentType == '50% Advance (Half Payment)',
                        selectedColor: VoworaColors.champagneGold,
                        backgroundColor: Colors.white12,
                        labelStyle: TextStyle(
                          color: _paymentType == '50% Advance (Half Payment)'
                              ? Colors.black
                              : Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _paymentType = '50% Advance (Half Payment)';
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Full Payment'),
                        selected: _paymentType == 'Full Payment',
                        selectedColor: VoworaColors.champagneGold,
                        backgroundColor: Colors.white12,
                        labelStyle: TextStyle(
                          color: _paymentType == 'Full Payment'
                              ? Colors.black
                              : Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _paymentType = 'Full Payment';
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Payment Category Tabs (Card, Mobile Banking, Net Banking, More)
          Row(
            children: [
              _buildCategoryTab(0, Icons.credit_card_rounded, 'Card'),
              const SizedBox(width: 6),
              _buildCategoryTab(1, Icons.phone_android_rounded, 'Mobile Banking'),
              const SizedBox(width: 6),
              _buildCategoryTab(2, Icons.account_balance_rounded, 'Net Banking'),
            ],
          ),
          const SizedBox(height: 16),

          // Tab Content 1: Mobile Banking Provider Grid
          if (_selectedCategoryTab == 1) ...[
            Text(
              'PAY WITH MOBILE BANKING',
              style: GoogleFonts.plusJakartaSans(
                color: VoworaColors.champagneGold,
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.2,
              ),
              itemCount: _mobileProviders.length,
              itemBuilder: (context, index) {
                final p = _mobileProviders[index];
                final isSel = _selectedMobileProvider == p['name'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMobileProvider = p['name'];
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSel
                          ? (p['color'] as Color).withValues(alpha: 0.25)
                          : Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSel
                            ? (p['color'] as Color)
                            : Colors.white.withValues(alpha: 0.15),
                        width: isSel ? 2.0 : 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(p['icon'], style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          p['name'],
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight:
                                isSel ? FontWeight.bold : FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Merchant Number Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: VoworaColors.champagneGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: VoworaColors.champagneGold.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: VoworaColors.champagneGold, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Send Money / Cash Out to $_selectedMobileProvider Merchant: 01711223344, then enter TrxID below.',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // TrxID & Phone Fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _trxIdCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'TrxID (Transaction ID)',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Sender Phone Number',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Tab Content 2: Card Payment Form
          if (_selectedCategoryTab == 0) ...[
            Text(
              'PAY WITH CREDIT / DEBIT CARD',
              style: GoogleFonts.plusJakartaSans(
                color: VoworaColors.champagneGold,
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _cardNumberCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Card Number',
                prefixIcon: const Icon(Icons.credit_card, color: VoworaColors.champagneGold),
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cardExpiryCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Expiry Date (MM/YY)',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _cardCvcCtrl,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'CVV / CVC',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Tab Content 3: Net Banking
          if (_selectedCategoryTab == 2) ...[
            Text(
              'SELECT NET BANKING PROVIDER',
              style: GoogleFonts.plusJakartaSans(
                color: VoworaColors.champagneGold,
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Islami Bank', 'City Touch', 'DBBL Nexus', 'EBL Skybanking', 'BRAC Bank'].map((b) {
                return Chip(
                  label: Text(b, style: const TextStyle(color: Colors.white, fontSize: 11)),
                  backgroundColor: Colors.white12,
                  side: const BorderSide(color: VoworaColors.champagneGold),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 20),

          // Submit & Pay Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                final invoiceNo =
                    'INV-2026-${(1000 + (DateTime.now().millisecondsSinceEpoch % 8999))}';
                final methodStr = _selectedCategoryTab == 1
                    ? _selectedMobileProvider
                    : (_selectedCategoryTab == 0 ? 'Credit Card' : 'Net Banking');

                final record = PaymentRecordModel(
                  id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
                  weddingId: widget.weddingId,
                  date: DateTime.now(),
                  serviceName: widget.serviceTitle,
                  amount: actualPayable,
                  paymentMethod: methodStr,
                  transactionId: _trxIdCtrl.text.trim(),
                  senderPhone: _phoneCtrl.text.trim(),
                  paymentType: _paymentType,
                  invoiceNo: invoiceNo,
                  status: 'Pending Verification',
                );

                widget.onPaymentCompleted(record);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Payment Submitted via $methodStr! Status: Pending Verification (Invoice: $invoiceNo) 💳'),
                    backgroundColor: VoworaColors.champagneGold,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: VoworaColors.champagneGold,
                foregroundColor: const Color(0xFF141210),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: Text(
                'Pay ৳${actualPayable.toStringAsFixed(0)}',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Security Footer
          Center(
            child: Text(
              'Secured by Vowora Gateway  •  256-bit Encryption  •  PCI-DSS Certified',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white38,
                fontSize: 9.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(int index, IconData icon, String label) {
    final isSel = _selectedCategoryTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategoryTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSel
                ? VoworaColors.champagneGold
                : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSel ? VoworaColors.champagneGold : Colors.white24,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSel ? const Color(0xFF141210) : Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  color: isSel ? const Color(0xFF141210) : Colors.white,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
