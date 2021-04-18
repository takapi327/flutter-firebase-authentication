import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeStore extends ChangeNotifier {

  CreditCard creditCard = CreditCard();

  List<CreditCard> cardList = [];
  /*
  List<CreditCard> cardList = [
    CreditCard(
      brand:    'Visa',
      last4:    '1111',
      number:   '4111111111111111',
      expMonth: 11,
      expYear:  25,
      cvc:      '327'
    ),
    CreditCard(
      brand:    'MasterCard',
      last4:    '4444',
      number:   '5555555555554444',
      expMonth: 12,
      expYear:  25,
      cvc:      '327'
    ),
    CreditCard(
      brand:    'JCB',
      last4:    '0000',
      number:   '3530111333300000',
      expMonth: 11,
      expYear:  25,
      cvc:      '327'
    ),
  ];
   */

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
