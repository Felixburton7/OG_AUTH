import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class FeedbackSupabaseRepository {
  final SupabaseClient _supabaseClient;

  FeedbackSupabaseRepository(this._supabaseClient);

  Future<void> submitFeedback(Map<String, dynamic> feedbackData) async {
    try {
      final response =
          await _supabaseClient.from('feedback').insert(feedbackData);

      // Check if response is null
      if (response == null) {
        // Handle null response (assuming success)
        return;
      }

      // Check for errors in the response
      if (response.error != null) {
        throw Exception('Failed to submit feedback');
      }
    } on PostgrestException {
      // Handle database exceptions
      throw Exception('Failed to submit feedback');
    } catch (e) {
      // Handle any other exceptions
      throw Exception('Failed to submit feedback');
    }
  }
}
