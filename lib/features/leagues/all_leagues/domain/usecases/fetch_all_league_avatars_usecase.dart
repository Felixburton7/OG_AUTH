import 'package:injectable/injectable.dart';
import 'package:panna_app/core/utils/pick_image.dart';

@injectable
class FetchLeagueAvatarUrlUseCase {
  final ImageUploadService imageUploadService;

  FetchLeagueAvatarUrlUseCase(this.imageUploadService);

  Future<String?> execute(String leagueId) async {
    return await imageUploadService.fetchLeagueAvatarUrl(leagueId);
  }
}
