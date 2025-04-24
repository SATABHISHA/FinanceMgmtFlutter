import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  String _username = '';
  String _password = '';

  LoginBloc() : super(LoginInitial()) {
    on<LoginUsernameChanged>((event, emit) {
      _username = event.username;
    });

    on<LoginPasswordChanged>((event, emit) {
      _password = event.password;
    });

    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      if (_username == 'admin' && _password == 'password') {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure('Invalid username or password'));
      }
    });
  }
}