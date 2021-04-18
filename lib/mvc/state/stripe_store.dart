import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeStore extends ChangeNotifier {

  CreditCard creditCard = CreditCard();

  List<CreditCard> cardList = [];

  void setCard(CreditCard card) {
    creditCard = card;
    notifyListeners();
  }

  void setCardList(List<CreditCard> cards) {
    cardList = cards;
    notifyListeners();
  }

  void addCardList(CreditCard card) {
    cardList.add(card);
    notifyListeners();
  }
}
