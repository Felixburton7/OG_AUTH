import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'dependency_injection.config.dart';

// Using the @injectable package in conjunction with get_it, the service locator, to manage dependencies.
// *Note for refactoring, some of these can be changed to @singleton classes so we can share the state across the app.
// @singleton could be got resources that are expensive to createa or should be reused.
final getIt = GetIt.instance;

@InjectableInit()
void configureDependencyInjection() => getIt.init();
