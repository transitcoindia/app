import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  final Razorpay _razorpay = Razorpay();

  void initializeRazorpay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> createOrderAndPay({
    required String name,
    required String email,
    required String phone,
    required double amount,
  }) async {
    try {
      var response = await http.post(
        Uri.parse("https://api.transitco.in/api/payments/create-order"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "amount": (amount * 100).toInt(), // Convert to paise
          "currency": "INR",
          "name": name,
          "email": email,
          "phoneNumber": phone,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        debugPrint("Order Created: $data");

        String orderId = data["id"];
        int finalAmount = data["amount"];
        String currency = data["currency"];

        var options = {
          "key":
              "rzp_test_c0XaxJ4rHrbx7m", // 🔴 Replace with your Razorpay Key ID
          "amount": finalAmount,
          "currency": currency,
          "name": "TransitCo",
          "order_id": orderId,
          "prefill": {
            "name": name,
            "email": email,
            "contact": phone,
          },
          "theme": {"color": "#3399cc"},
        };

        _razorpay.open(options);
      } else {
        debugPrint(
            "Failed Order Creation: ${response.statusCode} - ${response.body}");
        throw Exception("Failed to create order");
      }
    } catch (e) {
      debugPrint("Payment Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint("Payment Successful: ${response.paymentId}");
    await _verifyPayment(
      response.orderId!,
      response.paymentId!,
      response.signature!,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment Failed: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External Wallet Selected: ${response.walletName}");
  }

  Future<void> _verifyPayment(
      String orderId, String paymentId, String signature) async {
    try {
      var verifyResponse = await http.post(
        Uri.parse("https://api.transitco.in/api/payments/verify-payment"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "razorpay_order_id": orderId,
          "razorpay_payment_id": paymentId,
          "razorpay_signature": signature,
        }),
      );

      if (verifyResponse.statusCode == 200) {
        var verifyData = jsonDecode(verifyResponse.body);
        if (verifyData["status"] == "success") {
          debugPrint("Payment Verified Successfully ✅");
        } else {
          debugPrint("Payment Verification Failed ❌");
        }
      } else {
        debugPrint(
            "Verification Failed: ${verifyResponse.statusCode} - ${verifyResponse.body}");
      }
    } catch (e) {
      debugPrint("Error in Payment Verification: $e");
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}
