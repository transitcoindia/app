import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit/bloc/user_specific/user_bloc.dart/user_states.dart';
import 'package:transit/repository/user_repo.dart';
import 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await userRepository.fetchUser(event.userId);
      log("User loaded");
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
