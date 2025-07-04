class Failure {
  final String message;
  Failure([this.message = 'An unexpected error occurred.']);

  // Factory constructor for authentication failures
  factory Failure.authFailure() {
    return Failure('Incorrect email or password. Please try again.');
  }

  // Factory constructor for server failures
  factory Failure.serverFailure() {
    return Failure('An unexpected error occurred. Please try again later.');
  }

  // Factory constructor for other types of failures (if needed)
  factory Failure.genericFailure(
      [String message = 'An unexpected error occurred.']) {
    return Failure(message);
  }
}
