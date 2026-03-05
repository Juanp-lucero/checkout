import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/card_model.dart';

import '../db/payment_dao.dart';
import '../models/payment_model.dart';

class PaymentReviewScreen extends StatefulWidget {
  final double amount;
  final dynamic method; // PayMethod from previous screen
  final BankCard? savedCard;
  const PaymentReviewScreen({
    super.key,
    required this.amount,
    required this.method,
    this.savedCard,
  });

  @override
  State<PaymentReviewScreen> createState() => _PaymentReviewScreenState();
}

class _PaymentReviewScreenState extends State<PaymentReviewScreen> {
  final _promoCtrl = TextEditingController();
  double _discount = 0.0;

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promoCtrl.text.trim().toUpperCase();
    if (code == 'PROMO20-08' && widget.amount >= 150) {
      setState(() => _discount = 50.0);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Promo aplicada: -\$50')));
    } else {
      setState(() => _discount = 0.0);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Código inválido')));
    }
  }

  Future<void> _pay() async {
    final p = Payment(
      amount: widget.amount,
      method: (widget.method as dynamic).name,
      discount: _discount,
      promoCode: _discount > 0 ? _promoCtrl.text.trim() : null,
      cardId: widget.savedCard?.id,
    );
    await PaymentDao().insert(p);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pago exitoso'),
        content: Text('Se procesó un cargo de ${NumberFormat.simpleCurrency().format(widget.amount - _discount)}'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.amount - _discount;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 130,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF8EA2FF), Color(0xFF3E5BFF)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black12, offset: Offset(0, 6))],
            ),
            padding: const EdgeInsets.all(16),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                r'$50 off',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Payment information', style: TextStyle(fontWeight: FontWeight.w600)),
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Edit'))
            ],
          ),
          Card(
            elevation: 0,
            color: const Color(0xFFF2F4F8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.deepOrange),
              title: const Text('Card holder'),
              subtitle: Text(widget.savedCard != null ? '${widget.savedCard!.brand} ending **${widget.savedCard!.number.substring(widget.savedCard!.number.length - 2)}' : 'N/A'),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Use promo code'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promoCtrl,
                  decoration: const InputDecoration(hintText: 'PROMO20-08'),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(onPressed: _applyPromo, child: const Text('Apply')),
            ],
          ),
          const SizedBox(height: 24),
          ListTile(
            title: const Text('Total'),
            trailing: Text(NumberFormat.simpleCurrency().format(total), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton(
            onPressed: _pay,
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            child: const Text('Pay'),
          ),
        ),
      ),
    );
  }
}
