import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class RideBloc extends Bloc<RideEvent, RideState> {
  RideBloc() : super(RideInitialOTPState()) {
    // Toggle ride collapsed/expanded
    on<ToggleRideExpansionEvent>((event, emit) {
      if (state is RideCollapsedState) {
        emit(RideExpandedState());
      } else {
        emit(RideCollapsedState());
      }
    });

    // OTP Confirmed: Transition to Ride Started
    on<OTPConfirmedEvent>((event, emit) async {
      emit(RideStartedState());
      await Future.delayed(const Duration(seconds: 10)); // Simulate ETA
      emit(RideFinishedState());
    });

    // Swipe to Pay: Transition to Payment State
    on<SwipeToPayEvent>((event, emit) {
      emit(RidePaymentState());
    });

    // Payment Completed: Final Ride Completed State
    on<CompletePaymentEvent>((event, emit) {
      emit(RideCompletedState());
    });
  }
}

// Events
abstract class RideEvent extends Equatable {
  const RideEvent();

  @override
  List<Object> get props => [];
}

class ToggleRideExpansionEvent extends RideEvent {}
class OTPConfirmedEvent extends RideEvent {}
class SwipeToPayEvent extends RideEvent {}
class CompletePaymentEvent extends RideEvent {}

// States
abstract class RideState extends Equatable {
  const RideState();

  @override
  List<Object> get props => [];
}

class RideInitialOTPState extends RideState {}
class RideCollapsedState extends RideState {}
class RideExpandedState extends RideState {}
class RideStartedState extends RideState {}
class RideFinishedState extends RideState {}
class RidePaymentState extends RideState {}
class RideCompletedState extends RideState {}
