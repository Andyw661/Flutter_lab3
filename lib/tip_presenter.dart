import 'package:cloud_firestore/cloud_firestore.dart';
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

  FirebaseFirestore.instance.collection('tipHistory').add({
    'billAmount': billAmount,
    'tipPercentage': tipPercentage,
    'tipAmount': _model.tipAmount,
    'totalAmount': _model.totalAmount,
    'timestamp': FieldValue.serverTimestamp(),
  });
}

}
