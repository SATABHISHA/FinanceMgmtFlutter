import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
      try {
        // Make the POST API call
        final response = await http.post(
          Uri.parse('https://ourprojectapi.sroy.es/public/api/login'),
          body: {
            'name': _username,
            'password': _password,
          },
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);

          // Check the response status
          if (responseData['response']['status'] == true) {
            emit(LoginSuccess());
          } else {
            emit(LoginFailure(responseData['response']['message'] ?? 'Login failed'));
          }
        } else {
          emit(LoginFailure('Server error: ${response.statusCode}'));
        }
      } catch (e) {
        emit(LoginFailure('An error occurred: $e'));
      }
    });
  }
}