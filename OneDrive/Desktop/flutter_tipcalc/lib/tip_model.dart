// The "Model" - pure Dart logic (no Flutter dependencies)

class TipModel {
  double _tipAmount = 0.0;
  double _totalAmount = 0.0;

  double get tipAmount => _tipAmount;
  double get totalAmount => _totalAmount;

  void calculate(double billAmount, double tipPercentage) {
    if (billAmount > 0 && tipPercentage >= 0) {
      _tipAmount = billAmount * (tipPercentage / 100.0);
      _totalAmount = billAmount + _tipAmount;
    } else {
      _tipAmount = 0.0;
      _totalAmount = 0.0;
    }
  }
}
