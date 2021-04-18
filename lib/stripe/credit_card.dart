import 'package:flutter/material.dart';
import 'package:flutter_firebase_authentication/mvc/state/stripe_store.dart';
import 'package:provider/provider.dart';

class UICreditCard extends StatelessWidget {

  cardExp(StripeStore stripeStore) {
    if (stripeStore.creditCard.expMonth.toString().length > 1) {
      return stripeStore.creditCard.expMonth.toString() + '/' + stripeStore.creditCard.expYear.toString();
    } else {
      return '0' + stripeStore.creditCard.expMonth.toString() + '/' + stripeStore.creditCard.expYear.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer <StripeStore>(
      builder: (context, stripeStore, _) {
        return Stack(
          children: [
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
            Container(
                alignment: Alignment.centerLeft,
                padding:   EdgeInsets.only(left: 16),
                height:    150,
                child: Icon(
                  Icons.credit_card,
                  size: 40,
                )
            ),
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
          ],
        );
      }
    );
  }
}
