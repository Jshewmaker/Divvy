import 'package:divvy/screens/screens/tab_bar_container.dart';
import 'package:divvy/sila/blocs/kyb_blocs/create_business/create_business.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class CreateSilaBusinessScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CreateSilaBusinessScreen());
  }

  final SilaBusinessRepository silaBusinessRepository = SilaBusinessRepository(
      silaApiClient: SilaApiClient(httpClient: http.Client()));

  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateSilaBusinessBloc(
          silaBusinessRepository: silaBusinessRepository,
          silaRepository: silaRepository),
      child: Scaffold(
        appBar: AppBar(
          title: Text('DivvySafe'),
        ),
        body: Center(
          child: BlocListener<CreateSilaBusinessBloc, CreateSilaBusinessState>(
            listener: (context, state) {
              if (state is CreateSilaBusinessSuccess) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (contest) => HomeScreen(user: state.user)),
                    (route) => false);
              }
            },
            child: BlocBuilder<CreateSilaBusinessBloc, CreateSilaBusinessState>(
                builder: (context, state) {
              if (state is CreateSilaBusinessInitial) {
                BlocProvider.of<CreateSilaBusinessBloc>(context)
                    .add(DivvyCheckForBusinessHandle());
              }

              //Business Sila Handle Creation + Registration
              else if (state is SilaBusinessHandleDoesNotExist ||
                  state is BusinessHandleTaken) {
                BlocProvider.of<CreateSilaBusinessBloc>(context)
                    .add(CreateBusinessHandle());
              } else if (state is CreateBusinessHandleSuccess) {
                BlocProvider.of<CreateSilaBusinessBloc>(context)
                    .add(SilaCheckBusinessHandle(handle: state.handle));
              } else if (state is CheckBusinessHandleSuccess) {
                BlocProvider.of<CreateSilaBusinessBloc>(context)
                    .add(SilaRegisterBusiness(handle: state.handle));
              } else if (state is RegisterBusinessFailure) {
                return Text(
                  "Register Business Failure" + state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              }

              //Admin Sila Handle Creation + Registration
              else if (state is SilaBusinessHandleExists ||
                  state is RegisterBusinessSuccess) {
                BlocProvider.of<CreateSilaBusinessBloc>(context)
                    .add(DivvyCheckForAdminHandle());
              } else if (state is SilaAdminHandleDoesNotExist ||
                  state is AdminHandleTaken) {
                BlocProvider.of<CreateSilaBusinessBloc>(context)
                    .add(CreateAdminHandle());
              } else if (state is CreateAdminHandleSuccess) {
                BlocProvider.of<CreateSilaBusinessBloc>(context)
                    .add(SilaCheckAdminHandle(handle: state.handle));
              } else if (state is CheckAdminHandleSuccess) {
                BlocProvider.of<CreateSilaBusinessBloc>(context)
                    .add(SilaRegisterAdmin(handle: state.handle));
              } else if (state is RegisterAdminFailure) {
                return Text(
                  "Check Kyb Failure" + state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              }

              //Link Business Members
              else if (state is SilaAdminHandleExists ||
                  state is RegisterAdminSuccess) {
                BlocProvider.of<CreateSilaBusinessBloc>(context)
                    .add(LinkBusinessMembers());
              } else if (state is LinkBusinessMembersFailure) {
                return Text(
                  "Link Business Members Failure" + state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              }

              //KYB Verification
              else if (state is LinkBusinessMembersSuccess) {
                BlocProvider.of<CreateSilaBusinessBloc>(context)
                    .add(RequestKYB());
              } else if (state is RequestKybSuccess) {
                BlocProvider.of<CreateSilaBusinessBloc>(context)
                    .add(CheckKYB());
              } else if (state is RequestKybFailure) {
                return Text(
                  "Request KYB Failure" + state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              } else if (state is CheckKybFailure) {
                return Text(
                  "Check Kyb Failure" + state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              } else if (state is CheckKybNotPassed) {
                return Text(
                  "Business did not pass KYB" +
                      state.checkKYBResponse.verificationHistory[0].tags[1],
                  style: TextStyle(color: Colors.red),
                );
              }

              //Certification
              else if (state is CheckKybSuccess) {
                BlocProvider.of<CreateSilaBusinessBloc>(context)
                    .add(CertifyBeneficialOwner());
              } else if (state is CertifyBeneficialOwnerSuccess) {
                BlocProvider.of<CreateSilaBusinessBloc>(context)
                    .add(CertifyBusiness());
              } else if (state is CertifyBeneficialOwnerFailure) {
                return Text(
                  "Certify Beneficial Owner Failure" +
                      state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              } else if (state is CertifyBusinessFailure) {
                return Text(
                  "Certify Business Failure" + state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              }

              return Center(child: CircularProgressIndicator());
            }),
          ),
        ),
      ),
    );
  }
}
