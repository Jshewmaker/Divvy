import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/bloc/line_items/line_item_bloc.dart';
import 'package:divvy/bloc/line_items/line_item_event.dart';
import 'package:divvy/bloc/line_items/line_item_state.dart';
import 'package:divvy/screens/screens/invoice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceHelperScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();
  InvoiceHelperScreen(this.lineItemID);

  final String lineItemID;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LineItemBloc(firebaseService: _firebaseService),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<LineItemBloc, LineItemState>(
              builder: (context, state) {
            if (state is LineItemInitial) {
              BlocProvider.of<LineItemBloc>(context)
                  .add(LineItemRequestedForInvoice(lineItemID));
              return Container();
            }
            if (state is LineItemLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is LineItemForInvoiceLoadSuccess) {
              final LineItem lineItem = state.lineItem;
              final Project project = state.project;

              return InvoiceScreen(lineItem, project);
            }
            if (state is LineItemLoadFailure) {
              return Text(
                'Something went wrong with loading line items',
                style: TextStyle(color: Colors.red),
              );
            }
            return Container();
          }),
        ),
      ),
    );
  }
}
