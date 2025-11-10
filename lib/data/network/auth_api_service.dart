abstract class AuthApiService {
  Future<dynamic> postOtp(dynamic params);

  Future<dynamic> postValidateOtp(dynamic params);

  Future<dynamic> postSignUp(dynamic params);

  Future<dynamic> postSignIn(dynamic params);

  Future<dynamic> postRefreshToken(dynamic params);
}
