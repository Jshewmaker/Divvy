import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:divvy/sila/blocs/create_user/create_sila_user.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:divvy/screens/screens/tab_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class CreateSilaUserScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CreateSilaUserScreen());
  }

  final TextEditingController _textController = TextEditingController();
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateSilaUserBloc(silaRepository: silaRepository),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Divvy'),
          actions: [
            IconButton(
              key: const Key('homePage_logout_iconButton'),
              icon: const Icon(Icons.more_vert),
              onPressed: () => context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested()),
            ),
          ],
        ),
        body: Center(
          child: BlocListener<CreateSilaUserBloc, CreateSilaUserState>(
            listener: (context, state) {
              if (state is CreateSilaUserSuccess) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (contest) => HomeScreen()),
                    (route) => false);
              }
            },
            child: BlocBuilder<CreateSilaUserBloc, CreateSilaUserState>(
                builder: (context, state) {
              if (state is GetUserDataForProvider) {
                var userprovider = context.repository<UserModelProvider>();
                userprovider.add(state.user);
              }
              if (state is CreateSilaUserInitial || state is HandleTaken) {
                BlocProvider.of<CreateSilaUserBloc>(context)
                    .add(CreateSilaUserRequest(handle: _textController.text));
              }

              if (state is CheckHandleLoadFailure ||
                  state is RegisterLoadFailure) {
                return Text(
                  "RegisterLoadFailure: " + state.toString(),
                  style: TextStyle(color: Colors.red),
                );
              }

              if (state is CheckKycLoadFailure) {
                return Text(
                  "KYC Failure: " + state.message,
                  style: TextStyle(color: Colors.red),
                );
              }

              return Center(child: MainPage());
            }),
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.rotate(
              angle: _controller.value * 4 * math.pi,
              child: child,
            );
          },
          child: Image.asset(
            'assets/divvy_logo.png',
            height: 120,
          ),
        ),
      ),
    );
  }
}
