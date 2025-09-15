import 'package:flutter/material.dart';
import 'tip_presenter.dart';
import 'tip_contract.dart';

class TipCalculatorPage extends StatefulWidget {
  const TipCalculatorPage({super.key, required this.title});
  final String title;

  @override
  State<TipCalculatorPage> createState() => _TipCalculatorPageState();
}

class _TipCalculatorPageState extends State<TipCalculatorPage> 
    implements TipContract_View {

  late TipPresenter _presenter;
  double _tip = 0.0;
  double _total = 0.0;

  final TextEditingController _billController = TextEditingController();
  final TextEditingController _tipPercentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _presenter = TipPresenter(this);
  }

  @override
  void updateTip(double tipAmount, double totalAmount) {
    setState(() {
      _tip = tipAmount;
      _total = totalAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _billController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Bill Amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tipPercentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Tip Percentage",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final bill = double.tryParse(_billController.text) ?? 0.0;
                final tipPercent = double.tryParse(_tipPercentController.text) ?? 0.0;
                _presenter.calculateTip(bill, tipPercent);
              },
              child: const Text("Calculate Tip"),
            ),
            const SizedBox(height: 20),
            Text("Tip Amount: \$${_tip.toStringAsFixed(2)}"),
            Text("Total Bill: \$${_total.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }
}
