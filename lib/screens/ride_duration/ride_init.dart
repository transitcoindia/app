import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:transit/bloc/ride_bloc/ride_bloc.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/screens/map/map_widget.dart';

class RideInitiatedOTP extends StatelessWidget {
  const RideInitiatedOTP({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RideBloc(),
      child: const RideFlowView(),
    );
  }
}

class RideFlowView extends StatefulWidget {
  const RideFlowView({super.key});

  @override
  State<RideFlowView> createState() => _RideFlowViewState();
}

class _RideFlowViewState extends State<RideFlowView> {
  bool isSwiped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Ride Details', style: TextStyle(color: white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<RideBloc, RideState>(
        builder: (context, state) {
          if (state is RideInitialOTPState) {
            return _rideDetails(context, "Your OTP Code:", otpCode: "3487");
          } else if (state is RideStartedState) {
            return _rideDetails(context, "Ride Started", showProgressBar: true);
          } else if (state is RideFinishedState) {
            return _rideDetails(
              context,
              "Ride Finished",
              showSwipeToPay: true,
              price: "₹44",
            );
          } else if (state is RidePaymentState) {
            return _showReviewPopup(context);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // Reusable Ride Details UI
  Widget _rideDetails(
    BuildContext context,
    String title, {
    String otpCode = '',
    bool showProgressBar = false,
    bool showSwipeToPay = false,
    String price = '',
  }) {
    const String driverName = "John Doe";
    const String vehicleType = "Sedan";
    const String phoneNumber = "+91 9876543210";
    const String vehiclePlate = "MH 12 AB 1234";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Map Placeholder
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: MapScreen(),
            ),
          ),
          const SizedBox(height: 16),

          // Driver and Vehicle Details
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Driver: $driverName',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Vehicle: $vehicleType',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.black),
                  SizedBox(width: 8),
                  Text(phoneNumber),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.directions_car, color: Colors.black),
                  SizedBox(width: 8),
                  Text(vehiclePlate),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Title: OTP Code, Ride Started, or Ride Finished
          Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // OTP Boxes (if OTP code is provided)
          if (otpCode.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: otpCode.split('').map((digit) {
                return Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(digit,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                );
              }).toList(),
            ),
          ],

          // Progress Bar for Ride Started
          if (showProgressBar) ...[
            const SizedBox(height: 24),
            LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 32,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 10000,
              percent: 1.0,
              backgroundColor: Colors.grey.shade300,
              progressColor: Colors.green,
            ),
          ],

          // Swipe to Pay and Price
          if (showSwipeToPay) ...[
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Total: $price',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                "Swipe to Pay",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: SwipeableButtonView(
                buttonText: '',
                buttonColor: Colors.green,
                onWaitingProcess: () {
                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      isSwiped = true;
                    });
                  });
                },
                isFinished: isSwiped,
                onFinish: () {
                  context.read<RideBloc>().add(SwipeToPayEvent());
                },
                activeColor: Colors.white,
                buttonWidget: Container(),
              ),
            ),
          ],
          const Spacer(),

          // Confirm OTP Button (only for OTP state)
          if (otpCode.isNotEmpty)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<RideBloc>().add(OTPConfirmedEvent());
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Confirm OTP', style: TextStyle(color: white),),
              ),
            ),
        ],
      ),
    );
  }

  // Review Popup
  Widget _showReviewPopup(BuildContext context) {
    Future.microtask(() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Leave a Review?'),
          content: const Text('Would you like to leave a review for this ride?',style: TextStyle(color: black),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/home'); // Redirect to home
              },
              child: const Text('Review Later'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/home'); // Redirect to home
              },
              child: const Text('Yes, Review'),
            ),
          ],
        ),
      );
    });
    return const SizedBox.shrink();
  }
}
