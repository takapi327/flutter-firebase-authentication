import 'package:flutter/material.dart';
import 'package:flutter_firebase_authentication/error_dialog.dart';
import 'package:flutter_firebase_authentication/mvc/state/stripe_store.dart';
import 'package:provider/provider.dart';

import 'package:stripe_payment/stripe_payment.dart';

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

  cardExp(StripeStore stripeStore) {
    if (stripeStore.creditCard.expMonth.toString().length > 1) {
      return stripeStore.creditCard.expMonth.toString() + '/' + stripeStore.creditCard.expYear.toString();
    } else {
      return '0' + stripeStore.creditCard.expMonth.toString() + '/' + stripeStore.creditCard.expYear.toString();
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
        return GestureDetector(
          onTap: () async {
            final card = await createPaymentMethodNative(context);
            stripeStore.setCard(card);
          },
          child: Stack(
            children: [
              if (stripeStore.creditCard.brand != null)
                Container(
                  height:  150,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: FractionalOffset.topLeft,
                          end:   FractionalOffset.bottomRight,
                          colors: const [
                            Color(0xffffffff),
                            Color(0xffe6e6e6),
                          ]
                      ),
                      //color:        Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow:    [
                        BoxShadow(
                          color:        Colors.black26,
                          spreadRadius: 1.0,
                          blurRadius:   10.0,
                          offset:       Offset(10, 10),
                        )
                      ]
                  ),
                ),
              if (stripeStore.creditCard.brand != null)
                Container(
                  alignment: Alignment.topRight,
                  height:    150,
                  padding:   EdgeInsets.all(8),
                  child: Text(
                    stripeStore.creditCard.brand.toUpperCase(),
                    style: TextStyle(
                        fontSize:   24,
                        fontStyle:  FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color:      Colors.blue
                    ),
                  ),
                ),

              if (stripeStore.creditCard.brand != null)
                Container(
                    alignment: Alignment.centerLeft,
                    padding:   EdgeInsets.only(left: 16),
                    height:    150,
                    child: Icon(
                      Icons.credit_card,
                      size: 40,
                    )
                ),

              if (stripeStore.creditCard.last4 != null)
                Container(
                  alignment: Alignment.centerRight,
                  padding:   EdgeInsets.only(right: 32),
                  height:    150,
                  child: Text(
                    '**** **** **** ' + stripeStore.creditCard.last4.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        color:    Colors.black
                    ),
                  ),
                ),
              if (stripeStore.creditCard.expMonth != null)
                Container(
                  alignment: Alignment.bottomRight,
                  height:    150,
                  padding:   EdgeInsets.all(8),
                  child: Text(
                    cardExp(stripeStore),
                    style: TextStyle(
                        fontSize: 16,
                        color:    Colors.black
                    ),
                  ),
                ),

              if (stripeStore.creditCard.last4 == null)
                Container(
                  height:  50,
                  alignment: Alignment.center,
                  child:   Text("カード登録", style: TextStyle(fontSize: 16)),
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
                ),
            ],
          ),
        );
      }
    );
  }
}
