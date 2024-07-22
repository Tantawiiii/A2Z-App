import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/password_reset_service.dart';
import 'password_reset_event.dart';
import 'password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  final PasswordResetService _passwordResetService;

  PasswordResetBloc(this._passwordResetService) : super(PasswordResetInitial()) {
    on<PasswordResetRequested>(_onPasswordResetRequested);
  }

  Future<void> _onPasswordResetRequested(
      PasswordResetRequested event, Emitter<PasswordResetState> emit) async {
    emit(PasswordResetLoading());
    try {
      final result = await _passwordResetService.sendPasswordResetRequest(event.loginOrEmail);

      if (result['succeeded']) {
        emit(PasswordResetSuccess());
      } else {
        emit(PasswordResetFailure(result['error']));
      }
    } catch (e) {
      emit(PasswordResetFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
