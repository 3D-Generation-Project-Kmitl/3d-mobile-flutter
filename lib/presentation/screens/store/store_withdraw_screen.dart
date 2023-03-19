import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:marketplace/cubits/cubits.dart';

import '../../../configs/size_config.dart';

class StoreWithdrawScreen extends StatefulWidget {
  const StoreWithdrawScreen({Key? key}) : super(key: key);

  @override
  State<StoreWithdrawScreen> createState() => _StoreWithdrawScreenState();
}

class _StoreWithdrawScreenState extends State<StoreWithdrawScreen> {
  late CurrencyTextInputFormatter _priceFormatter;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    _priceFormatter = CurrencyTextInputFormatter(
        locale: 'th', symbol: '฿', decimalDigits: 0, enableNegative: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final identity = context.read<IdentityCubit>().state as IdentityLoaded;
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text("ถอนเงิน", style: Theme.of(context).textTheme.headline2),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            if (state is WalletInitial) {
              context.read<WalletCubit>().getWallet();
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WalletLoaded) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Form(
                  key: _keyForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Text(" ยอดเงินคงเหลือ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.015,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  intl.NumberFormat.currency(
                                    locale: 'th',
                                    symbol: '฿',
                                    decimalDigits: 0,
                                  ).format(state.wallet.balance),
                                  style: Theme.of(context).textTheme.headline1),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.04,
                      ),
                      buildBankNameFormField(identity.identity!.bankName),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      buildBankAccountFormField(identity.identity!.bankAccount),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      buildPriceFormField(state.wallet.balance),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        " ระบุจำนวนเงินในการถอน 1,000 - 100,000 บาท",
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: getProportionateScreenHeight(50),
          child: ElevatedButton(
            onPressed: () {
              if (_keyForm.currentState!.validate()) {
                context
                    .read<WalletCubit>()
                    .withdraw(
                        amount: _priceFormatter.getUnformattedValue() as int)
                    .then((value) => Navigator.pop(context));
              }
            },
            child: const Text("ยืนยัน"),
          ),
        ),
      ),
    );
  }

  Widget buildBankNameFormField(String bankName) {
    return TextFormField(
      readOnly: true,
      initialValue: bankName,
      style: Theme.of(context).textTheme.headline5,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: const InputDecoration(
        labelText: "ธนาคาร",
      ),
    );
  }

  Widget buildBankAccountFormField(String bankAccount) {
    return TextFormField(
      readOnly: true,
      initialValue: bankAccount,
      style: Theme.of(context).textTheme.headline5,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: const InputDecoration(
        labelText: "เลขบัญชีธนาคาร",
      ),
    );
  }

  Widget buildPriceFormField(int balance) {
    return TextFormField(
      inputFormatters: [_priceFormatter],
      validator: (value) {
        if (value!.isEmpty) {
          return "กรุณากรอกจำนวนเงิน";
        } else {
          int amount = int.parse(value.replaceAll(RegExp(r'[^0-9]'), ''));
          if (amount < 1000) {
            return "จำนวนเงินต้องไม่น้อยกว่า 1,000 บาท";
          } else if (amount > 100000) {
            return "จำนวนเงินต้องไม่เกิน 100,000 บาท";
          } else if (amount > balance) {
            return "จำนวนเงินไม่เพียงพอ";
          }
        }
        return null;
      },
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.headline5,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: const InputDecoration(
        labelText: "จำนวนเงิน",
      ),
    );
  }
}
