import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;

class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});
}

class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());

      final users = await _loadMockUsers();
      final user = users.firstWhere(
            (user) => user['email'] == event.email && user['password'] == event.password,
        orElse: () => null,
      );

      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        emit(LoginSuccess());
      } else {
        emit(LoginFailure());
      }
    });
  }

  Future<List<dynamic>> _loadMockUsers() async {
    final jsonString = await rootBundle.loadString('assets/mock_users.json');
    return json.decode(jsonString) as List<dynamic>;
  }
}
