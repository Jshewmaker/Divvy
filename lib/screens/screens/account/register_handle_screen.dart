import 'package:divvy/sila/blocs/register/register.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class RegisterHandleScreenState extends StatelessWidget {
  final String handle;
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  RegisterHandleScreenState({Key key, @required this.handle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(silaRepository: silaRepository),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              if (state is RegisterInitial) {
                BlocProvider.of<RegisterBloc>(context)
                    .add(RegisterRequest(handle: handle));
                return Container();
              }
              if (state is RegisterLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is RegisterLoadSuccess) {
                final apiResponse = state.handle;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(apiResponse.message),
                  ],
                );
              }
              if (state is RegisterLoadFailure) {
                return Text(
                  'Something went wrong with registering!',
                  style: TextStyle(color: Colors.red),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
