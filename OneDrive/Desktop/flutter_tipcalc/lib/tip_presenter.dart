import 'tip_model.dart';
import 'tip_contract.dart';

class TipPresenter implements TipContract_Presenter {
  final TipContract_View _view;
  final TipModel _model = TipModel();

  TipPresenter(this._view);

  @override
  void calculateTip(double billAmount, double tipPercentage) {
    _model.calculate(billAmount, tipPercentage);
    _view.updateTip(_model.tipAmount, _model.totalAmount);
  }
}
