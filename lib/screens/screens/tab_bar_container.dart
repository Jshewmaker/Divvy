import 'package:divvy/Screens/tab_bar/blocs/blocs.dart';
import 'package:divvy/Screens/tab_bar/models/models.dart';
import 'package:divvy/Screens/tab_bar/widgets/widgets.dart';
import 'package:divvy/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:divvy/Screens/tab_bar/widgets/invoices.dart';
import 'package:divvy/Screens/tab_bar/widgets/project_screen.dart';
import 'package:divvy/screens/tab_bar/widgets/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TabBloc(),
      child: TabBarContainer(),
    );
  }
}

class TabBarContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            // title: Text(FlutterBlocLocalizations.of(context).appTitle),
            title: Text(tabTitle(activeTab.index),
                style: GoogleFonts.bigShouldersDisplay(
                    textStyle: TextStyle(fontSize: 32))),
            actions: [
              IconButton(
                key: const Key('homePage_logout_iconButton'),
                icon: const Icon(Icons.more_vert),
                onPressed: () => context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested()),
              ),
            ],
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
      return 'Invoices';
    } else if (activeTab == 2) {
      return 'Wallet';
    } else if (activeTab == 3) {
      return 'Account';
    }
    return "";
  }

  Widget activeTabFunction(activeTab) {
    if (activeTab == AppTab.project) return ProjectScreen();
    if (activeTab == AppTab.invoices) return InvoiceScreen();
    if (activeTab == AppTab.wallet) return WalletScreen();
    if (activeTab == AppTab.account) return AccountScreen();
    return Container();
  }
}
