import 'package:booknex_partner/features/partner_onboarding/model/terms_model.dart';
import 'package:flutter/material.dart';

class TermsViewModel extends ChangeNotifier {
  final TermsModel _model = TermsModel();

  bool get isAccepted => _model.isAccepted;
  String get title => _model.declarationTitle;
  List<String> get terms => _model.termsSummary;

  void toggleAcceptance(bool? value) {
    _model.isAccepted = value ?? false;
    notifyListeners();
  }
}
