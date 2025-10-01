import 'package:flutter/material.dart';
import 'tip_presenter.dart';
import 'tip_contract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  final List<String> _history = [];

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
      _history.add(
        "Bill: \$${_billController.text}, "
        "Tip: ${_tipPercentController.text}%, "
        "Tip Amt: \$${tipAmount.toStringAsFixed(2)}, "
        "Total: \$${totalAmount.toStringAsFixed(2)}"
      );
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
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/history',
                  arguments: _history,
                );
              },
              child: const Text("View History"),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("tipHistory")
              .orderBy("timestamp", descending: true) 
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No tip history saved yet.",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            final docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final bill = (data["billAmount"] ?? 0.0).toDouble();
                final tipPercent = (data["tipPercentage"] ?? 0.0).toDouble();
                final tip = (data["tipAmount"] ?? 0.0).toDouble();
                final total = (data["totalAmount"] ?? 0.0).toDouble();
                final timestamp = data["timestamp"] as Timestamp?;
                final time = timestamp != null
                    ? timestamp.toDate().toString()
                    : "No timestamp";

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.history),
                    title: Text("Bill: \$${bill.toStringAsFixed(2)}"),
                    subtitle: Text(
                      "Tip: ${tipPercent.toStringAsFixed(1)}% "
                      "(\$${tip.toStringAsFixed(2)})\n"
                      "Total: \$${total.toStringAsFixed(2)}",
                    ),
                    trailing: Text(time),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}