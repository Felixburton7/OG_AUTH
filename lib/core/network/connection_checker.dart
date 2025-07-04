import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:injectable/injectable.dart';

// Define a module to provide dependencies
@module
abstract class InternetConnectionCheckerModule {
  // Register InternetConnectionChecker as a lazy singleton
  @lazySingleton
  InternetConnection get internetConnection => InternetConnection();
}

// Define an abstract class for ConnectionChecker
abstract interface class ConnectionChecker {
  Future<bool> get isConnected;
}

// Implement the ConnectionChecker using InternetConnectionCheckerPlus
@Injectable(as: ConnectionChecker)
class ConnectionCheckerImpl implements ConnectionChecker {
  final InternetConnection internetConnection;

  ConnectionCheckerImpl(this.internetConnection);

  @override
  Future<bool> get isConnected async =>
      await internetConnection.hasInternetAccess;
}
