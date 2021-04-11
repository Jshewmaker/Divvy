import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/bloc/project/project_bloc.dart';
import 'package:divvy/screens/login/login.dart';
import 'package:divvy/screens/screens/tab_bar_container.dart';
import 'package:divvy/screens/sign_up/view/contractor/admin/business_admin_signup_page_1.dart';
import 'package:divvy/screens/sign_up/view/homeowner_or_business.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:divvy/authentication/authentication.dart';
import 'package:divvy/splash/splash.dart';
import 'package:divvy/theme.dart';

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
    @required this.silaRepository,
    @required this.firebaseService,
  })  : assert(authenticationRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;
  final SilaRepository silaRepository;
  final FirebaseService firebaseService;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: authenticationRepository,
        child: MultiBlocProvider(providers: [
          BlocProvider(
            create: (_) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider(
              create: (context) =>
                  ProjectBloc(firebaseService: firebaseService)),
        ], child: AppView()));
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  UserModel user;
  FirebaseService firebaseService = FirebaseService();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              switch (state.status) {
                case AuthenticationStatus.authenticated:
                  UserModel user = state.user;

                  if (user == null)
                    _navigator.pushReplacement(MaterialPageRoute(
                        builder: (context) => HomeownerOrBusinessScreen()));
                  else if (!user.isHomeowner &&
                      user.businessAdminDocumentID == null) {
                    _navigator.pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => BusinessAdminSignupPage1()),
                        (route) => false);
                  } else if (!user.isHomeowner &&
                      (user.kyc_status == 'failed' ||
                          user.kyc_status == null)) {
                    _navigator.push(HomeownerOrBusinessScreen.route());
                  } else if (user.isHomeowner && user.silaHandle == "") {
                    _navigator.push(HomeownerOrBusinessScreen.route());
                  } else if (user.isHomeowner && user.kyc_status == 'failed') {
                    _navigator.push(HomeownerOrBusinessScreen.route());
                  } else {
                    _navigator.pushAndRemoveUntil<void>(
                      HomeScreen.route(user),
                      (route) => false,
                    );
                  }

                  break;
                case AuthenticationStatus.unauthenticated:
                  _navigator.pushAndRemoveUntil<void>(
                    LoginPage.route(),
                    (route) => false,
                  );
                  break;
                default:
                  break;
              }
            },
            child: child);
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
