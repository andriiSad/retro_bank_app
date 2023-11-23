import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:retro_bank_app/core/common/app/providers/cards_provider.dart';
import 'package:retro_bank_app/core/common/widgets/app_text_button.dart';
import 'package:retro_bank_app/core/enums/credit_card_type.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/core/extensions/credit_card_extension.dart';
import 'package:retro_bank_app/core/utils/core_utils.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';
import 'package:retro_bank_app/src/auth/domain/entities/credit_card.dart';
import 'package:retro_bank_app/src/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:retro_bank_app/src/transactions/presentation/bloc/transactions_bloc.dart';

class SendMoneyView extends StatefulWidget {
  const SendMoneyView({super.key});

  @override
  State<SendMoneyView> createState() => _SendMoneyViewState();
}

class _SendMoneyViewState extends State<SendMoneyView> {
  late final TextEditingController _amountController;
  CreditCard? selectedSenderCard;
  CreditCard? selectedReceiverCard;
  LocalUserModel? selectedReceiver;
  List<CreditCard>? receiverCards;
  int? amount;
  double fee = 0;

  @override
  void initState() {
    _amountController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void refreshData() {
    setState(() {
      selectedReceiverCard = null;
      selectedReceiver = null;
      receiverCards = null;
      amount = null;
      _amountController.text = '';
      fee = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CardsProvider>(
      builder: (__, cardsProvider, _) {
        if (cardsProvider.cards == null) {
          return const CircularProgressIndicator(
            color: Colors.grey,
          );
        }
        final senderCards = cardsProvider.cards!;
        selectedSenderCard ??= senderCards[1];
        fee = selectedSenderCard!.type == CreditCardType.platinum ? 0 : 0.05;
        return Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            title: const Text('Send Money'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: BlocConsumer<TransactionsBloc, TransactionsState>(
            listener: (_, state) {
              if (state is TransactionAdded) {
                refreshData();
                CoreUtils.showSnackBar(context, 'Money successfully sent');
              }
              if (state is TransactionsError) {
                refreshData();
                CoreUtils.showSnackBar(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is TransactionPending) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                );
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Text(
                      'Select your card',
                      style: context.textTheme.titleMedium,
                    ),
                    const Gap(10),
                    DropdownSearch<CreditCard>(
                      items: senderCards,
                      selectedItem: selectedSenderCard,
                      dropdownBuilder: (_, selectedItem) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(selectedItem!.cardId),
                              Text(selectedItem.type.toStringValue()),
                              Text('\$${selectedItem.balance}'),
                            ],
                          ),
                        );
                      },
                      compareFn: (item1, item2) => item1 == item2,
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        menuProps: MenuProps(
                          backgroundColor: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        fit: FlexFit.loose,
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          fillColor: Colors.grey[100],
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      itemAsString: (card) => '${card.cardId}'
                          ' ${card.type.toStringValue()}'
                          ' \$${card.balance}',
                      onChanged: (value) {
                        print('Selected sender card: $value');

                        setState(() {
                          selectedSenderCard = value;
                          fee = selectedSenderCard!.type ==
                                  CreditCardType.platinum
                              ? 0
                              : 0.05;
                        });
                      },
                    ),
                    const Gap(10),
                    const Gap(10),
                    Text(
                      'Select receiver',
                      style: context.textTheme.titleMedium,
                    ),
                    const Gap(10),
                    DropdownSearch<LocalUserModel>(
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          fillColor: Colors.grey[100],
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      compareFn: (item1, item2) => item1 == item2,
                      popupProps: PopupProps.menu(
                        searchFieldProps: TextFieldProps(
                          controller: _amountController,
                        ),
                        showSelectedItems: true,
                        menuProps: MenuProps(
                          backgroundColor: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        fit: FlexFit.loose,
                      ),
                      asyncItems: (String filter) async {
                        return DashBoardUtils.getUsersByUsername('');
                      },
                      itemAsString: (item) => item.username,
                      onChanged: (value) async {
                        receiverCards = await DashBoardUtils.getCardsByOwnerId(
                          value!.id,
                        );
                        selectedReceiverCard =
                            receiverCards != null && receiverCards!.isNotEmpty
                                ? receiverCards![0]
                                : null;
                        setState(() {
                          selectedReceiver = value;
                        });
                      },
                    ),
                    const Gap(10),
                    if (receiverCards != null)
                      Text(
                        'Select receiver card',
                        style: context.textTheme.titleMedium,
                      ),
                    const Gap(10),
                    if (selectedReceiver != null)
                      DropdownSearch<CreditCard>(
                        items: receiverCards!,
                        selectedItem: selectedReceiverCard,
                        dropdownBuilder: (_, selectedItem) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child:
                                Text('**** **** **** ${selectedItem?.cardId}'),
                          );
                        },
                        compareFn: (item1, item2) => item1 == item2,
                        popupProps: PopupProps.menu(
                          showSelectedItems: true,
                          menuProps: MenuProps(
                            backgroundColor: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          fit: FlexFit.loose,
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            fillColor: Colors.grey[100],
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        itemAsString: (card) => '**** **** **** ${card.cardId}',
                        onChanged: (value) {
                          setState(() {
                            selectedReceiverCard = value;
                          });
                        },
                      ),
                    const Gap(10),
                    Text(
                      'Enter amount',
                      style: context.textTheme.titleMedium,
                    ),
                    const Gap(10),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          amount = int.tryParse(value);
                        });
                      },
                      decoration: InputDecoration(
                        prefixText: r'$ ',
                        fillColor: Colors.grey[100],
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors
                                .red, // Change border color to red for errors
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        // Use a regular expression to ensure the input contains only digits
                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                          return 'Invalid amount';
                        }
                        final amount = int.parse(value);
                        if (amount > selectedSenderCard!.balance) {
                          return 'Amount is too high';
                        }
                        return null;
                      },
                    ),
                    const Gap(10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: [
                          Text(
                            'Commision: ${fee * 100}%',
                          ),
                          if (fee != 0 && amount != null)
                            Text(
                              '(\$${(amount! * fee).round()})',
                            )
                          else
                            const Text(''),
                        ],
                      ),
                    ),
                    const Gap(10),
                    if (amount != null &&
                        selectedReceiverCard != null &&
                        selectedSenderCard != null)
                      AppTextButton(
                        text: 'Pay \$ ${(amount! * (1 + fee)).round()}',
                        onPressed: () {
                          context.read<TransactionsBloc>().add(
                                AddTransactionEvent(
                                  amount: amount!,
                                  receiverCardId:
                                      int.parse(selectedReceiverCard!.cardId),
                                  senderCardId:
                                      int.parse(selectedSenderCard!.cardId),
                                ),
                              );
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
