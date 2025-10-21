abstract class AuthApiService {
  Future<dynamic> sendOtp(dynamic params);

  Future<dynamic> validateOtp(dynamic params);

  Future<dynamic> signup(dynamic params);
}
