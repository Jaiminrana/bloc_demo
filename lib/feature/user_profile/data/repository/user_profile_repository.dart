import 'package:self/core/errors/network_executor.dart';
import 'package:self/feature/user_profile/data/data_source/user_profile_remote_data_source.dart';
import 'package:self/feature/user_profile/data/models/user_profile_model.dart';

abstract interface class UserProfileRepository {
  Future<UserProfileModel> fetchUser(int userId);

  Future<UserProfileModel> updateUser(UserProfileModel updateUser);
}

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource _remoteDataSource;

  const UserProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserProfileModel> fetchUser(int userId) async {
    final userProfile = await NetworkExecutor.execute(
      () => _remoteDataSource.fetchUser(userId),
    );
    return userProfile;
  }

  @override
  Future<UserProfileModel> updateUser(UserProfileModel updateUser) async {
    final updateUserProfile = await NetworkExecutor.execute(
      () => _remoteDataSource.updateUser(updateUser),
    );
    return updateUserProfile;
  }
}
