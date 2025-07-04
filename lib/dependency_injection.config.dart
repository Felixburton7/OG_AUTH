// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_analytics/firebase_analytics.dart' as _i398;
import 'package:flutter/material.dart' as _i409;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:panna_app/core/app/app_module.dart' as _i610;
import 'package:panna_app/core/dummy_data/allLeagueLocalDataSourceDummyData.dart'
    as _i931;
import 'package:panna_app/core/modules/firebase_module.dart' as _i167;
import 'package:panna_app/core/network/connection_checker.dart' as _i853;
import 'package:panna_app/core/router/navigation/bottom_navigator/cubit/bottom_navigation_bar_cubit.dart'
    as _i245;
import 'package:panna_app/core/services/firebase_analytics_service.dart'
    as _i950;
import 'package:panna_app/core/utils/pick_image.dart' as _i885;
import 'package:panna_app/features/account/profile/data/datasource/profile_remote_data_source.dart'
    as _i836;
import 'package:panna_app/features/account/profile/data/datasource/profile_sql_database.dart/sql_profile_database.dart'
    as _i261;
import 'package:panna_app/features/account/profile/data/mapper/user_profile_model.dart'
    as _i896;
import 'package:panna_app/features/account/profile/data/repository/profile_repository_impl.dart'
    as _i804;
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart'
    as _i608;
import 'package:panna_app/features/account/profile/domain/repository/profile_repository.dart'
    as _i614;
import 'package:panna_app/features/account/profile/domain/usecases/get_profile_usecase.dart'
    as _i540;
import 'package:panna_app/features/account/profile/domain/usecases/update_profile_usecase.dart'
    as _i51;
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart'
    as _i623;
import 'package:panna_app/features/account/settings/data/supabase_user_repository.dart'
    as _i750;
import 'package:panna_app/features/account/settings/domain/repository/user_repository.dart'
    as _i633;
import 'package:panna_app/features/account/settings/domain/use_case/change_email_address_use_case.dart'
    as _i337;
import 'package:panna_app/features/account/settings/domain/use_case/change_password_usecase.dart'
    as _i493;
import 'package:panna_app/features/account/settings/domain/use_case/update_forgot_password_usecase.dart'
    as _i18;
import 'package:panna_app/features/account/settings/domain/use_case/update_password.dart'
    as _i921;
import 'package:panna_app/features/account/settings/presentation/cubit/change_email_address/change_email_address_cubit.dart'
    as _i124;
import 'package:panna_app/features/account/settings/presentation/cubit/reset_password/reset_password_cubit.dart'
    as _i481;
import 'package:panna_app/features/account/settings/presentation/cubit/update_forgot_password_cubit/update_forgot_password_cubit.dart'
    as _i549;
import 'package:panna_app/features/account/settings/presentation/cubit/update_password/update_password_cubit.dart'
    as _i457;
import 'package:panna_app/features/account/settings/theme_mode/data/repository/theme_mode_hive_repository.dart'
    as _i995;
import 'package:panna_app/features/account/settings/theme_mode/domain/repository/theme_mode_repository.dart'
    as _i996;
import 'package:panna_app/features/account/settings/theme_mode/domain/use_case/get_or_set_initial_theme_mode_use_case.dart'
    as _i20;
import 'package:panna_app/features/account/settings/theme_mode/domain/use_case/set_theme_mode_id_use_case.dart'
    as _i607;
import 'package:panna_app/features/account/settings/theme_mode/presentation/bloc/theme_mode_cubit.dart'
    as _i666;
import 'package:panna_app/features/articles/data/datasource/articles_local_datasource.dart'
    as _i100;
import 'package:panna_app/features/articles/data/datasource/articles_remote_data_source.dart'
    as _i824;
import 'package:panna_app/features/articles/data/repository/articles_repository_impl.dart'
    as _i1002;
import 'package:panna_app/features/articles/domain/repository/articles_repository.dart'
    as _i64;
import 'package:panna_app/features/articles/domain/usecases/fetch_all_articles_uscase.dart'
    as _i853;
import 'package:panna_app/features/articles/domain/usecases/like_article_usecase.dart'
    as _i296;
import 'package:panna_app/features/articles/domain/usecases/unlike_article_usecase.dart'
    as _i619;
import 'package:panna_app/features/articles/presentation/bloc/articles/articles_bloc.dart'
    as _i336;
import 'package:panna_app/features/auth/data/repository/supabase_auth_repository.dart'
    as _i607;
import 'package:panna_app/features/auth/domain/repository/auth_repository.dart'
    as _i800;
import 'package:panna_app/features/auth/domain/use_case/get_current_auth_state_use_case.dart'
    as _i1058;
import 'package:panna_app/features/auth/domain/use_case/get_logged_in_user_use_case.dart'
    as _i710;
import 'package:panna_app/features/auth/domain/use_case/login_with_email_use_case.dart'
    as _i499;
import 'package:panna_app/features/auth/domain/use_case/login_with_google_use_case.dart'
    as _i914;
import 'package:panna_app/features/auth/domain/use_case/login_with_password_use_case.dart'
    as _i48;
import 'package:panna_app/features/auth/domain/use_case/logout_use_case.dart'
    as _i12;
import 'package:panna_app/features/auth/domain/use_case/user_sign_up_password_email.dart'
    as _i772;
import 'package:panna_app/features/auth/domain/use_case/user_signup_extra_details_usecase.dart'
    as _i715;
import 'package:panna_app/features/auth/presentation/bloc/auth_bloc.dart'
    as _i654;
import 'package:panna_app/features/auth/presentation/bloc/login/login_cubit.dart'
    as _i377;
import 'package:panna_app/features/auth/presentation/bloc/signup/signup_cubit.dart'
    as _i106;
import 'package:panna_app/features/auth/presentation/bloc/signup_extra_details/cubit/signup_extra_details_cubit.dart'
    as _i185;
import 'package:panna_app/features/feedback/data/datasource/feedback_remote_datasource.dart'
    as _i689;
import 'package:panna_app/features/feedback/presentation/cubit/feedback_cubit.dart'
    as _i85;
import 'package:panna_app/features/fixtures_and_standings/data/supabase_repository/supabase_fixtures_standings_repository.dart'
    as _i90;
import 'package:panna_app/features/fixtures_and_standings/presentation/simple_fixtures_standings_page.dart'
    as _i51;
import 'package:panna_app/features/leagues/all_leagues/data/datasource/all_leagues_local_data_source.dart'
    as _i967;
import 'package:panna_app/features/leagues/all_leagues/data/datasource/all_leagues_remote_data_source.dart'
    as _i840;
import 'package:panna_app/features/leagues/all_leagues/data/repository/all_leagues_repository_impl.dart'
    as _i945;
import 'package:panna_app/features/leagues/all_leagues/domain/repositories/all_leagues_repository.dart'
    as _i390;
import 'package:panna_app/features/leagues/all_leagues/domain/usecases/fetch_all_league_avatars_usecase.dart'
    as _i757;
import 'package:panna_app/features/leagues/all_leagues/domain/usecases/fetch_all_leagues_usecase.dart'
    as _i974;
import 'package:panna_app/features/leagues/all_leagues/presentation/bloc/all_leagues/all_leagues_bloc.dart'
    as _i551;
import 'package:panna_app/features/leagues/head_to_head/data/datasource/h2h_remote_data_source.dart'
    as _i859;
import 'package:panna_app/features/leagues/head_to_head/data/repository/h2h_repository.dart'
    as _i425;
import 'package:panna_app/features/leagues/head_to_head/domain/repository/h2h_repository.dart'
    as _i684;
import 'package:panna_app/features/leagues/head_to_head/domain/usecases/cancel_bet_challenge_usecase.dart'
    as _i615;
import 'package:panna_app/features/leagues/head_to_head/domain/usecases/confirm_bet_challenge_usecase.dart'
    as _i431;
import 'package:panna_app/features/leagues/head_to_head/domain/usecases/create_bet_challenge.dart.dart'
    as _i283;
import 'package:panna_app/features/leagues/head_to_head/domain/usecases/create_bet_offer.dart'
    as _i172;
import 'package:panna_app/features/leagues/head_to_head/domain/usecases/decline_bet_challenge_usecase.dart'
    as _i258;
import 'package:panna_app/features/leagues/head_to_head/domain/usecases/fetch_h2h_game_details.dart'
    as _i1001;
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_challenge_bloc.dart'
    as _i247;
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_offer_bloc.dart'
    as _i916;
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/h2h_bloc.dart'
    as _i959;
import 'package:panna_app/features/leagues/league_home/data/datasource/league_details_local_data_source.dart'
    as _i278;
import 'package:panna_app/features/leagues/league_home/data/datasource/league_details_remote_data_source.dart'
    as _i942;
import 'package:panna_app/features/leagues/league_home/data/repository/league_details_repository_impl.dart'
    as _i380;
import 'package:panna_app/features/leagues/league_home/domain/repository/league_details_repository.dart'
    as _i607;
import 'package:panna_app/features/leagues/league_home/domain/usecases/fetch_league_details_usecase.dart'
    as _i553;
import 'package:panna_app/features/leagues/league_home/domain/usecases/fetch_league_members_use_case.dart'
    as _i269;
import 'package:panna_app/features/leagues/league_home/domain/usecases/fetch_league_survivor_rounds_usecase.dart'
    as _i246;
import 'package:panna_app/features/leagues/league_home/domain/usecases/leave_league_usecase.dart'
    as _i846;
import 'package:panna_app/features/leagues/league_home/domain/usecases/make_current_selection_usecase.dart'
    as _i344;
import 'package:panna_app/features/leagues/league_home/presentation/bloc/current_selections/current_selections_bloc.dart'
    as _i704;
import 'package:panna_app/features/leagues/league_home/presentation/bloc/details/league_details_bloc.dart'
    as _i148;
import 'package:panna_app/features/leagues/league_home/presentation/bloc/view_members_selections_cubit/view_members_selections_cubit.dart'
    as _i698;
import 'package:panna_app/features/leagues/lms_game/data/datasource/lms_game_local_data_source.dart'
    as _i291;
import 'package:panna_app/features/leagues/lms_game/data/datasource/lms_game_remote_data_source.dart'
    as _i628;
import 'package:panna_app/features/leagues/lms_game/data/repository/lms_game_repository_impl.dart'
    as _i270;
import 'package:panna_app/features/leagues/lms_game/domain/repository/lms_game_repository.dart'
    as _i89;
import 'package:panna_app/features/leagues/lms_game/domain/usecases/fetch_league_survivor_rounds_usecase.dart'
    as _i304;
import 'package:panna_app/features/leagues/lms_game/domain/usecases/fetch_lms_home_details_usecase.dart'
    as _i553;
import 'package:panna_app/features/leagues/lms_game/domain/usecases/leave_lms_game_usecase.dart'
    as _i564;
import 'package:panna_app/features/leagues/lms_game/domain/usecases/pay_buy_in_usecase.dart'
    as _i470;
import 'package:panna_app/features/leagues/lms_game/presentation/bloc/lms_current_selections/lms_current_selections_bloc.dart'
    as _i161;
import 'package:panna_app/features/leagues/lms_game/presentation/bloc/lms_game/lms_game_bloc.dart'
    as _i173;
import 'package:panna_app/features/leagues/lms_game/presentation/bloc/lms_selections_table/lms_selections_table_cubit.dart'
    as _i129;
import 'package:panna_app/features/leagues/manage_leagues/data/repository/supabase_manage_leagues_repository.dart'
    as _i340;
import 'package:panna_app/features/leagues/manage_leagues/domain/repository/manage_leagues_repository.dart'
    as _i939;
import 'package:panna_app/features/leagues/manage_leagues/domain/usecases/create_league_usecase.dart'
    as _i725;
import 'package:panna_app/features/leagues/manage_leagues/domain/usecases/fetch_upcoming_leagues_usecase.dart'
    as _i432;
import 'package:panna_app/features/leagues/manage_leagues/domain/usecases/update_league_usecase.dart'
    as _i819;
import 'package:panna_app/features/leagues/manage_leagues/domain/usecases/verify_add_code_usecase.dart'
    as _i216;
import 'package:panna_app/features/leagues/manage_leagues/presentation/create_league/bloc/cubit/create_league_cubit.dart'
    as _i897;
import 'package:panna_app/features/leagues/manage_leagues/presentation/join_league/cubit/join_league_cubit.dart'
    as _i213;
import 'package:panna_app/features/leagues/manage_leagues/presentation/join_league/page/join_league_page.dart'
    as _i13;
import 'package:supabase/supabase.dart' as _i590;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    final internetConnectionCheckerModule = _$InternetConnectionCheckerModule();
    final firebaseModule = _$FirebaseModule();
    gh.factory<_i931.AllLeagueLocalDataSourceDummyData>(
        () => _i931.AllLeagueLocalDataSourceDummyData());
    gh.factory<_i454.SupabaseClient>(() => appModule.supabaseClient);
    gh.factory<_i454.GoTrueClient>(() => appModule.supabaseAuth);
    gh.factory<_i454.FunctionsClient>(() => appModule.functionsClient);
    gh.factory<_i885.ImageUploadService>(() => _i885.ImageUploadService());
    gh.factory<_i245.BottomNavigationBarCubit>(
        () => _i245.BottomNavigationBarCubit());
    gh.factory<_i100.ArticlesLocalDataSource>(
        () => _i100.ArticlesLocalDataSource());
    gh.factory<_i698.ViewMembersSelectionsCubit>(
        () => _i698.ViewMembersSelectionsCubit());
    gh.factory<_i129.LmsSelectionsTableCubit>(
        () => _i129.LmsSelectionsTableCubit());
    gh.factory<_i261.SQLProfileDataSource>(() => _i261.SQLProfileDataSource());
    gh.lazySingleton<_i161.InternetConnection>(
        () => internetConnectionCheckerModule.internetConnection);
    gh.lazySingleton<_i398.FirebaseAnalytics>(
        () => firebaseModule.firebaseAnalytics);
    gh.lazySingleton<_i950.FirebaseAnalyticsService>(
        () => firebaseModule.firebaseAnalyticsService);
    gh.factory<_i51.LiveScoresStandingsPage>(
        () => _i51.LiveScoresStandingsPage(key: gh<_i409.Key>()));
    gh.factory<_i13.JoinLeaguePage>(
        () => _i13.JoinLeaguePage(key: gh<_i409.Key>()));
    gh.factory<_i278.LeagueDetailsLocalDataSource>(
        () => _i278.LeagueDetailsLocalDataSourceImpl());
    gh.factory<_i757.FetchLeagueAvatarUrlUseCase>(() =>
        _i757.FetchLeagueAvatarUrlUseCase(gh<_i885.ImageUploadService>()));
    gh.factory<_i824.ArticlesRemoteDataSource>(() =>
        _i824.ArticlesRemoteDataSource(client: gh<_i590.SupabaseClient>()));
    gh.factory<_i859.H2hGameRemoteDataSource>(
        () => _i859.H2hGameRemoteDataSource(gh<_i454.SupabaseClient>()));
    gh.factory<_i942.LeagueDetailsRemoteDataSource>(
        () => _i942.LeagueDetailsRemoteDataSource(gh<_i454.SupabaseClient>()));
    gh.factory<_i628.LmsGameRemoteDataSource>(
        () => _i628.LmsGameRemoteDataSource(gh<_i454.SupabaseClient>()));
    gh.factory<_i291.LmsGameLocalDataSource>(
        () => _i291.LeagueDetailsLocalDataSourceImpl());
    gh.factory<_i633.UserRepository>(() => _i750.SupabaseUserRepository(
          gh<_i590.GoTrueClient>(),
          gh<_i590.FunctionsClient>(),
        ));
    gh.factory<_i840.AllLeaguesRemoteDataSource>(() =>
        _i840.AllLeaguesRemoteDataSource(
            gh<_i757.FetchLeagueAvatarUrlUseCase>()));
    gh.factory<_i967.AllLeaguesLocalDataSource>(() =>
        _i967.AllLeaguesLocalDataSource(
            gh<_i931.AllLeagueLocalDataSourceDummyData>()));
    gh.factory<_i996.ThemeModeRepository>(
        () => _i995.ThemeModeHiveRepository());
    gh.factory<_i800.AuthRepository>(() => _i607.SupabaseAuthRepository(
          gh<_i454.GoTrueClient>(),
          gh<_i454.SupabaseClient>(),
        ));
    gh.factory<_i90.SupabaseFixturesStandingsRepository>(() =>
        _i90.SupabaseFixturesStandingsRepository(gh<_i454.SupabaseClient>()));
    gh.factory<_i689.FeedbackSupabaseRepository>(
        () => _i689.FeedbackSupabaseRepository(gh<_i454.SupabaseClient>()));
    gh.factory<_i836.ProfileRemoteDataSource>(
        () => _i836.ProfileRemoteDataSource(gh<_i454.SupabaseClient>()));
    gh.factory<_i607.LeagueDetailsRepository>(
        () => _i380.LeagueDetailsRepositoryImpl(
              gh<_i942.LeagueDetailsRemoteDataSource>(),
              gh<_i278.LeagueDetailsLocalDataSource>(),
            ));
    gh.factory<_i64.ArticlesRepository>(() => _i1002.ArticlesRepositoryImpl(
          gh<_i824.ArticlesRemoteDataSource>(),
          gh<_i100.ArticlesLocalDataSource>(),
        ));
    gh.factory<_i20.GetOrSetInitialThemeModeUseCase>(() =>
        _i20.GetOrSetInitialThemeModeUseCase(gh<_i996.ThemeModeRepository>()));
    gh.factory<_i607.SetThemeModeUseCase>(
        () => _i607.SetThemeModeUseCase(gh<_i996.ThemeModeRepository>()));
    gh.factory<_i12.LogoutUseCase>(
        () => _i12.LogoutUseCase(gh<_i800.AuthRepository>()));
    gh.factory<_i710.GetLoggedInUserUseCase>(
        () => _i710.GetLoggedInUserUseCase(gh<_i800.AuthRepository>()));
    gh.factory<_i914.LoginWithGoogleUseCase>(
        () => _i914.LoginWithGoogleUseCase(gh<_i800.AuthRepository>()));
    gh.factory<_i499.LoginWithEmailUseCase>(
        () => _i499.LoginWithEmailUseCase(gh<_i800.AuthRepository>()));
    gh.factory<_i772.SignUpWithPasswordUseCase>(
        () => _i772.SignUpWithPasswordUseCase(gh<_i800.AuthRepository>()));
    gh.factory<_i1058.GetCurrentAuthStateUseCase>(
        () => _i1058.GetCurrentAuthStateUseCase(gh<_i800.AuthRepository>()));
    gh.factory<_i846.LeaveLeagueUseCase>(
        () => _i846.LeaveLeagueUseCase(gh<_i607.LeagueDetailsRepository>()));
    gh.factory<_i344.MakeCurrentSelectionUseCase>(() =>
        _i344.MakeCurrentSelectionUseCase(gh<_i607.LeagueDetailsRepository>()));
    gh.factory<_i553.FetchLeagueDetailsUseCase>(() =>
        _i553.FetchLeagueDetailsUseCase(gh<_i607.LeagueDetailsRepository>()));
    gh.factory<_i564.LeaveLmsGameUseCase>(
        () => _i564.LeaveLmsGameUseCase(gh<_i607.LeagueDetailsRepository>()));
    gh.factory<_i939.ManageLeaguesRepository>(() =>
        _i340.SupabaseManageLeaguesRepository(gh<_i590.SupabaseClient>()));
    gh.factory<_i853.ConnectionChecker>(
        () => _i853.ConnectionCheckerImpl(gh<_i161.InternetConnection>()));
    gh.factory<_i608.UserProfileEntity>(() => _i896.UserProfileDTO(
          profileId: gh<String>(),
          updatedAt: gh<DateTime>(),
          dateOfBirth: gh<DateTime>(),
          username: gh<String>(),
          avatarUrl: gh<String>(),
          teamSupported: gh<String>(),
          accountBalance: gh<double>(),
          firstName: gh<String>(),
          lastName: gh<String>(),
          lmsAverage: gh<double>(),
          bio: gh<String>(),
        ));
    gh.factory<_i106.SignUpCubit>(
        () => _i106.SignUpCubit(gh<_i772.SignUpWithPasswordUseCase>()));
    gh.factory<_i819.UpdateLeagueUseCase>(
        () => _i819.UpdateLeagueUseCase(gh<_i939.ManageLeaguesRepository>()));
    gh.factory<_i337.ChangeEmailAddressUseCase>(
        () => _i337.ChangeEmailAddressUseCase(gh<_i633.UserRepository>()));
    gh.factory<_i18.UpdateForgotPasswordUseCase>(
        () => _i18.UpdateForgotPasswordUseCase(gh<_i633.UserRepository>()));
    gh.factory<_i921.UpdatePasswordUseCase>(
        () => _i921.UpdatePasswordUseCase(gh<_i633.UserRepository>()));
    gh.factory<_i493.ResetPasswordUseCase>(
        () => _i493.ResetPasswordUseCase(gh<_i633.UserRepository>()));
    gh.factory<_i124.ChangeEmailAddressCubit>(() =>
        _i124.ChangeEmailAddressCubit(gh<_i337.ChangeEmailAddressUseCase>()));
    gh.factory<_i666.ThemeModeCubit>(() => _i666.ThemeModeCubit(
          gh<_i20.GetOrSetInitialThemeModeUseCase>(),
          gh<_i607.SetThemeModeUseCase>(),
        ));
    gh.factory<_i85.FeedbackCubit>(
        () => _i85.FeedbackCubit(gh<_i689.FeedbackSupabaseRepository>()));
    gh.factory<_i684.H2hGameRepository>(
        () => _i425.H2hRepositoryImpl(gh<_i859.H2hGameRemoteDataSource>()));
    gh.factory<_i853.FetchAllArticlesUseCase>(
        () => _i853.FetchAllArticlesUseCase(gh<_i64.ArticlesRepository>()));
    gh.factory<_i296.LikeArticleUseCase>(
        () => _i296.LikeArticleUseCase(gh<_i64.ArticlesRepository>()));
    gh.factory<_i619.UnlikeArticleUseCase>(
        () => _i619.UnlikeArticleUseCase(gh<_i64.ArticlesRepository>()));
    gh.factory<_i89.LmsGameRepository>(() => _i270.LmsGameRepositoryImpl(
          gh<_i628.LmsGameRemoteDataSource>(),
          gh<_i291.LmsGameLocalDataSource>(),
        ));
    gh.factory<_i161.LmsCurrentSelectionsBloc>(
        () => _i161.LmsCurrentSelectionsBloc(
              gh<_i89.LmsGameRepository>(),
              gh<_i344.MakeCurrentSelectionUseCase>(),
            ));
    gh.factory<_i148.LeagueDetailsBloc>(() => _i148.LeagueDetailsBloc(
          fetchLeagueDetailsUseCase: gh<_i553.FetchLeagueDetailsUseCase>(),
          leaveLeagueUseCase: gh<_i846.LeaveLeagueUseCase>(),
        ));
    gh.factory<_i48.LoginWithPasswordUseCase>(
        () => _i48.LoginWithPasswordUseCase(gh<_i800.AuthRepository>()));
    gh.factory<_i553.FetchLmsGameDetailsUseCase>(
        () => _i553.FetchLmsGameDetailsUseCase(gh<_i89.LmsGameRepository>()));
    gh.factory<_i704.CurrentSelectionsBloc>(() => _i704.CurrentSelectionsBloc(
          gh<_i607.LeagueDetailsRepository>(),
          gh<_i344.MakeCurrentSelectionUseCase>(),
        ));
    gh.factory<_i377.LoginCubit>(() => _i377.LoginCubit(
          gh<_i499.LoginWithEmailUseCase>(),
          gh<_i48.LoginWithPasswordUseCase>(),
          gh<_i914.LoginWithGoogleUseCase>(),
        ));
    gh.factory<_i432.FetchUpcomingGameWeeksUseCase>(() =>
        _i432.FetchUpcomingGameWeeksUseCase(
            gh<_i939.ManageLeaguesRepository>()));
    gh.factory<_i725.CreateLeagueUseCase>(
        () => _i725.CreateLeagueUseCase(gh<_i939.ManageLeaguesRepository>()));
    gh.factory<_i216.VerifyAddCodeUsecase>(
        () => _i216.VerifyAddCodeUsecase(gh<_i939.ManageLeaguesRepository>()));
    gh.factory<_i470.PayBuyInUseCase>(
        () => _i470.PayBuyInUseCase(gh<_i939.ManageLeaguesRepository>()));
    gh.factory<_i457.UpdatePasswordCubit>(
        () => _i457.UpdatePasswordCubit(gh<_i921.UpdatePasswordUseCase>()));
    gh.factory<_i549.UpdateForgotPasswordCubit>(() =>
        _i549.UpdateForgotPasswordCubit(gh<_i921.UpdatePasswordUseCase>()));
    gh.factory<_i614.ProfileRepository>(() => _i804.ProfileRepositoryImpl(
          gh<_i836.ProfileRemoteDataSource>(),
          gh<_i261.SQLProfileDataSource>(),
          gh<_i853.ConnectionChecker>(),
        ));
    gh.factory<_i897.CreateLeagueCubit>(() => _i897.CreateLeagueCubit(
          gh<_i725.CreateLeagueUseCase>(),
          gh<_i819.UpdateLeagueUseCase>(),
          gh<_i885.ImageUploadService>(),
          gh<_i432.FetchUpcomingGameWeeksUseCase>(),
        ));
    gh.factory<_i172.CreateBetOfferUseCase>(
        () => _i172.CreateBetOfferUseCase(gh<_i684.H2hGameRepository>()));
    gh.factory<_i1001.FetchH2hGameDetailsUseCase>(
        () => _i1001.FetchH2hGameDetailsUseCase(gh<_i684.H2hGameRepository>()));
    gh.factory<_i283.CreateBetChallengeUseCase>(
        () => _i283.CreateBetChallengeUseCase(gh<_i684.H2hGameRepository>()));
    gh.factory<_i431.ConfirmChallengeUseCase>(
        () => _i431.ConfirmChallengeUseCase(gh<_i684.H2hGameRepository>()));
    gh.factory<_i615.CancelChallengeUseCase>(
        () => _i615.CancelChallengeUseCase(gh<_i684.H2hGameRepository>()));
    gh.factory<_i258.DeclineChallengeUseCase>(
        () => _i258.DeclineChallengeUseCase(gh<_i684.H2hGameRepository>()));
    gh.factory<_i390.AllLeagueRepository>(() => _i945.AllLeaguesRepositoryImpl(
          gh<_i840.AllLeaguesRemoteDataSource>(),
          gh<_i967.AllLeaguesLocalDataSource>(),
          gh<_i853.ConnectionChecker>(),
        ));
    gh.factory<_i336.ArticlesBloc>(() => _i336.ArticlesBloc(
          fetchAllArticlesUseCase: gh<_i853.FetchAllArticlesUseCase>(),
          likeArticleUseCase: gh<_i296.LikeArticleUseCase>(),
          unlikeArticleUseCase: gh<_i619.UnlikeArticleUseCase>(),
        ));
    gh.factory<_i173.LmsGameBloc>(() => _i173.LmsGameBloc(
          fetchLmsGameDetailsUseCase: gh<_i553.FetchLmsGameDetailsUseCase>(),
          leaveLmsGameUseCase: gh<_i564.LeaveLmsGameUseCase>(),
          payBuyInUseCase: gh<_i470.PayBuyInUseCase>(),
        ));
    gh.factory<_i481.ResetPasswordCubit>(
        () => _i481.ResetPasswordCubit(gh<_i493.ResetPasswordUseCase>()));
    gh.factory<_i715.SignUpExtraDetailsUseCase>(
        () => _i715.SignUpExtraDetailsUseCase(gh<_i614.ProfileRepository>()));
    gh.factory<_i916.BetOfferBloc>(() => _i916.BetOfferBloc(
        createBetOfferUseCase: gh<_i172.CreateBetOfferUseCase>()));
    gh.factory<_i974.FetchUserLeaguesUseCase>(
        () => _i974.FetchUserLeaguesUseCase(gh<_i390.AllLeagueRepository>()));
    gh.factory<_i269.FetchLeagueMembersUseCase>(
        () => _i269.FetchLeagueMembersUseCase(gh<_i390.AllLeagueRepository>()));
    gh.factory<_i246.FetchLeagueSurvivorRoundsUseCase>(() =>
        _i246.FetchLeagueSurvivorRoundsUseCase(
            gh<_i390.AllLeagueRepository>()));
    gh.factory<_i304.FetchLmsLeagueSurvivorRoundsUseCase>(() =>
        _i304.FetchLmsLeagueSurvivorRoundsUseCase(
            gh<_i390.AllLeagueRepository>()));
    gh.factory<_i959.H2hBloc>(() => _i959.H2hBloc(
        fetchH2hGameDetailsUseCase: gh<_i1001.FetchH2hGameDetailsUseCase>()));
    gh.factory<_i247.BetChallengeBloc>(() => _i247.BetChallengeBloc(
          createBetChallengeUseCase: gh<_i283.CreateBetChallengeUseCase>(),
          confirmChallengeUseCase: gh<_i431.ConfirmChallengeUseCase>(),
          declineChallengeUseCase: gh<_i258.DeclineChallengeUseCase>(),
          cancelChallengeUseCase: gh<_i615.CancelChallengeUseCase>(),
        ));
    gh.factory<_i551.LeagueBloc>(() => _i551.LeagueBloc(
        fetchUserLeaguesUseCase: gh<_i974.FetchUserLeaguesUseCase>()));
    gh.factory<_i51.UpdateProfileUseCase>(
        () => _i51.UpdateProfileUseCase(gh<_i614.ProfileRepository>()));
    gh.factory<_i540.GetProfileUseCase>(
        () => _i540.GetProfileUseCase(gh<_i614.ProfileRepository>()));
    gh.factory<_i185.SignupExtraDetailsCubit>(
        () => _i185.SignupExtraDetailsCubit(
              gh<_i715.SignUpExtraDetailsUseCase>(),
              gh<_i885.ImageUploadService>(),
            ));
    gh.factory<_i213.JoinLeagueCubit>(() => _i213.JoinLeagueCubit(
          fetchUserLeaguesUseCase: gh<_i974.FetchUserLeaguesUseCase>(),
          fetchLeagueMembersUseCase: gh<_i269.FetchLeagueMembersUseCase>(),
          fetchLeagueSurvivorRoundsUseCase:
              gh<_i246.FetchLeagueSurvivorRoundsUseCase>(),
          verifyAddCodeUsecase: gh<_i216.VerifyAddCodeUsecase>(),
          manageLeaguesRepository: gh<_i939.ManageLeaguesRepository>(),
        ));
    gh.factory<_i623.ProfileCubit>(() => _i623.ProfileCubit(
          gh<_i540.GetProfileUseCase>(),
          gh<_i51.UpdateProfileUseCase>(),
          gh<_i885.ImageUploadService>(),
        ));
    gh.factory<_i654.AuthBloc>(() => _i654.AuthBloc(
          gh<_i710.GetLoggedInUserUseCase>(),
          gh<_i1058.GetCurrentAuthStateUseCase>(),
          gh<_i12.LogoutUseCase>(),
          gh<_i623.ProfileCubit>(),
        ));
    return this;
  }
}

class _$AppModule extends _i610.AppModule {}

class _$InternetConnectionCheckerModule
    extends _i853.InternetConnectionCheckerModule {}

class _$FirebaseModule extends _i167.FirebaseModule {}
