import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeStore extends ChangeNotifier {

  CreditCard creditCard = CreditCard();

  void setCard(CreditCard card) {
    creditCard = card;
    notifyListeners();
  }
}
