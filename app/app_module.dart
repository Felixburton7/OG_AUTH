import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';

// The @module annotation is used by the Injectable package to indicate that this
// class is a module that provides dependencies to be injected into other parts of the app.
@module
abstract class AppModule {
  // This getter provides an instance of SupabaseClient, which is the main client
  // used to interact with your Supabase backend, such as querying the database.
  SupabaseClient get supabaseClient => Supabase.instance.client;

  // This getter provides an instance of GoTrueClient, which is used specifically for
  // managing authentication (sign-up, sign-in, user management) with Supabase.
  GoTrueClient get supabaseAuth => Supabase.instance.client.auth;

  // This getter provides an instance of FunctionsClient, which is used to interact
  // with Supabase Edge Functions, allowing you to call serverless functions hosted on Supabase.
  FunctionsClient get functionsClient => Supabase.instance.client.functions;
}
