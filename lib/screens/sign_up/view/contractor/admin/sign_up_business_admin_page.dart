import 'package:divvy/screens/sign_up/view/contractor/admin/sign_up_business_admin_form.dart';
import 'package:flutter/material.dart';

class SignUpBusinessAdminPage extends StatelessWidget {
  const SignUpBusinessAdminPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => const SignUpBusinessAdminPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homeowner Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SignUpBusinessAdminForm(),
      ),
    );
  }
}
