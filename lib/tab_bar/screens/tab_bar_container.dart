import 'package:divvy/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:divvy/tab_bar/widgets/home_screen.dart';
import 'package:divvy/tab_bar/widgets/invoices.dart';
import 'package:divvy/tab_bar/widgets/project_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:divvy/tab_bar/blocs/blocs.dart';
import 'package:divvy/tab_bar/widgets/widgets.dart';
import 'package:divvy/tab_bar/models/models.dart';

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
            // title: Text(FlutterBlocLocalizations.of(context).appTitle),
            title: Text("Divvy"),
            actions: [
              IconButton(
                key: const Key('homePage_logout_iconButton'),
                icon: const Icon(Icons.more_vert),
                onPressed: () => context
                    .bloc<AuthenticationBloc>()
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

  Widget activeTabFunction(activeTab) {
    if (activeTab == AppTab.home) return PlaidLinkSplashScreen();
    if (activeTab == AppTab.project) return ProjectScreen();
    if (activeTab == AppTab.invoices) return InvoiceScreen();
    if (activeTab == AppTab.account) return AccountScreen();
    return Container();
  }
}
