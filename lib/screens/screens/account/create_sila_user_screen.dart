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
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (contest) => HomeScreen()));
              }
            },
            child: BlocBuilder<CreateSilaUserBloc, CreateSilaUserState>(
                builder: (context, state) {
              if (state is CreateSilaUserInitial || state is HandleTaken) {
                BlocProvider.of<CreateSilaUserBloc>(context)
                    .add(CreateSilaUserRequest(handle: _textController.text));
              }
              /*
                  if (state is CheckHandleLoadInProgress) {
                    //return Center(child: CircularProgressIndicator());
                  }

                  if (state is CheckHandleSuccess) {
                    return Text(
                      'Valid Handle!',
                      style: TextStyle(color: Colors.red),
                    );
                    //final apiResponse = state.checkHandle;

                    /*
                     return Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Text(apiResponse.message),
                         RaisedButton(
                           child: Text('Continue'),
                           onPressed: () => Navigator.of(context).push(
                               MaterialPageRoute(
                                   builder: (contest) => RegisterHandleScreenState(
                                       handle: _textController.text))),
                         ),
                       ],
                     );
                     */
                  }
                  */

              if (state is CheckHandleLoadFailure ||
                  state is RegisterLoadFailure) {
                return Text(
                  state.message,
                  style: TextStyle(color: Colors.red),
                );
              }

              /*
                  if (state is RegisterLoadInProgress) {
                    return Text(
                      "Registering your account",
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  */

              /*
                  if (state is CheckKycPending) {
                    return Text(
                      "KYC Pending",
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  */

              if (state is CheckKycLoadFailure) {
                return Text(
                  "KYC Failure",
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
