import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:flutter_firebase_authentication/error_dialog.dart';
import 'package:flutter_firebase_authentication/mvc/state/stripe_store.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import './credit_card.dart';
import './select_card.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_authentication/overlay_loading_molecules.dart';

class PaymentMethods extends StatelessWidget {

  void checkIfNativePayReady(BuildContext context) async {
    print('started to check if native pay ready');
    bool deviceSupportNativePay = await StripePayment.deviceSupportsNativePay();
    bool isNativeReady          = await StripePayment.canMakeNativePayPayments(
      ['american_express', 'visa', 'maestro', 'master_card']
    );
    deviceSupportNativePay && isNativeReady ? createPaymentMethodNative(context) : createPaymentMethod(context);
  }

  Future<void> createPaymentMethod(BuildContext context) async {

    //step 1: add card
    PaymentMethod paymentMethod = PaymentMethod();

    CreditCard _creditCard = CreditCard(
      number:   '',
      expMonth: 11,
      cvc:      ''
    );

    final PaymentMethodRequest _paymentMethodRequest = PaymentMethodRequest(
      card: _creditCard
    );

    paymentMethod = await StripePayment.createPaymentMethod(_paymentMethodRequest);

    paymentMethod != null
    //? processPaymentAsDirectCharge(paymentMethod)
        ? print('Success:' + paymentMethod.id)
        : showDialog(
        context: context,
        builder: (BuildContext context) => ErrorDialog(
          title:      'Error',
          content:    'It is not possible to pay with this card. Please try again with a different card',
          buttonText: 'CLOSE'
        )
    );
  }

  Future<CreditCard> createPaymentMethodNative(BuildContext context) async {
    print('started NATIVE payment...');

    //step 1: add card
    PaymentMethod paymentMethod = PaymentMethod();

    void setError(dynamic error) {
      ErrorDialog(
        title:      'Error',
        content:    'It is not possible to pay with this card. Please try again with a different card',
        buttonText: 'CLOSE'
      );
    }

    paymentMethod = await StripePayment.paymentRequestWithCardForm(
      CardFormPaymentRequest(),
    ).catchError(setError);

    return paymentMethod.card;
  }

  Future<void> getCustomerCard(BuildContext context, StripeStore stripeStore) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null && stripeStore.cardList.length == 0) {
      final url = Uri.http('localhost:9000', '/api/stripe/card/customer/$userId');
      OverlayLoadingMolecules(visible: true);
      http.Response resp = await http.get(url);
      if (resp.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(resp.body);
        List<CreditCard> cardList = [];
        for (var card in jsonResponse['cardList']) {
          cardList.add(CreditCard(
            brand:    card['brand'],
            expMonth: int.parse(card['exp_month']),
            expYear:  int.parse(card['exp_year']),
            last4:    card['last4']
          ));
        }
        stripeStore.setCard(cardList.first);
        stripeStore.setCardList(cardList);
        OverlayLoadingMolecules(visible: false);
      } else {
        ErrorDialog(
          title:      'Error',
          content:    'It is not possible to pay with this card. Please try again with a different card',
          buttonText: 'CLOSE'
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: 'pk_test_51IZrtWJd0VKBQGZhjcHLHLyzjVnt850eXPu9GGgyVKgeC0D6QPY30KkaLWtgXcVstMHrUkXYsElC7UdCDzxeihbj00vnFMsF5c'
      )
    );

    return Consumer <StripeStore>(
      builder: (context, stripeStore, _) {
        getCustomerCard(context, stripeStore);
        return GestureDetector(
          onTap: () async {
            if (stripeStore.creditCard.last4 == null) {
              final card = await createPaymentMethodNative(context);
              stripeStore.setCard(card);
              stripeStore.addCardList(card);
            } else {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return SelectCard();
                },
                fullscreenDialog: true
              ));
            }
          },
          child: stripeStore.creditCard.last4 == null
            ? Container(
                height:     50,
                alignment:  Alignment.center,
                child:      Text("カード登録", style: TextStyle(fontSize: 16)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topLeft,
                    end:   FractionalOffset.bottomRight,
                    colors: const [
                      Color(0xffffffff),
                      Color(0xffe6e6e6),
                    ]
                  ),
                  border:       Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            : UICreditCard()
        );
      }
    );
  }
}
