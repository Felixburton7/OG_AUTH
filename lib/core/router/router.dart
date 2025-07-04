import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/error/error_page.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/router/navigation/bottom_navigator/widgets/home_page.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/core/value_objects/leagues/league_summary.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/account/profile/data/mapper/user_profile_model.dart';
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart';
import 'package:panna_app/features/account/settings/presentation/page/deposit_money_page.dart';
import 'package:panna_app/features/account/settings/presentation/page/forgot_password_page.dart';
import 'package:panna_app/features/account/settings/presentation/page/settings_page.dart';
import 'package:panna_app/features/account/settings/presentation/page/update_forgot_password_page.dart';
import 'package:panna_app/features/account/settings/presentation/page/update_password_page.dart';
import 'package:panna_app/features/account/settings/presentation/page/withdraw_money.dart';
import 'package:panna_app/features/articles/domain/entities/article_detail_entity.dart';
import 'package:panna_app/features/articles/presentation/page/article_details_page.dart';
import 'package:panna_app/features/articles/presentation/page/article_top_story_details.dart';
import 'package:panna_app/features/articles/presentation/page/half_articles_detail_page.dart';
import 'package:panna_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:panna_app/features/auth/presentation/page/check_your_email_page.dart';
import 'package:panna_app/features/auth/presentation/page/login_or_signup_page.dart';
import 'package:panna_app/features/auth/presentation/page/login_page.dart';
import 'package:panna_app/features/auth/presentation/page/sign_up_extra_details_flow.dart';
import 'package:panna_app/features/auth/presentation/page/sign_up_page.dart';
import 'package:panna_app/features/auth/presentation/page/splash_page.dart';
import 'package:panna_app/features/account/profile/presentation/page/edit_profile_page.dart';
import 'package:panna_app/features/account/profile/presentation/page/profile_page.dart';
import 'package:panna_app/features/account/settings/presentation/page/account_page.dart';
import 'package:panna_app/features/account/settings/theme_mode/presentation/page/theme_mode__page.dart';
import 'package:panna_app/features/account/settings/presentation/page/change_email_address_page.dart';
import 'package:panna_app/features/chat/domain/entities/messages.dart';
import 'package:panna_app/features/chat/presentation/pages/chat_room_page.dart';
import 'package:panna_app/features/feedback/presentation/feedback_page.dart';
import 'package:panna_app/features/feedback/presentation/help_page.dart';
import 'package:panna_app/features/leagues/all_leagues/data/mapper/all_leaguesDTO.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/features/leagues/all_leagues/presentation/page/all_league_homepage.dart';
import 'package:panna_app/features/leagues/all_leagues/presentation/page/all_leagues_homepage_listview_page.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/page/head_to_head_home.dart';
import 'package:panna_app/features/leagues/league_home/presentation/page/confirm_join_league_page.dart';
import 'package:panna_app/features/leagues/league_home/presentation/page/league_home.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_game_details.dart';
import 'package:panna_app/features/leagues/lms_game/presentation/page/lms_current_matches_page.dart';
import 'package:panna_app/features/leagues/lms_game/presentation/page/lms_game_rules.dart';
import 'package:panna_app/features/leagues/lms_game/presentation/page/lms_home.dart';
import 'package:panna_app/features/leagues/league_home/presentation/page/members_selections_page.dart';
import 'package:panna_app/features/leagues/league_home/presentation/page/pay_buy_in_page.dart';
import 'package:panna_app/features/leagues/league_home/presentation/page/posts_page.dart';
import 'package:panna_app/features/leagues/lms_game/presentation/page/lms_rounds_page.dart';
import 'package:panna_app/features/leagues/league_home/presentation/page/make_selection_page.dart';
import 'package:panna_app/features/leagues/league_home/presentation/bloc/details/league_details_bloc.dart';
import 'package:panna_app/features/leagues/lms_game/presentation/page/lms_selections_table.dart';
import 'package:panna_app/features/leagues/manage_leagues/presentation/admin_panel_league/league_admin_panel.dart';
import 'package:panna_app/features/leagues/manage_leagues/presentation/create_league/page/create_league_after_creation_page.dart';
import 'package:panna_app/features/leagues/manage_leagues/presentation/create_league/page/create_league_flow.dart';
import 'package:panna_app/features/leagues/manage_leagues/presentation/join_league/page/join_league_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final router = GoRouter(
  initialLocation: Routes.initial.path,
  redirect: (context, state) {
    final uri = state.uri;

    // Handle password reset deep links
    if (uri.scheme == 'io.supabase.panna-app' && uri.host == 'password-reset') {
      if (uri.queryParameters.containsKey('error')) {
        final errorDescription = uri.queryParameters['error_description'];
        return '/error?message=$errorDescription';
      } else {
        // Extract the token from query parameters
        final token = uri.queryParameters['token'];
        final type = uri.queryParameters['type'];

        // Check if this is a recovery link
        if (type == 'recovery') {
          // Send the token to AuthBloc so it knows we're recovering a password
          if (context != null) {
            context.read<AuthBloc>().add(
                  AuthPasswordRecoveryLinkReceived(token: token),
                );
          }
          return Routes.updateForgotPassword.path;
        }
      }
    }
    return null;
  },
  routes: [
    // GoRoute(
    //   name: Routes.initial.name,
    //   path: Routes.initial.path,
    //   builder: (context, state) => const SplashPage(),
    // ),
    // GoRoute(
    //   name: Routes.initial.name,
    //   path: Routes.initial.path,
    //   builder: (context, state) {
    //     return BlocBuilder<AuthBloc, AuthState>(
    //       builder: (context, state) {
    //         if (state is AuthUserAuthenticated) {
    //           return const HomeNavigationBarPage();
    //         } else {
    //           return const SplashPage();
    //         }
    //       },
    //     );
    //   },
    // ),
    GoRoute(
      name: Routes.initial.name,
      path: Routes.initial.path,
      builder: (context, state) {
        return BlocBuilder<AuthBloc, AuthBlocState>(
          builder: (context, authState) {
            if (authState is AuthUserAuthenticated) {
              return const HomeNavigationBarPage();
            } else if (authState is AuthPasswordRecovery) {
              return const UpdateForgotPasswordPage();
            } else {
              return const SplashPage();
            }
          },
        );
      },
    ),
    GoRoute(
      name: Routes.loginOrSignup.name,
      path: Routes.loginOrSignup.path,
      builder: (context, state) => const LoginOrSignupPage(),
    ),
    GoRoute(
      name: Routes.login.name,
      path: Routes.login.path,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: Routes.signupExtraDetails.name,
      path: Routes.signupExtraDetails.path,
      builder: (context, state) => const SignUpExtraDetailsFlow(),
    ),
    GoRoute(
      name: Routes.signUp.name,
      path: Routes.signUp.path,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      name: Routes.home.name,
      path: Routes.home.path,
      builder: (context, state) => const HomeNavigationBarPage(),
    ),
    GoRoute(
      name: Routes.feedback.name,
      path: Routes.feedback.path,
      builder: (context, state) => const FeedbackPage(),
    ),
    GoRoute(
      name: Routes.help.name,
      path: Routes.help.path,
      builder: (context, state) => const HelpPage(),
    ),
    GoRoute(
      name: Routes.articleDetails.name,
      path: Routes.articleDetails.path,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is ArticleDetailEntity) {
          return ArticleDetailsPage(
            articleDetail: extra,
          );
        } else {
          return const ErrorPage(
            message: 'Invalid data provided for Article Details Page.',
          );
        }
      },
    ),

    GoRoute(
      name: Routes.articleHalfDetails.name,
      path: Routes.articleHalfDetails.path,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is Map<String, String>) {
          return HalfArticleDetailsPage(
            imageUrl: extra['imageUrl']!,
            author: extra['author']!,
            date: extra['date']!,
            title: extra['title']!,
            content: extra['content']!,
          );
        } else {
          return const ErrorPage(
            message: 'Invalid data provided for Article Details Page.',
          );
        }
      },
    ),
    GoRoute(
      path: '/chat',
      name: 'chatRoom',
      builder: (context, state) {
        final groupChat = state.extra as GroupChat;
        return ChatRoomPage(chat: groupChat);
      },
    ),
    GoRoute(
      name: Routes.topStoryDetails.name,
      path: Routes.topStoryDetails.path,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is Map<String, String>) {
          return TopStoryDetailsPage(
            imageUrl: extra['imageUrl']!,
            author: extra['author']!,
            date: extra['date']!,
            title: extra['title']!,
            content: extra['content']!,
          );
        } else {
          return const ErrorPage(
            message: 'Invalid data provided for Top Story Details Page.',
          );
        }
      },
    ),
    GoRoute(
      name: Routes.settings.name,
      path: Routes.settings.path,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      name: Routes.profile.name,
      path: Routes.profile.path,
      builder: (context, state) => const MyProfilePage(),
    ),
    GoRoute(
      name: Routes.account.name,
      path: Routes.account.path,
      builder: (context, state) => const AccountPage(),
    ),
    GoRoute(
      name: Routes.changeEmailAddress.name,
      path: Routes.changeEmailAddress.path,
      builder: (context, state) => const ChangeEmailAddressPage(),
    ),
    GoRoute(
      name: Routes.updatePassword.name,
      path: Routes.updatePassword.path,
      builder: (context, state) => const UpdatePasswordPage(),
    ),
    GoRoute(
      name: Routes.updateForgotPassword.name,
      path: Routes.updateForgotPassword.path,
      builder: (context, state) {
        // Extract token from query parameters if coming from deep link
        final token = state.uri.queryParameters['token'];
        return UpdateForgotPasswordPage(token: token);
      },
    ),
    GoRoute(
      name: Routes.checkYourEmail.name,
      path: Routes.checkYourEmail.path,
      builder: (context, state) => const CheckYourEmailPage(),
    ),
    GoRoute(
      name: Routes.forgotPassword.name,
      path: Routes.forgotPassword.path,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      name: Routes.themeMode.name,
      path: Routes.themeMode.path,
      builder: (context, state) => const ThemeModePage(),
    ),
    GoRoute(
      name: Routes.editProfile.name,
      path: Routes.editProfile.path,
      builder: (context, state) {
        final profile = state.extra as UserProfileEntity?;
        if (profile == null) {
          return const ErrorPage(message: 'Profile data is missing');
        }
        return EditProfilePage(profile: profile);
      },
    ),
    GoRoute(
      name: Routes.depositMoney.name,
      path: Routes.depositMoney.path,
      builder: (context, state) {
        final profile = state.extra as UserProfileEntity?;
        if (profile == null) {
          return const ErrorPage(message: 'Profile data is missing');
        }
        return DepositMoneyPage(profile: profile);
      },
    ),
    GoRoute(
      name: Routes.withdrawMoney.name,
      path: Routes.withdrawMoney.path,
      builder: (context, state) {
        final profile = state.extra as UserProfileDTO?;
        if (profile == null) {
          return const ErrorPage(message: 'Profile data is missing');
        }
        return WithdrawMoneyPage(profile: profile);
      },
    ),
    GoRoute(
      name: Routes.CreateLeague.name,
      path: Routes.CreateLeague.path,
      builder: (context, state) => const CreateLeagueFlow(),
    ),
    GoRoute(
      name: Routes.createLeagueLeagueAfterCompletion.name,
      path: Routes.createLeagueLeagueAfterCompletion.path,
      builder: (context, state) {
        final league = state.extra as LeagueDTO?;

        if (league == null) {
          return const ErrorPage(
            message: 'An error occurred: No league data was provided.',
          );
        }
        return CreateLeagueAfterCreationPage(createdLeague: league);
      },
    ),
    GoRoute(
      name: Routes.joinLeague.name,
      path: Routes.joinLeague.path,
      builder: (context, state) => const JoinLeaguePage(),
    ),
    GoRoute(
      name: Routes.chatRoomPage.name,
      path: Routes.chatRoomPage.path,
      builder: (context, state) {
        final chat = state.extra as GroupChat?;
        if (chat == null) {
          return const ErrorPage(message: 'Chat data is missing');
        }
        return ChatRoomPage(chat: chat);
      },
    ),
    GoRoute(
      name: Routes.leagueAdminPanel.name,
      path: Routes.leagueAdminPanel.path,
      builder: (context, state) {
        final leagueDetails = state.extra as LeagueDetails?;
        if (leagueDetails == null) {
          return const Scaffold(
            body: Center(
              child: Text('League details not provided'),
            ),
          );
        }
        return LeagueAdminPanel(
          leagueDetails: leagueDetails,
        );
      },
    ),
    GoRoute(
      name: Routes.allLeaguesHomepage.name,
      path: Routes.allLeaguesHomepage.path,
      builder: (context, state) => AllLeaguesHomepage(),
    ),
    GoRoute(
      name: Routes.allLeaguesHomepageListView.name,
      path: Routes.allLeaguesHomepageListView.path,
      builder: (context, state) {
        final args = state.extra as LeagueListPageArguments?;
        if (args == null) {
          return const ErrorPage(
            message: 'Failed to load leagues data.',
          );
        }
        return AllLeaguesHomepageListView(
          title: args.title,
          leaguesSummary: args.leagues,
        );
      },
    ),
    // Route for LeagueHomePage using LeagueDetailsArguments:
    GoRoute(
      name: Routes.leagueHome.name,
      path: Routes.leagueHome.path,
      builder: (context, state) {
        final args = state.extra as LeagueDetailsArguments?;
        if (args == null) {
          return const ErrorPage(
            message: 'No league data was provided to LeagueHomePage.',
          );
        }
        return LeagueHome(args: args);
      },
    ),
    // Route for LMSHomePage using LeagueDetailsArguments:
    GoRoute(
      name: Routes.lmsHome.name,
      path: Routes.lmsHome.path,
      builder: (context, state) {
        final league = state.extra as LeagueEntity?;
        if (league == null) {
          return const ErrorPage(
            message: 'No league data was provided to LMSPage.',
          );
        }
        return LMSHome(league: league);
      },
    ),
    GoRoute(
      name: Routes.LmsRulesPage.name, // "LmsRulesPage"
      path: Routes.LmsRulesPage.path, // /LmsRulesPage
      builder: (context, state) => const LmsRulesPage(),
    ),

    GoRoute(
      name: Routes.currentMatchesPage.name,
      path: Routes.currentMatchesPage.path,
      builder: (context, state) {
        if (state.extra is LeagueDetails) {
          final leagueDetails = state.extra as LeagueDetails;
          return CurrentMatchesPage(leagueDetails: leagueDetails);
        } else {
          return const ErrorPage(message: 'Invalid data passed to this page');
        }
      },
    ),
    GoRoute(
      name: Routes.lmsCurrentMatchesPage.name,
      path: Routes.lmsCurrentMatchesPage.path,
      builder: (context, state) {
        if (state.extra is LmsGameDetails) {
          final lmsGameDetails = state.extra as LmsGameDetails;
          return LmsCurrentMatchesPage(lmsGameDetails: lmsGameDetails);
        } else {
          return const ErrorPage(message: 'Invalid data passed to this page');
        }
      },
    ),
    GoRoute(
      name: Routes.viewMembersSelections.name,
      path: Routes.viewMembersSelections.path,
      builder: (context, state) {
        if (state.extra is LeagueDetails) {
          final leagueDetails = state.extra as LeagueDetails;
          return MembersSelectionPage(leagueDetails: leagueDetails);
        } else {
          return const ErrorPage(message: 'Invalid data passed to this page');
        }
      },
    ),
    GoRoute(
      name: Routes.lmsSelectionsTable.name,
      path: Routes.lmsSelectionsTable.path,
      builder: (context, state) {
        if (state.extra is LmsGameDetails) {
          final lmsGameDetails = state.extra as LmsGameDetails;
          return LmsSelectionsTable(lmsGameDetails: lmsGameDetails);
        } else {
          return const ErrorPage(message: 'Invalid data passed to this page');
        }
      },
    ),
    GoRoute(
      name: Routes.roundsPage.name,
      path: Routes.roundsPage.path,
      builder: (context, state) {
        final lmsGameDetails = state.extra as LmsGameDetails?;
        if (lmsGameDetails == null) {
          return const ErrorPage(
            message: 'No league data provided for Rounds Page.',
          );
        }
        return RoundsPage(lmsGameDetails: lmsGameDetails);
      },
    ),
    GoRoute(
      name: Routes.postsPage.name,
      path: Routes.postsPage.path,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is List<Map<String, String>>) {
          return AllPostsPage(posts: extra);
        } else {
          return const ErrorPage(
            message: 'Invalid or missing posts data for Posts Page.',
          );
        }
      },
    ),
    GoRoute(
      name: Routes.headToHeadHomePage.name,
      path: Routes.headToHeadHomePage.path,
      builder: (context, state) {
        final league = state.extra as LeagueEntity?;
        if (league == null) {
          return const ErrorPage(
            message: 'No league data was provided to LMSPage.',
          );
        }
        return HeadToHeadHome(league: league);
      },
    ),
  ],
);

// Arguments classes you can reuse in other files:
class LeagueListPageArguments {
  final String title;
  final List<LeagueSummary> leagues;

  LeagueListPageArguments({
    required this.title,
    required this.leagues,
  });
}

class LeagueDetailsArguments {
  final LeagueEntity league;

  LeagueDetailsArguments({
    required this.league,
  });
}

class preLeagueDetailsArguments {
  final LeagueEntity league;

  preLeagueDetailsArguments({
    required this.league,
  });
}

class LeagueViewSelectionsArguments {
  final LeagueDetails leagueDetails;

  LeagueViewSelectionsArguments({required this.leagueDetails});
}
