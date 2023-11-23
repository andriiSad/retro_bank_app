import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:retro_bank_app/core/common/widgets/app_svg_button.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/core/extensions/date_time_extension.dart';
import 'package:retro_bank_app/core/res/media_resources.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';
import 'package:retro_bank_app/src/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:retro_bank_app/src/transactions/domain/entities/transaction.dart';

class TransactionsListView extends StatelessWidget {
  const TransactionsListView({
    super.key,
    this.transactions,
  });

  final List<Transaction>? transactions;

  @override
  Widget build(BuildContext context) {
    return transactions == null || transactions!.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 70),
            child: Center(
              child: Text(
                'No transactions yet',
                style:
                    context.textTheme.bodyMedium!.copyWith(color: Colors.grey),
              ),
            ),
          )
        : Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                final currentTransactionDate =
                    transactions![index].transactionDate;
                final previousTransactionDate =
                    transactions![index + 1].transactionDate;

                final isSameDay =
                    currentTransactionDate.day == previousTransactionDate.day;

                if (!isSameDay) {
                  final formattedDate = '${previousTransactionDate.day} '
                      '${previousTransactionDate.monthName} '
                      '${previousTransactionDate.year}';
                  return Center(
                    child: Text(
                      formattedDate,
                      style: context.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
              itemCount: transactions!.length,
              itemBuilder: (_, index) {
                final transaction = transactions![index];
                final isIncome = transaction.receiverCardOwnerId ==
                    context.userProvider.user!.id;

                return FutureBuilder<LocalUserModel?>(
                  future: DashBoardUtils.getUser(
                    isIncome
                        ? transaction.senderCardOwnerId
                        : transaction.receiverCardOwnerId,
                  ),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<LocalUserModel?> snapshot,
                  ) {
                    final secondUser = snapshot.data;
                    return Column(
                      children: [
                        const Gap(5),
                        if (index == 0)
                          Text(
                            transaction.transactionDate.day ==
                                    DateTime.now().day
                                ? 'Today'
                                : '${transaction.transactionDate.day} '
                                    '${transaction.transactionDate.monthName} '
                                    '${transaction.transactionDate.year}',
                            style: context.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          )
                        else
                          Container(),
                        const Gap(10),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: AppSvgButton(
                            path: secondUser?.photoUrl ?? MediaRes.robotAvatar,
                            isNetwork: secondUser?.photoUrl != null,
                          ),
                          title: Text(
                            secondUser?.username ?? '',
                            style: context.textTheme.bodyLarge,
                          ),
                          subtitle: Text(
                            'Money Transfer',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.titleSmall!
                                .copyWith(color: Colors.grey[600]),
                          ),
                          trailing: Text(
                            '\$ ${transaction.amount}',
                            style: context.textTheme.bodyLarge!.copyWith(
                              color: isIncome ? Colors.green : Colors.red,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
  }
}
