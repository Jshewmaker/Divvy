import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/blocs/update_address/update_address.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class UpdateAddressScreen extends StatelessWidget {
  final TextEditingController _streetAddressController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));
  bool _validate = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateAddressBloc(silaRepository: silaRepository),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Divvy'),
        ),
        body: Center(
          child: BlocBuilder<UpdateAddressBloc, UpdateAddressState>(
            builder: (context, state) {
              if (state is UpdateAddressInitial) {
                return ListView(
                  children: [
                    _streetAddressInput(),
                    const SizedBox(height: 8.0),
                    _cityInput(),
                    const SizedBox(height: 8.0),
                    _stateInput(),
                    const SizedBox(height: 8.0),
                    _countryInput(),
                    const SizedBox(height: 8.0),
                    _postalCodeInput(),
                    RaisedButton(
                        child: Text('update'),
                        onPressed: () async {
                          Map<String, String> address = {
                            "street_address_1": _streetAddressController.text,
                            "street_address_2": "",
                            "city": _cityController.text,
                            "state": _stateController.text,
                            "country": _countryController.text,
                            "postal_code": _postalCodeController.text
                          };
                          BlocProvider.of<UpdateAddressBloc>(context)
                              .add(UpdateAddressRequest(address: address));
                        })
                  ],
                );
              }
              if (state is UpdateAddressLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is UpdateAddressLoadSuccess) {
                final apiResponse = state.response;
                FirebaseService _firebaseService = FirebaseService();

                Map<String, String> addressFirebase = {
                  "streetAddress": _streetAddressController.text,
                  "city": _cityController.text,
                  "state": _stateController.text,
                  "country": _countryController.text,
                  "postalCode": _postalCodeController.text
                };
                _firebaseService.addDataToFirestoreDocument(
                    'users', addressFirebase);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(apiResponse.message),
                  ],
                );
              }
              if (state is UpdateAddressLoadFailure) {
                return Text(
                  'Something went wrong!',
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

  Widget _streetAddressInput() {
    return TextField(
      controller: _streetAddressController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Street Address',
        hintText: '111 River Lane',
        errorText: _validate ? 'Street Required' : null,
      ),
      keyboardType: TextInputType.streetAddress,
    );
  }

  Widget _cityInput() {
    return TextField(
      controller: _cityController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'City',
        hintText: 'Dallas',
        errorText: _validate ? 'City Required' : null,
      ),
    );
  }

  Widget _stateInput() {
    return TextField(
      controller: _stateController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'State',
        hintText: 'TX',
        errorText: _validate ? 'State Required' : null,
      ),
    );
  }

  Widget _countryInput() {
    return TextField(
      controller: _countryController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Country',
        hintText: 'US',
        errorText: _validate ? 'Country Required' : null,
      ),
    );
  }

  Widget _postalCodeInput() {
    return TextField(
      controller: _postalCodeController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Zip Code',
        hintText: '75001',
        errorText: _validate ? 'Zip Code Required' : null,
      ),
      keyboardType: TextInputType.number,
    );
  }
}
