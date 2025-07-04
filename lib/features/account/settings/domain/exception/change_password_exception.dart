class ResetPasswordException implements Exception {
  const ResetPasswordException({
    this.message = 'An unknown exception occurred.',
  });

  final String message;
}
