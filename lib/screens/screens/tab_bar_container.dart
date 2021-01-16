import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/Screens/tab_bar/blocs/blocs.dart';
import 'package:divvy/Screens/tab_bar/models/models.dart';
import 'package:divvy/Screens/tab_bar/widgets/widgets.dart';
import 'package:divvy/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:divvy/screens/tab_bar/widgets/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;
  const HomeScreen({Key key, this.user}) : super(key: key);

  static Route route(UserModel user) {
    return MaterialPageRoute<void>(
        builder: (_) => HomeScreen(
              user: user,
            ));
  }

  @override
  Widget build(BuildContext context) {
    FirebaseService firebaseService = FirebaseService();
    return BlocProvider(
        create: (BuildContext context) => TabBloc(),
        child: MultiProvider(
          providers: [
            StreamProvider<UserModel>(
              initialData: user,
              create: (context) => firebaseService.streamRealtimeUser(user.id),
            ),
          ],
          child: TabBarContainer(),
        ));
  }
}

class TabBarContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            // title: Text(FlutterBlocLocalizations.of(context).appTitle),
            title: Text(
              tabTitle(activeTab.index),
            ),
          ),
          body: activeTabFunction(activeTab),
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) =>
                BlocProvider.of<TabBloc>(context).add(TabUpdated(tab)),
          ),
        );
      },
    );
  }

  String tabTitle(int activeTab) {
    if (activeTab == 0) {
      return 'Project';
    } else if (activeTab == 1) {
      return 'Transactions';
    } else if (activeTab == 2) {
      return 'Divvy Digital Safe';
    } else if (activeTab == 3) {
      return 'Account';
    }
    return "";
  }

  Widget activeTabFunction(activeTab) {
    if (activeTab == AppTab.project) return ProjectScreen();
    if (activeTab == AppTab.transactions) return TransactionsScreen();
    if (activeTab == AppTab.wallet) return WalletScreen();
    if (activeTab == AppTab.account) return AccountScreen();
    return Container();
  }
}
