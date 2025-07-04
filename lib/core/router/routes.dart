import 'package:panna_app/features/leagues/lms_game/presentation/page/lms_selections_table.dart';

enum Routes {
  initial(
    name: "initial",
    path: "/",
  ),
  loginOrSignup(
    name: "loginOrSignup",
    path: "/loginOrSignup",
  ),
  login(
    name: "login",
    path: "/login",
  ),

  chatRoom(
    name: "chatRoom",
    path: "/chatRoom",
  ),

  signUp(
    name: "signup",
    path: "/signUp",
  ),
  signupExtraDetails(
    name: "signupExtraDetails",
    path: "/signupExtraDetails",
  ),
  home(
    name: "home",
    path: "/home",
  ),
  feedback(name: 'feedback', path: '/feedback'),
  help(name: 'help', path: '/help'),
  topStoryDetails(name: 'topStoryDetails', path: '/topStoryDetails'),
  articleDetails(name: 'articleDetails', path: '/articleDetails'),
  articleHalfDetails(name: 'articleHalfDetails', path: '/articleHalfDetails'),
  settings(
    name: "settings",
    path: "/settings",
  ),
  account(
    name: "account",
    path: "/account",
  ),
  profile(
    name: "profiles",
    path: "/profiles",
  ),
  changeEmailAddress(
    name: "changeEmailAddress",
    path: "/changeEmailAddress",
  ),
  updatePassword(
    name: 'updatePassword',
    path: '/updatePassword',
  ),
  updateForgotPassword(
    name: 'updateForgotPassword',
    path: '/updateForgotPassword',
  ),
  checkYourEmail(
    name: 'checkYourEmail',
    path: '/check-your-email',
  ),
  forgotPassword(
    name: "forgotPassword",
    path: "/forgotPassword",
  ),
  themeMode(
    name: "themeMode",
    path: "/themeMode",
  ),
  editProfile(
    name: "editProfile",
    path: "/editProfile",
  ),
  depositMoney(name: "depositMoney", path: "/depositMoney"),
  withdrawMoney(name: "withdrawMoney", path: "/withdrawMoney"),
  chatRoomPage(name: "chatRoomPage", path: "/chatRoomPage"),
  joinLeague(name: 'joinLeague', path: '/joinLeague'),
  CreateLeague(name: 'createLeague', path: '/createLeague'),
  createLeagueLeagueAfterCompletion(
    name: 'createLeagueLeagueAfterCompletion',
    path: '/createLeagueLeagueAfterCompletion',
  ),
  allLeaguesHomepage(
    name: 'allLeaguesHomepage',
    path: '/allLeaguesHomepage',
  ),
  payBuyInPage(
    name: 'payBuyInPage',
    path: '/payBuyInPage',
  ),
  confirmJoinLeaguePage(
    name: 'confirmJoinLeaguePage',
    path: '/confirmJoinLeaguePage',
  ),
  leagueAdminPanel(
    name: 'leagueAdminePanel',
    path: '/leagueAdminPanel',
  ),
  allLeaguesHomepageListView(
    name: 'allLeaguesHomepageListView',
    path: '/allLeaguesHomepageListView',
  ),
  lmsHome(
    name: 'lmsHome',
    path: '/lmsHome',
  ),
  LmsRulesPage(
    name: 'LmsRulesPage',
    path: '/LmsRulesPage',
  ),
  leagueHome(
    name: 'leagueHome',
    path: '/leagueHome',
  ),
  roundsPage(
    name: 'roundsPage',
    path: '/roundsPage',
  ),
  postsPage(
    name: 'postsPage',
    path: '/postsPage',
  ),
  currentMatchesPage(
    name: 'currentMatchesPage',
    path: '/currentMatchesPage',
  ),
  lmsCurrentMatchesPage(
    name: 'lmsCurrentMatchesPage',
    path: '/lmsCurrentMatchesPage',
  ),
  viewMembersSelections(
    name: 'viewMembersSelections',
    path: '/viewMembersSelections',
  ),
  lmsSelectionsTable(
    name: 'lmsSelectionsTable',
    path: '/lmsSelectionsTable',
  ),
  headToHeadHomePage(name: 'headToHeadHomePage', path: '/headToHeadHomePage');

  const Routes({
    required this.path,
    required this.name,
  });

  final String path;
  final String name;
}
