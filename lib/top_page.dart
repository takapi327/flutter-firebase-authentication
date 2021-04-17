import 'package:flutter/material.dart';
import 'package:flutter_firebase_authentication/error_dialog.dart';
import 'package:provider/provider.dart';

import 'package:stripe_payment/stripe_payment.dart';

import 'package:flutter_firebase_authentication/mvc/state/auth_store.dart';

class TopPage extends StatelessWidget {

  String text = 'Click the button to start the payment';

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

  Future<void> createPaymentMethodNative(BuildContext context) async {
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
        publishableKey: 'pk_test_51IZrtWJd0VKBQGZhjcHLHLyzjVnt850eXPu9GGgyVKgeC0D6QPY30KkaLWtgXcVstMHrUkXYsElC7UdCDzxeihbj00vnFMsF5c'
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
                      SizedBox(height: 16),
                      ElevatedButton(
                        child: Text("カード登録", style: TextStyle(fontSize: 20)),
                        onPressed: () {
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
