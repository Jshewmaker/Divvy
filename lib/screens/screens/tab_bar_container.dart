import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/Screens/tab_bar/blocs/blocs.dart';
import 'package:divvy/Screens/tab_bar/models/models.dart';
import 'package:divvy/Screens/tab_bar/widgets/widgets.dart';
import 'package:divvy/screens/screens/conected_projects_screen.dart';
import 'package:divvy/screens/screens/connect_to_project.dart';
import 'package:divvy/screens/tab_bar/widgets/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    UserModel user;
    try {
      user = (Provider.of<UserModel>(context) == null)
          ? UserModel.empty
          : Provider.of<UserModel>(context);
    } catch (_) {
      user = UserModel.empty;
    }

    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            // title: Text(FlutterBlocLocalizations.of(context).appTitle),
            title: Text(
              appBarTitle(activeTab.index, user),
            ),
            actions: [
              Visibility(
                visible: user.isHomeowner == false,
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _settingModalBottomSheet(context, user),
                ),
              )
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
      return 'Transactions';
    } else if (activeTab == 2) {
      return 'Digital Safe';
    } else if (activeTab == 3) {
      return 'Account';
    }
    return "";
  }

  String appBarTitle(int activeTab, UserModel user) {
    if (activeTab == 0) {
      return '${user.projectName} Project';
    } else if (activeTab == 1) {
      return 'Transactions';
    } else if (activeTab == 2) {
      return 'Digital Safe';
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

  void _settingModalBottomSheet(context, UserModel user) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.add_circle),
                    title: new Text('Add New Project'),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (contest) => ConnectToProject(user)))),
                new ListTile(
                  leading: new Icon(Icons.carpenter_outlined),
                  title: new Text('View Your Projects'),
                  onTap: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (contest) =>
                            ConnectedProjectsScreen(user: user))),
                  },
                ),
                ListTile(),
              ],
            ),
          );
        });
  }
}
