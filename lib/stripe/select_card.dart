import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter_firebase_authentication/error_dialog.dart';
import 'package:flutter_firebase_authentication/mvc/state/stripe_store.dart';
import 'package:provider/provider.dart';

class SelectCard extends StatelessWidget {

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

  @override
  Widget build(BuildContext context) {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: 'pk_test_51IZrtWJd0VKBQGZhjcHLHLyzjVnt850eXPu9GGgyVKgeC0D6QPY30KkaLWtgXcVstMHrUkXYsElC7UdCDzxeihbj00vnFMsF5c'
      )
    );

    return Consumer <StripeStore>(
      builder: (context, stripeStore, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('カード選択'),
          ),
          body: Column(
            children: [
              for (var card in stripeStore.cardList)
                RadioListTile(
                  title:      Text('**** **** **** ' + card.last4.toString()),
                  value:      card,
                  groupValue: stripeStore.creditCard,
                  onChanged:  (_) => {
                    stripeStore.setCard(card)
                    //stripeStore.selectedCard(value),
                  }
                ),
              ElevatedButton(
                child:     Text('カードを追加'),
                onPressed: () async {
                  final card = await createPaymentMethodNative(context);
                  stripeStore.setCard(card);
                  stripeStore.addCardList(card);
                  //print(stripeStore.cardList.length + 1);
                },
              )
            ],
          ),
        );
      }
    );
  }
}
