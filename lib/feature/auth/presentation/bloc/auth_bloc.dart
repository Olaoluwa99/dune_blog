import 'package:dune_blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:dune_blog/core/usecases/usecase.dart';
import 'package:dune_blog/feature/auth/domain/usecases/current_user.dart';
import 'package:dune_blog/feature/auth/domain/usecases/user_login.dart';
import 'package:dune_blog/feature/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/common/entities/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  }) : _userSignUp = userSignUp,
       _userLogin = userLogin,
       _currentUser = currentUser,
       _appUserCubit = appUserCubit,
       super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _currentUser(NoParams());
    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final response = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final response = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );

    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emitAuthSuccess(user, emit),
    );
  }

  void emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
