import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:divvy/tab_bar/models/models.dart';



class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  TabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.blue,
      type: BottomNavigationBarType.fixed,
      currentIndex: AppTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(AppTab.values[index]),
      items: AppTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: icon(tab),
          label: label(tab),
        );
      }).toList(),
    );
  }

  String label(tab) {
    if (tab == AppTab.home)
      return 'home';
    else if (tab == AppTab.project)
      return 'project';
    else if (tab == AppTab.invoices)
      return 'invoices';
    else if (tab == AppTab.account) return 'account';
    return "";
  }

  Widget icon(tab) {
    if (tab == AppTab.home)
      return Icon(Icons.home);
    else if (tab == AppTab.project)
      return Icon(Icons.list);
    else if (tab == AppTab.invoices)
      return Icon(Icons.attach_money);
    else if (tab == AppTab.account) return Icon(Icons.person);
    return Icon(Icons.ac_unit);
  }
}
