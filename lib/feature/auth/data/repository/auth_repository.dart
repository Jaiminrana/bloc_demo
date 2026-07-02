import 'package:self/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:self/feature/auth/data/models/login_request_model.dart';
import 'package:self/feature/auth/data/models/user_model.dart';

abstract interface class AuthRepository {
  Future<UserModel> login(LoginRequestModel request);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserModel> login(LoginRequestModel request) async {
    return await remoteDataSource.login(request);
  }
}
