import 'package:colon_app/features/patient_tracking/presentation/views/patient_tracking_view.dart';
import 'package:colon_app/features/patient_tracking/presentation/views/widgets/add_patient_tracking.dart';
import 'package:go_router/go_router.dart';

import '../../check.dart';
import '../../check_internet.dart';
import '../../features/auth/presentation/views/auth_view.dart';
import '../../features/auth/presentation/views/widgets/forget_password.dart';
import '../../features/auth/presentation/views/widgets/login_screen.dart';
import '../../features/auth/presentation/views/widgets/signup_screen.dart';
import '../../features/endoscopy/presentation/views/endoscopy_view.dart';
import '../../features/forum/presentation/views/forum_view.dart';
import '../../features/gene_expression/presentation/views/gene_expression_view.dart';
import '../../features/histopathology/presentation/views/histopathology_view.dart';
import '../../features/news/presentation/views/news_view.dart';
import '../../features/onboarding/presentation/onboarding_view.dart';
import '../../features/records/presentation/views/records_view.dart';
import '../../features/records/presentation/views/widgets/search_record.dart';
import '../../features/tumor_marker/presentation/views/tumor_marker_view.dart';

abstract class AppRouter {
  static const kLayout = '/layout';

  static const kOnboardingView = '/onboardingview';
  static const kSplashView = '/splashview';
  static const kAuthView = '/authview';
  static const kLoginScreen = '/loginscreen';
  static const kSignpScreen = '/signupscreen';
  static const kNewsView = '/homeView';
  static const kEndoscopyView = '/endoscopyview';
  static const kHistopathologyView = '/histopathologyview';
  static const kRecordsView = '/recordsview';
  static const kForumView = '/forumview';
  static const kSearchScreen = '/searchscreen';
  static const kGeneExpressionView = '/geneexpressionview';
  static const kTumorMarkerView = '/tumormarkerview';
  static const kResetPasswordrView = '/resetpasswordview';
  static const kPhoneLoginView = '/phoneloginview';
  static const kPatientTrachingView = '/patienttrackingview';
  static const kAddPatientTrachingView = '/addpatienttrackingview';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const CheckInternet(),
      ),
      GoRoute(
        path: kSplashView,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: kNewsView,
        builder: (context, state) => const NewsView(),
      ),
      GoRoute(
        path: kEndoscopyView,
        builder: (context, state) => const EndoscopyView(),
      ),
      GoRoute(
        path: kHistopathologyView,
        builder: (context, state) => const HistopathologyView(),
      ),
      GoRoute(
        path: kRecordsView,
        builder: (context, state) => const RecordsView(),
      ),
      GoRoute(
        path: kForumView,
        builder: (context, state) => const ForumView(),
      ),
      GoRoute(
        path: kOnboardingView,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: kAuthView,
        builder: (context, state) => const AuthView(),
      ),
      GoRoute(
        path: kSignpScreen,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: kLoginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: kSearchScreen,
        builder: (context, state) => const PatientsList(),
      ),
      GoRoute(
        path: kGeneExpressionView,
        builder: (context, state) => const GeneExpressionView(),
      ),
      GoRoute(
        path: kTumorMarkerView,
        builder: (context, state) => const TumorMarkerView(),
      ),
      GoRoute(
        path: kResetPasswordrView,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: kPatientTrachingView,
        builder: (context, state) => const PatientTrackingView(),
      ),
      GoRoute(
        path: kAddPatientTrachingView,
        builder: (context, state) => const AddPatientTracking(),
      ),
    ],
  );
}
