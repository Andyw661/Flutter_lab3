import 'package:flutter_test/flutter_test.dart';
import '../lib/tip_model.dart';

void main() {
  test('Tip calculation should be correct', () {
    final model = TipModel();
    model.calculate(100.0, 15.0);

    expect(model.tipAmount, 15.0);
    expect(model.totalAmount, 115.0);
  });

  test('Zero bill should return zero values', () {
    final model = TipModel();
    model.calculate(0.0, 20.0);

    expect(model.tipAmount, 0.0);
    expect(model.totalAmount, 0.0);
  });

  test('Negative tip percent should return zero', () {
    final model = TipModel();
    model.calculate(100.0, -5.0);

    expect(model.tipAmount, 0.0);
    expect(model.totalAmount, 0.0);
  });
}
