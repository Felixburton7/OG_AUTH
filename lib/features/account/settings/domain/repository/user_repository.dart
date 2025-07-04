abstract class UserRepository {
  Future<void> changeEmailAddress(String newEmailAddress);
  Future<void> resetPassword(String email);
  Future<void> updatePassword(String password);
  Future<void> updateForgotPassword(String password, String token);
}
