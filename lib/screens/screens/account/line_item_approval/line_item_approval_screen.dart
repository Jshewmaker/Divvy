import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divvy/screens/screens/account/line_item_approval/line_item_approval_widget.dart';
import 'package:divvy/screens/tab_bar/widgets/project_screen.dart';
import 'package:divvy/sila/blocs/transfer_sila/transfer_sila.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class LineItemInfoScreen extends StatelessWidget {
  LineItemInfoScreen(
    this.lineItem,
    this.project,
  );

  final LineItem lineItem;
  final Project project;

  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransferSilaBloc(silaRepository: silaRepository),
      child: LineItemApprovalWidget(lineItem, project),
    );
  }
}
