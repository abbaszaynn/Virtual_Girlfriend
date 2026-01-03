import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:kraveai/models/character_model.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  /// Initialize Supabase with keys from .env
  Future<void> initialize() async {
    try {
      await dotenv.load(fileName: ".env");

      final String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
      final String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

      debugPrint(
        "DEBUG: Loaded SUPABASE_URL: $supabaseUrl",
      ); // Check what is actually loaded

      if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
        throw Exception(
          "Missing SUPABASE_URL or SUPABASE_ANON_KEY in .env file",
        );
      }

      await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

      debugPrint("✅ Supabase initialized successfully");
    } catch (e) {
      debugPrint("❌ Supabase initialization failed: $e");
      rethrow;
    }
  }

  /// Get the client instance
  SupabaseClient get client => Supabase.instance.client;

  /// Get the current authenticated user
  User? get currentUser => client.auth.currentUser;

  /// Sign out
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  Future<String> getOrCreateCharacter(Character character) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception("User not logged in");

      // 1. Check if Character exists
      final data = await client
          .from('characters')
          .select()
          .eq('user_id', user.id)
          .eq('name', character.name)
          .limit(1)
          .maybeSingle();

      if (data != null) {
        // Force update the system prompt to ensure new behavior for existing characters
        await client
            .from('characters')
            .update({
              'system_prompt': character.systemPrompt,
              'image_url':
                  character.imagePath, // ensure image is updated if changed
            })
            .eq('id', data['id']);
        return data['id'];
      }

      // 2. Create Character if not exists
      final newChar = await client
          .from('characters')
          .insert({
            'user_id': user.id,
            'name': character.name,
            'description': character.description,
            'system_prompt': character.systemPrompt,
            'image_url': character.imagePath,
            'voice_id': character.voiceId,
          })
          .select()
          .single();

      return newChar['id'];
    } catch (e) {
      debugPrint("Error getting/creating ${character.name}: $e");
      rethrow;
    }
  }
}
