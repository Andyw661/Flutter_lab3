abstract class TipContract_View {
  void updateTip(double tipAmount, double totalAmount);
}

abstract class TipContract_Presenter {
  void calculateTip(double billAmount, double tipPercentage);
}
