import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/features/feedback/data/datasource/feedback_remote_datasource.dart';

part 'feedback_state.dart';

@injectable
class FeedbackCubit extends Cubit<FeedbackState> {
  final FeedbackSupabaseRepository _feedbackRepository;

  FeedbackCubit(this._feedbackRepository) : super(FeedbackInitial());

  Future<void> submitFeedback(Map<String, dynamic> feedbackData) async {
    emit(FeedbackSubmitting());
    try {
      await _feedbackRepository.submitFeedback(feedbackData);
      emit(FeedbackSuccess());
    } catch (e) {
      emit(FeedbackError(message: e.toString()));
    }
  }
}
