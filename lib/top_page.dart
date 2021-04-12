import 'package:flutter/material.dart';
import 'package:flutter_firebase_authentication/error_dialog.dart';
import 'package:provider/provider.dart';

import 'package:stripe_payment/stripe_payment.dart';

import 'package:flutter_firebase_authentication/mvc/state/auth_store.dart';

class TopPage extends StatelessWidget {

  String text        = 'Click the button to start the payment';
  double totalCost   = 10.0;
  double tip         = 1.0;
  double tax         = 0.0;
  double taxPercent  = 0.2;
  int    amount      = 0;
  bool   showSpinner = false;
  String url         = 'https://us-central1-demostripe-b9557.cloudfunctions.net/StripePI';


  void checkIfNativePayReady(BuildContext context) async {
    print('started to check if native pay ready');
    bool deviceSupportNativePay = await StripePayment.deviceSupportsNativePay();
    bool isNativeReady          = await StripePayment.canMakeNativePayPayments(
      ['american_express', 'visa', 'maestro', 'master_card']
    );
    deviceSupportNativePay && isNativeReady ? createPaymentMethodNative(context) : createPaymentMethod(context);
  }

  Future<void> createPaymentMethod(BuildContext context) async {
    tax    = ((totalCost * taxPercent) * 100).ceil() / 100;
    amount = ((totalCost + tip + tax) * 100).toInt();

    print('amount in pence/cent which will be charged = $amount');

    //step 1: add card
    PaymentMethod paymentMethod = PaymentMethod();
    Card card = Card();

    paymentMethod = await StripePayment.paymentRequestWithCardForm(
      CardFormPaymentRequest(),
    ).then((PaymentMethod paymentMethod) {
      print('--------');
      print(paymentMethod);
      print('--------');
      return paymentMethod;
    }).catchError((e) {
      print('Error Card: ${e.toString()}');
    });

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

  Future<void> createPaymentMethodNative(BuildContext context) async {
    print('started NATIVE payment...');
    print(PaymentMethod().id);
    List<ApplePayItem> items = [];
    items.add(ApplePayItem(
      label: 'Demo Order',
      amount: totalCost.toString(),
    ));
    if (tip != 0.0)
      items.add(ApplePayItem(
        label: 'Tip',
        amount: tip.toString(),
      ));
    if (taxPercent != 0.0) {
      tax = ((totalCost * taxPercent) * 100).ceil() / 100;
      items.add(ApplePayItem(
        label: 'Tax',
        amount: tax.toString(),
      ));
    }
    items.add(ApplePayItem(
      label: 'Vendor A',
      amount: (totalCost + tip + tax).toString(),
    ));
    amount = ((totalCost + tip + tax) * 100).toInt();
    print('amount in pence/cent which will be charged = $amount');
    //step 1: add card
    PaymentMethod paymentMethod = PaymentMethod();
    Token token = await StripePayment.paymentRequestWithNativePay(
      androidPayOptions: AndroidPayPaymentRequest(
        totalPrice: (totalCost + tax + tip).toStringAsFixed(2),
        currencyCode: 'GBP',
      ),
      applePayOptions: ApplePayPaymentOptions(
        countryCode: 'GB',
        currencyCode: 'GBP',
        items: items,
      ),
    );

    print('-----------');
    print(CreditCard(token: token.tokenId));
    print('-----------');

    paymentMethod = await StripePayment.createPaymentMethod(
      PaymentMethodRequest(
        card: CreditCard(
          token: token.tokenId,
        ),
      ),
    );
    paymentMethod != null
        ? print('Success:' + paymentMethod.id) //processPaymentAsDirectCharge(paymentMethod)
        : showDialog(
        context: context,
        builder: (BuildContext context) => ErrorDialog(
          title:      'Error',
          content:    'It is not possible to pay with this card. Please try again with a different card',
          buttonText: 'CLOSE'
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: 'pk_test_51IZrtWJd0VKBQGZhjcHLHLyzjVnt850eXPu9GGgyVKgeC0D6QPY30KkaLWtgXcVstMHrUkXYsElC7UdCDzxeihbj00vnFMsF5c',
        merchantId:     'Test',
        androidPayMode: 'test'
      )
    );
    StripePayment.setStripeAccount(null);

    return Consumer <AuthStore>(
      builder: (context, authStore, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('トップページ'),
            actions: [
              if (authStore.currentUser != null)
                IconButton(
                    icon:      Icon(Icons.account_circle_sharp),
                    onPressed: () {
                      Navigator.pushNamed(context, '/mypage');
                    }
                ),

              if (authStore.currentUser == null)
                IconButton(
                    icon:      Icon(Icons.login),
                    onPressed: () {
                      Navigator.pushNamed(context, '/auth');
                    }
                ),
            ],
          ),
          body: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      if (authStore.currentUser != null)
                        Text(authStore.currentUser.toString()),
                      if (authStore.currentUser == null)
                        Text("未ログイン"),

                      ElevatedButton(
                        child: Text("カード登録", style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          //createPaymentMethod(context);
                          checkIfNativePayReady(context);
                        },
                      ),
                      SizedBox(height: 16),
                      Text(text),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

  }
}
