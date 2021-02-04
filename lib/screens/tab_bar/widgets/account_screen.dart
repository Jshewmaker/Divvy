import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:divvy/screens/screens/conected_projects_screen.dart';
import 'package:divvy/screens/screens/connect_to_project.dart';
import 'package:divvy/screens/screens/contact_divvy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  static const Color blueHighlight = const Color(0xFF3665FF);

  @override
  Widget build(BuildContext context) {
    UserModel user;
    try {
      user = (Provider.of<UserModel>(context) == null)
          ? UserModel.empty
          : Provider.of<UserModel>(context);
    } catch (_) {
      user = UserModel.empty;
    }
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          RichText(
            text: new TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: new TextStyle(
                fontSize: 25.0,
                color: Colors.black45,
              ),
              children: <TextSpan>[
                new TextSpan(text: 'Hello '),
                new TextSpan(
                    text: '${user.name}!',
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, color: blueHighlight)),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // RaisedButton(
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(30.0),
          //   ),
          //   color: Colors.teal[200],
          //   child: Text('Account'),
          //   onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          //       builder: (contest) => AccountOptionsScreen())),
          // ),
          // RaisedButton(
          //   child: Text('Select Username'),
          //   onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          //       builder: (contest) => RegisterHandleScreen())),
          // ),
          // RaisedButton(
          //   child: Text('get balance'),
          //   onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          //       builder: (contest) => GetWalletInfoScreen())),
          // ),

          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.teal[200],
            child: Text('Connect Project'),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (contest) => ConnectToProject(user))),
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.teal[200],
            child: Text('Contact Divvy'),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (contest) => ContactDivvyScreen())),
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.teal[200],
            child: Text('Log Out'),
            onPressed: () => context
                .read<AuthenticationBloc>()
                .add(AuthenticationLogoutRequested()),
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.teal[200],
            child: Text('View Projects'),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (contest) => ConnectedProjectsScreen(user: user))),
          ),
          // RaisedButton(
          //   child: Text('Issue Sila'),
          //   onPressed: () => Navigator.of(context).push(
          //       MaterialPageRoute(builder: (contest) => IssueSilaScreen())),
          // ),
          // RaisedButton(
          //   child: Text('Get Transactions'),
          //   onPressed: () => Navigator.of(context).push(
          //       MaterialPageRoute(builder: (contest) => TransactionScreen())),
          // ),
          // RaisedButton(
          //   child: Text('Link Plaid'),
          //   onPressed: () => Navigator.of(context).push(
          //       MaterialPageRoute(builder: (contest) => PlaidLinkScreen())),
          // ),
        ],
      )),
    );
  }
}
