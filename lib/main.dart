import 'package:colon_app/bloc_observer.dart';
import 'package:colon_app/controllers/menu_app_controller.dart';
import 'package:colon_app/features/auth/presentation/manager/reset_cubit/reset_cubit.dart';
import 'package:colon_app/features/patient_tracking/presentation/manager/cubit/patient_tracking_cubit.dart';
import 'package:colon_app/features/tumor_marker/presentation/manager/cubit/tumor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants.dart';
import 'core/utlis/app_router.dart';
import 'core/utlis/service_locator.dart';
import 'features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'features/endoscopy/presentation/manager/cubit/endoscopy_cubit.dart';
import 'features/forum/presentation/manager/cubit/patient_cubit.dart';
import 'features/histopathology/presentation/manager/cubit/histopathology_cubit.dart';
import 'features/news/data/repos/news_repo_impl.dart';
import 'features/news/presentation/manager/news_cubit/news_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://yrgwcqigxvexercvhhzr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlyZ3djcWlneHZleGVyY3ZoaHpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODIwMTUwNzUsImV4cCI6MTk5NzU5MTA3NX0.n1jvJ8k-pUZtdA9OzrRyNBcJQ_FheFMoNTud3aBVK2Q',
  );
  setupServiceLocator();
  Bloc.observer = MyBlocObserver();
  runApp(const ColonCancerApp());
}

class ColonCancerApp extends StatelessWidget {
  const ColonCancerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                NewsCubit(getIt.get<NewsRepoImpl>())..fetchNews()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => PatientCubit()),
        BlocProvider(create: (context) => EndoscopyCubit()),
        BlocProvider(create: (context) => HistopathologyCubit()),
        BlocProvider(create: (context) => ResetCubit()),
        BlocProvider(create: (context) => TumorCubit()),
        BlocProvider(create: (context) => PatientTrackingCubit()),
      ],
      child: ChangeNotifierProvider(
        create: (BuildContext context) => MenuAppController(),
        child: MaterialApp.router(
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: kPrimaryColor,
            appBarTheme: const AppBarTheme(
              foregroundColor: kTextColor,
              elevation: 1.0,
              backgroundColor: Colors.white,
              scrolledUnderElevation: 2.0,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
