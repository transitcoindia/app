import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:dio/dio.dart';

class UserModel {
  final String name;
  final String email;
  final String phone;

  UserModel({required this.name, required this.email, required this.phone});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class UserRepository {
  static const String _baseUrl = 'https://transit-be.vercel.app/api/user/details';

  Future<UserModel> fetchUser(String userId) async {
    final response = await http.get(Uri.parse('$_baseUrl?userId=$userId'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return UserModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load user');
    }
  }
}

class RazorpayPaymentPage extends StatefulWidget {
  final String userId;

  RazorpayPaymentPage({required this.userId});

  @override
  _RazorpayPaymentPageState createState() => _RazorpayPaymentPageState();
}

class _RazorpayPaymentPageState extends State<RazorpayPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  late Razorpay _razorpay;
  bool isProcessing = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      UserModel user = await UserRepository().fetchUser(widget.userId);
      setState(() {
        _nameController.text = user.name;
        _emailController.text = user.email;
        _phoneController.text = user.phone;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch user details")),
      );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      var verifyResponse = await Dio().post(
        "https://transit-be.vercel.app/api/payments/verify-payment",
        data: {
          "razorpay_order_id": response.orderId,
          "razorpay_payment_id": response.paymentId,
          "razorpay_signature": response.signature,
        },
      );

      if (verifyResponse.data["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Successful!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Verification Failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Verification Error")),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}")),
    );
  }

  Future<void> _initiatePayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isProcessing = true);

    try {
      var orderResponse = await Dio().post(
        "https://transit-be.vercel.appapi/payments/create-order",
        data: {
          "name": _nameController.text,
          "email": _emailController.text,
          "phoneNumber": _phoneController.text,
          "amount": _amountController.text,
        },
      );

      var orderData = orderResponse.data;
      var options = {
        //razorpay key id
        "key": "YOUR_RAZORPAY_KEY_ID",
        "amount": orderData["amount"],
        "currency": orderData["currency"],
        "name": "Your Company Name",
        "description": "Test Transaction",
        "order_id": orderData["id"],
        "prefill": {
          "name": _nameController.text,
          "email": _emailController.text,
          "contact": _phoneController.text,
        },
        "theme": {"color": "#3399cc"}
      };

      _razorpay.open(options);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to initiate payment")),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Razorpay Payment")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: "Name"),
                      validator: (value) =>
                          value!.isEmpty ? "Name is required" : null,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: "Email"),
                      validator: (value) {
                        if (value!.isEmpty) return "Email is required";
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: "Phone Number"),
                      validator: (value) {
                        if (value!.isEmpty) return "Phone number is required";
                        if (value.length < 10 || value.length > 15) {
                          return "Enter a valid phone number";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                    ),
                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(labelText: "Amount"),
                      validator: (value) {
                        if (value!.isEmpty) return "Amount is required";
                        if (double.tryParse(value) == null ||
                            double.parse(value) <= 0) {
                          return "Enter a valid amount";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isProcessing ? null : _initiatePayment,
                      child: Text(isProcessing ? "Processing..." : "Pay Now"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
