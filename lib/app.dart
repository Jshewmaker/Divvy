import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/login/login.dart';
import 'package:divvy/screens/screens/account/create_sila_user_screen.dart';
import 'package:divvy/screens/screens/tab_bar_container.dart';
import 'package:divvy/screens/sign_up/view/contractor/admin/sign_up_business_admin_page.dart';
import 'package:divvy/screens/sign_up/view/homeowner/sila_info/user_personal_info_screen.dart';
import 'package:divvy/sila/blocs/blocs.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:divvy/authentication/authentication.dart';
import 'package:divvy/splash/splash.dart';
import 'package:divvy/theme.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
    @required this.silaRepository,
  })  : assert(authenticationRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;
  final SilaRepository silaRepository;

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
            create: (_) => CheckHandleBloc(
              silaRepository: silaRepository,
            ),
          ),
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
                var user1 = context.read<UserModelProvider>();
                user1.add(state.user);
                UserModel user = state.user;

                if (user == null)
                  _navigator.push(MaterialPageRoute(
                      builder: (context) => EnterSilaDataScreen()));
                if (!user.isHomeowner && user.businessAdminDocumentID == null) {
                  _navigator.pushAndRemoveUntil(
                      SignUpBusinessAdminPage.route(), (route) => false);
                } else if (user.isHomeowner && user.silaHandle == null) {
                  _navigator.push(CreateSilaUserScreen.route());
                } else {
                  _navigator.pushAndRemoveUntil<void>(
                    HomeScreen.route(),
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
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
