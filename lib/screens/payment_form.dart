import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/card_dao.dart';
import '../db/payment_dao.dart';
import '../models/card_model.dart';
import '../models/payment_model.dart';
import 'payment_review.dart';

class PaymentFormScreen extends StatefulWidget {
  final double totalAmount;
  const PaymentFormScreen({super.key, required this.totalAmount});

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

enum PayMethod { paypal, credit, wallet }

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  PayMethod _method = PayMethod.credit;
  final _formKey = GlobalKey<FormState>();
  final _holderCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _expMonthCtrl = TextEditingController();
  final _expYearCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  bool _saveCard = true;

  String get _brand {
    final n = _numberCtrl.text;
    if (n.startsWith('4')) return 'Visa';
    if (n.startsWith('5')) return 'Mastercard';
    if (n.startsWith('3')) return 'Amex';
    return 'Card';
  }

  @override
  void dispose() {
    _holderCtrl.dispose();
    _numberCtrl.dispose();
    _expMonthCtrl.dispose();
    _expYearCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final card = BankCard(
      holder: _holderCtrl.text.trim(),
      number: _numberCtrl.text.replaceAll(' ', ''),
      expMonth: int.parse(_expMonthCtrl.text),
      expYear: int.parse(_expYearCtrl.text),
      brand: _brand,
    );
    int? cardId;
    if (_saveCard && _method == PayMethod.credit) {
      cardId = await CardDao().insert(card);
    }
    final payment = Payment(
      cardId: cardId,
      amount: widget.totalAmount,
      method: _method.name,
    );
    await PaymentDao().insert(payment);
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaymentReviewScreen(
          amount: widget.totalAmount,
          method: _method,
          savedCard: cardId != null ? card : null,
        ),
      ),
    );
  }

  InputDecoration _dec(String label, {Widget? prefix}) => InputDecoration(
        labelText: label,
        prefixIcon: prefix,
      );

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency().format(widget.totalAmount);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment data'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(currency, style: Theme.of(context).textTheme.displayLarge?.copyWith(color: const Color(0xFF3E5BFF))),
            const SizedBox(height: 12),
            const Text('Payment Method'),
            const SizedBox(height: 8),
            SegmentedButton<PayMethod>(
              segments: const [
                ButtonSegment(value: PayMethod.paypal, label: Text('PayPal'), icon: Icon(Icons.account_balance_wallet_outlined)),
                ButtonSegment(value: PayMethod.credit, label: Text('Credit'), icon: Icon(Icons.credit_card)),
                ButtonSegment(value: PayMethod.wallet, label: Text('Wallet'), icon: Icon(Icons.wallet_outlined)),
              ],
              selected: {_method},
              onSelectionChanged: (s) => setState(() => _method = s.first),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _numberCtrl,
                    keyboardType: TextInputType.number,
                    decoration: _dec('Card number', prefix: const Icon(Icons.credit_card)),
                    validator: (v) {
                      final digits = (v ?? '').replaceAll(' ', '');
                      if (_method != PayMethod.credit) return null;
                      if (digits.length < 15) return 'Número inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _expMonthCtrl,
                          keyboardType: TextInputType.number,
                          decoration: _dec('Month'),
                          validator: (v) {
                            if (_method != PayMethod.credit) return null;
                            final m = int.tryParse(v ?? '');
                            if (m == null || m < 1 || m > 12) return 'Mes';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _expYearCtrl,
                          keyboardType: TextInputType.number,
                          decoration: _dec('Year'),
                          validator: (v) {
                            if (_method != PayMethod.credit) return null;
                            final y = int.tryParse(v ?? '');
                            if (y == null || y < DateTime.now().year % 100) return 'Año';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _cvvCtrl,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          decoration: _dec('CVV'),
                          validator: (v) {
                            if (_method != PayMethod.credit) return null;
                            final t = (v ?? '').trim();
                            if (t.length < 3) return 'CVV';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _holderCtrl,
                    decoration: _dec('Card holder'),
                    validator: (v) {
                      if (_method != PayMethod.credit) return null;
                      if ((v ?? '').trim().length < 4) return 'Nombre';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    value: _saveCard,
                    onChanged: (val) => setState(() => _saveCard = val),
                    title: const Text('Save card data for future payments'),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Proceed to confirm'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
