import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter_firebase_authentication/mvc/state/stripe_store.dart';
import 'package:provider/provider.dart';

class SelectCard extends StatelessWidget {

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
                  print(stripeStore.cardList.length + 1);
                },
              )
            ],
          ),
        );
      }
    );
  }
}
