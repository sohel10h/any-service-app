abstract class AuthApiService {
  Future<dynamic> sendOtp(dynamic params);

  Future<dynamic> validateOtp(dynamic params);

  Future<dynamic> signUp(dynamic params);

  Future<dynamic> signIn(dynamic params);

  Future<dynamic> refreshToken(dynamic params);
}
