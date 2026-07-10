import 'package:self/core/network/api_client.dart';
import 'package:self/feature/user_profile/data/models/user_profile_model.dart';

abstract interface class UserProfileRemoteDataSource {
  Future<UserProfileModel> fetchUser(int userId);

  Future<UserProfileModel> updateUser(UserProfileModel updatedUser);
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final ApiClient _apiClient;

  const UserProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserProfileModel> fetchUser(int userId) async {
    final response = await _apiClient.get('/users/$userId');

    return UserProfileModel.fromJson(response.data);
  }

  @override
  Future<UserProfileModel> updateUser(UserProfileModel updatedUser) async {
    final response = await _apiClient.put(
      '/users/${updatedUser.id}',
      data: updatedUser.toJson(),
    );

    return UserProfileModel.fromJson(response.data);
  }
}
