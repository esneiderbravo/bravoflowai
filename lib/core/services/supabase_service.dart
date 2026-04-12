import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

/// BravoFlow AI — Supabase Service
///
/// Centralizes all Supabase initialization and exposes
/// the client for use across the application.
abstract final class SupabaseService {
  /// Initializes the Supabase client.
  /// Must be called once in [main] before [runApp].
  static Future<void> initialize() async {
    final url = dotenv.env[AppConstants.envSupabaseUrl] ?? '';
    final anonKey = dotenv.env[AppConstants.envSupabaseAnonKey] ?? '';

    assert(url.isNotEmpty, 'SUPABASE_URL is missing from .env');
    assert(anonKey.isNotEmpty, 'SUPABASE_ANON_KEY is missing from .env');

    await Supabase.initialize(url: url, anonKey: anonKey, debug: false);
  }

  /// Returns the singleton [SupabaseClient] instance.
  static SupabaseClient get client => Supabase.instance.client;

  /// Convenience accessor for the current authenticated [User], if any.
  static User? get currentUser => client.auth.currentUser;

  /// Convenience accessor for the auth [Session], if any.
  static Session? get currentSession => client.auth.currentSession;

  /// Returns `true` when a user is signed in.
  static bool get isAuthenticated => currentUser != null;
}
