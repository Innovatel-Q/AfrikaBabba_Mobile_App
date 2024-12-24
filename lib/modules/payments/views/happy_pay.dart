import 'dart:convert';
import 'dart:developer';
import 'package:afrika_baba/modules/orders/cart/views/payment_confirmation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../shared/themes/chart_color.dart';
import '../../../shared/widgets/buttons/CustomButton.dart';
import '../../orders/order/controllers/order_controller.dart';

class HappyPaymentsScreen extends StatefulWidget {
  double? amount;
  String? orderId;

  HappyPaymentsScreen({Key? key, this.amount = 0.0, this.orderId = ''})
      : super(key: key);

  @override
  _HappyPaymentsScreenState createState() => _HappyPaymentsScreenState();
}

class _HappyPaymentsScreenState extends State<HappyPaymentsScreen> {
  String responseData = '';

  bool showVerification = false;

  WebViewController _webViewController = WebViewController();
  final orderController = Get.find<OrderController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    happyPay();
  }

  happyPay() {
    String result = widget.amount!.toStringAsFixed(0);
    final Uri uri = Uri.dataFromString(
      '''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <title>HappyPay Payment</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
        }
        form {
            width: 100%;
            max-width: 400px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            padding: 20px;
            background: white;
            border-radius: 8px;
        }
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
    <form id="paymentForm" action="https://happypay-dev.com/api/happy-pay/payment/init" method="post">
        <input type="hidden" name="amount" value="20">
        <input type="hidden" name="reference" value="${widget.orderId}">
        <input type="hidden" name="callbackUrl" value="https://afrikababaa-571dedf1e98c.herokuapp.com/api/happyPay">
        <button id="submitButton" type="submit" style="width: 100%; padding: 10px; font-size: 16px; background: green; color: white; border: none; border-radius: 4px;">Submit</button>
    </form>
    <script>
        window.onload = function() {
            // Automatically submit the form
            const form = document.getElementById('paymentForm');
            const button = document.getElementById('submitButton');

            // Hide the button before submitting the form
            button.classList.add('hidden');

            form.submit();
        };
    </script>
</body>
</html>''',
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    );
    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            log(error.description);
          },
          onPageStarted: (value) {
            log("page started" + value.toString());
          },
          onHttpError: (error) {
            log("on http error" + error.toString());
          },
          onProgress: (value) {
            log("on progress" + value.toString());
          },
          onUrlChange: (value) {
            log("on url change" + value.url.toString());
            if (value.url.toString() ==
                'https://happypay-dev.com/api/happy-pay/payment/validate') {
              setState(() {
                showVerification = true;
              });
            }
          },
          onPageFinished: (page) {},
        ),
      )
      ..loadRequest(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: showVerification
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: const Text(
                      'Nous avons envoyé un SMS à votre numéro de paiement. Veuillez effectuer un paiement en utilisant le lien, puis appuyez sur Vérifier.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: CustomButton(
                      text: "Vérifier le paiement",
                      onPressed: () {
                        fetchTransactionStatus(widget.orderId.toString());
                      },
                      color: btnColorFourth,
                      elevation: 0,
                    ),
                  )
                ],
              )
            : buildBody(),
      ),
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: WebViewWidget(
          controller: _webViewController,
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(CupertinoIcons.arrow_left, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: const Text(
        "Happy Pay",
        style: TextStyle(fontSize: 16, color: Colors.green),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  void fetchTransactionStatus(String orderId) async {
    final String url =
        'https://happypay-dev.com/api/happy-pay/v1/transactions/status/$orderId';
    final String token =
        'd47cf6fc-3855-4875-b685-d73e127f54f2'; // Replace with your actual token

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': '*/*',
          'x-api-key': token,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'PROCESSED') {
          orderController.createOrder();
          Get.to(const PaymentConfirmationScreen());
        } else {
          Get.snackbar('Statut', 'Paiement ${data['status']}',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else if (response.statusCode == 500) {
        Get.snackbar('Erreur',
            'Paiement pas encore effectué, réessayez s\'il vous plaît.',
            backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        Get.snackbar('Échec du paiement', 'Veuillez vérifier votre transaction',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur du serveur Réessayez plus tard',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
