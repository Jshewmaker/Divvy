import 'package:divvy/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:divvy/screens/custome_loading_indicator.dart';
import 'package:divvy/sila/blocs/create_user/create_sila_user.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:divvy/screens/screens/tab_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';

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
          title: Text('DivvySafe'),
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
                    MaterialPageRoute(
                        builder: (contest) => HomeScreen(
                              user: state.user,
                            )),
                    (route) => false);
              }
            },
            child: BlocBuilder<CreateSilaUserBloc, CreateSilaUserState>(
                builder: (context, state) {
              if (state is CreateSilaUserInitial) {
                BlocProvider.of<CreateSilaUserBloc>(context)
                    .add(DivvyCheckForHandle());
              } else if (state is SilaHandleExists) {
                BlocProvider.of<CreateSilaUserBloc>(context)
                    .add(SilaRequestKYC());
              } else if (state is SilaHandleDoesNotExist ||
                  state is HandleTaken) {
                BlocProvider.of<CreateSilaUserBloc>(context)
                    .add(CreateHandle());
              } else if (state is CreateHandleSuccess) {
                BlocProvider.of<CreateSilaUserBloc>(context)
                    .add(SilaCheckHandle(handle: state.handle));
              } else if (state is CheckHandleSuccess) {
                BlocProvider.of<CreateSilaUserBloc>(context)
                    .add(SilaRegisterHandle(handle: state.handle));
              } else if (state is RegisterSuccess) {
                BlocProvider.of<CreateSilaUserBloc>(context)
                    .add(SilaRequestKYC());
              } else if (state is RegisterFailure) {
                return Text(
                  "Reqgistration Failure: " + state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              } else if (state is RequestKYCSuccess) {
                BlocProvider.of<CreateSilaUserBloc>(context)
                    .add(SilaCheckKYC());
              } else if (state is RequestKYCFailure) {
                return Text(
                  "Request KYC Failure: " + state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              } else if (state is CheckKycVerifiationFail) {
                //TODO: put in list view for all tags to show
                return Text(
                  "KYC Failure: " +
                      state.checkKycResponse.verificationHistory[0].tags[1],
                  style: TextStyle(color: Colors.red),
                );
              } else if (state is CheckKycFailure) {
                return Text(
                  "KYC Failure: " + state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              }

              ////////////////////////////////////////////////////

              // if (state is GetUserDataForProvider) {
              //   //var userprovider = context.repository<UserModelProvider>();
              //   //userprovider.add(state.user);
              // }
              // if (state is CreateSilaUserInitial || state is HandleTaken) {
              //   BlocProvider.of<CreateSilaUserBloc>(context)
              //       .add(CreateSilaUserRequest(handle: _textController.text));
              // }

              // if (state is CheckHandleFailure || state is RegisterFailure) {
              //   return Text(
              //     "RegisterLoadFailure: " + state.toString(),
              //     style: TextStyle(color: Colors.red),
              //   );
              // }

              // if (state is CheckKycFailure) {
              //   return Text(
              //     "KYC Failure: " + state.exception,
              //     style: TextStyle(color: Colors.red),
              //   );
              // }
              // if (state is CheckKycVerifiationFail) {
              //   return Text(
              //     "KYC Failure: " +
              //         state.checkKycResponse.verificationHistory[0].tags[1],
              //     style: TextStyle(color: Colors.red),
              //   );
              // }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomProgressIndicator(),
                  _buildComplexMarquee(),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildComplexMarquee() {
    return ListView(
        shrinkWrap: true,
        children: [
          Marquee(
            text:
                'Creating Account.                                            Checking KYC.                                            Confirming Address.                                            ',
            style: TextStyle(fontWeight: FontWeight.bold),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            velocity: 40.0,
            pauseAfterRound: Duration(seconds: 0),
            showFadingOnlyWhenScrolling: true,
            fadingEdgeStartFraction: 0.5,
            fadingEdgeEndFraction: 0.5,
            numberOfRounds: 100,
            startPadding: 50.0,
            accelerationDuration: Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeIn,
          ),
        ].map(_wrapWithStuff).toList());
  }

  Widget _wrapWithStuff(Widget child) {
    return Padding(
      padding: EdgeInsets.all(100.0),
      child: Container(height: 50.0, width: 100, child: child),
    );
  }
}
