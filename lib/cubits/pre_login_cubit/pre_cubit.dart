import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreLoginCubit extends Cubit<int> {
  Timer? _timer;

  PreLoginCubit() : super(0) {
    _startAutoRotation();
  }

  void _startAutoRotation() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      nextImage();
    });
  }

  void nextImage() {
    emit((state + 1) % 3); // Rotates through 0, 1, 2
  }

  @override
  Future<void> close() {
    _timer?.cancel(); // Cancel the timer when the Cubit is closed
    return super.close();
  }
}
