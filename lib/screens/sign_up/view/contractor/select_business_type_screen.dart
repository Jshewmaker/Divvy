import 'package:divvy/screens/sign_up/view/contractor/naics_categories_screen.dart';
import 'package:divvy/sila/blocs/kyb_blocs/get_business_types/get_business_types_cubit.dart';
import 'package:divvy/sila/models/kyb/get_business_type_response.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class SelectBusinessTypeScreen extends StatelessWidget {
  SelectBusinessTypeScreen({Key key}) : super(key: key);

  final SilaBusinessRepository _silaBusinessRepository = SilaBusinessRepository(
      silaApiClient: SilaApiClient(httpClient: http.Client()));

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SelectBusinessTypeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BusinessTypeCubit(_silaBusinessRepository),
      child: BlocBuilder<BusinessTypeCubit, BusinessTypeState>(
        builder: (context, state) {
          if (state is BusinessTypeInitial) {
            context.watch<BusinessTypeCubit>().getBusinessTypes();
            return const BusinessTypeEmpty();
          } else if (state is BusinessTypeLoadInProgress) {
            return const BusinessTypeLoading();
          } else if (state is BusinessTypeLoadSuccess) {
            return BusinessTypePopulated(response: state.businessType);
          } else {
            return const BusinessTypeError();
          }
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class BusinessTypePopulated extends StatelessWidget {
  BusinessTypePopulated({Key key, @required this.response}) : super(key: key);

  final GetBusinessTypeResponse response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Business Type'),
      ),
      body: ListView.builder(
        itemCount: response.businessTypes.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Center(child: Text(response.businessTypes[index].label)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NAICSCategoryScreen(
                            response.businessTypes[index].name)));
              });
        },
      ),
    );
  }
}

class BusinessTypeEmpty extends StatelessWidget {
  const BusinessTypeEmpty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('No process running.'),
      ),
    );
  }
}

class BusinessTypeLoading extends StatelessWidget {
  const BusinessTypeLoading({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Process Loading.'),
      ),
    );
  }
}

class BusinessTypeError extends StatelessWidget {
  const BusinessTypeError({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          '🙈',
          style: TextStyle(fontSize: 64),
        ),
        Text(
          'Something went wrong!',
          style: theme.textTheme.headline5,
        ),
      ],
    );
  }
}
