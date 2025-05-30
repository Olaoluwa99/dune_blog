import 'package:dune_blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:dune_blog/core/network/connection_checker.dart';
import 'package:dune_blog/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dune_blog/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:dune_blog/feature/auth/domain/repository/auth_repository.dart';
import 'package:dune_blog/feature/auth/domain/usecases/current_user.dart';
import 'package:dune_blog/feature/auth/domain/usecases/user_login.dart';
import 'package:dune_blog/feature/auth/domain/usecases/user_sign_up.dart';
import 'package:dune_blog/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:dune_blog/feature/blog/data/dataSources/blog_local_data_source.dart';
import 'package:dune_blog/feature/blog/data/dataSources/blog_remote_data_source.dart';
import 'package:dune_blog/feature/blog/data/repositories/blog_repository_impl.dart';
import 'package:dune_blog/feature/blog/domain/repositories/blog_repository.dart';
import 'package:dune_blog/feature/blog/domain/useCases/get_all_blogs.dart';
import 'package:dune_blog/feature/blog/domain/useCases/upload_blog.dart';
import 'package:dune_blog/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/secrets/app_secrets.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  final appDocsDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocsDir.path);

  final blogBox = await Hive.openBox('blogs');

  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => blogBox);
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory(() => BlogLocalDataSourceImpl(serviceLocator()))
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    //DataSource
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(serviceLocator()),
    ) //Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    ) //UseCases
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    //Bloc
    ..registerLazySingleton(
      () =>
          BlogBloc(uploadBlog: serviceLocator(), getAllBlogs: serviceLocator()),
    );
}
