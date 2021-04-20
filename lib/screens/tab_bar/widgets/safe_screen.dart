import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/sign_up/kyc/sign_up/address_screen.dart';
import 'package:divvy/screens/tab_bar/widgets/wallet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SafeScreen extends StatefulWidget {
  @override
  State<SafeScreen> createState() => _SafeScreenState();
}

class _SafeScreenState extends State<SafeScreen> {
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);
    if (user.kyc_status == 'passed') {
      return WalletScreen();
    } else {
      return AddressScreen();
    }
  }
}
