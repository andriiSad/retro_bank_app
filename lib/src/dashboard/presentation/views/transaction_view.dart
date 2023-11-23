import 'package:flutter/material.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/src/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:retro_bank_app/src/dashboard/presentation/widgets/transactions_list_view.dart';
import 'package:retro_bank_app/src/transactions/data/models/transaction_model.dart';

class TransActionsView extends StatelessWidget {
  const TransActionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            StreamBuilder<List<TransactionModel>>(
              stream: DashBoardUtils.transactionsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  context.transactionsProvider.transactions = snapshot.data;
                }
                final transactions = context.transactionsProvider.transactions;
                return TransactionsListView(
                  transactions: transactions,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
