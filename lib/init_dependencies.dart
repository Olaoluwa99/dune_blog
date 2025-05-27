import 'package:dune_blog/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dune_blog/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:dune_blog/feature/auth/domain/repository/auth_repository.dart';
import 'package:dune_blog/feature/auth/domain/usecases/user_login.dart';
import 'package:dune_blog/feature/auth/domain/usecases/user_sign_up.dart';
import 'package:dune_blog/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/secrets/app_secrets.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocator()),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator()),
  );

  serviceLocator.registerFactory(() => UserSignUp(serviceLocator()));

  serviceLocator.registerFactory(() => UserLogin(serviceLocator()));

  serviceLocator.registerLazySingleton(
    () => AuthBloc(userSignUp: serviceLocator(), userLogin: serviceLocator()),
  );
}
