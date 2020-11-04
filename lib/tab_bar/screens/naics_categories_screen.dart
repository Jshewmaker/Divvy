import 'package:divvy/sila/blocs/kyb_blocs/get_naics_categories/get_naics_categories_cubit.dart';
import 'package:divvy/sila/models/kyb/naics_categories_models/get_naics_categories_response.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class NAICSCategoryScreen extends StatelessWidget {
  NAICSCategoryScreen(this.businessType);

  final SilaBusinessRepository _silaBusinessRepository = SilaBusinessRepository(
      silaApiClient: SilaApiClient(httpClient: http.Client()));
  final String businessType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NaicsCategoriesCubit(_silaBusinessRepository),
      child: BlocBuilder<NaicsCategoriesCubit, NaicsCategoriesState>(
        builder: (context, state) {
          if (state is NaicsCategoriesInitial) {
            context.bloc<NaicsCategoriesCubit>().getNaicsCategories();
            return const NaicsCategoryEmpty();
          } else if (state is NaicsCategoriesLoadInProgress) {
            return const NaicsCategoryLoading();
          } else if (state is NaicsCategoriesLoadSuccess) {
            return NaicsCategoryPopulated(response: state.naicsCategories);
          } else {
            return const NaicsCategoryError();
          }
        },
      ),
    );
  }
}

class NaicsCategoryPopulated extends StatelessWidget {
  const NaicsCategoryPopulated({Key key, @required this.response})
      : super(key: key);

  final GetNaicsCategoriesResponse response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select NAICS Category'),
      ),
      body: ListView.builder(
        itemCount: response.naicsCategories.construction.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 1,
            child: ListTile(
                title: Center(
                    child: Text(response
                        .naicsCategories.construction[index].subcategory)),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NAICSCategoryScreen(''),
                    ))),
          );
        },
      ),
    );
  }
}

class NaicsCategoryEmpty extends StatelessWidget {
  const NaicsCategoryEmpty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('No process running.'),
      ),
    );
  }
}

class NaicsCategoryLoading extends StatelessWidget {
  const NaicsCategoryLoading({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Process Loading.'),
      ),
    );
  }
}

class NaicsCategoryError extends StatelessWidget {
  const NaicsCategoryError({Key key}) : super(key: key);

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
