import 'package:divvy/screens/sign_up/view/homeowner/sign_up_page.dart';
import 'package:divvy/sila/blocs/create_user/create_sila_user.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:divvy/screens/screens/tab_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

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

              return Center(child: CircularProgressIndicator());
            }),
          ),
        ),
      ),
    );
  }
}