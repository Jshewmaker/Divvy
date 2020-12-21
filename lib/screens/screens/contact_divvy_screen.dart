import 'package:flutter/material.dart';

class ContactDivvyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Contact US'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Text('Phone: 123-123-1234'),
                // onPressed: UrlLauncher.launch("tel://<phone_number>"),
              ),
              Text('Email: info@divvy.com')
            ],
          ),
        ));
  }
}
