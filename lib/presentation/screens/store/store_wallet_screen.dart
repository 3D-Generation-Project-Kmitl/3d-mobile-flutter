import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:marketplace/cubits/cubits.dart';
import 'package:marketplace/routes/screens_routes.dart';

import '../../../configs/size_config.dart';

class StoreWalletScreen extends StatelessWidget {
  const StoreWalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title:
            Text("รายรับของฉัน", style: Theme.of(context).textTheme.headline2),
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
                                    style:
                                        Theme.of(context).textTheme.headline5),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.025,
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
                      height: SizeConfig.screenHeight * 0.015,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 120,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            side: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, storeWithdrawRoute);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.attach_money,
                                color: Theme.of(context).primaryColor,
                              ),
                              Text(
                                "ถอนเงิน",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                        color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.01,
                    ),
                    Text("รายการล่าสุด",
                        style: Theme.of(context).textTheme.bodyText2),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.005,
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<WalletCubit>().getWallet();
                        },
                        child: ListView.builder(
                          itemCount: state.wallet.walletTransactions.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0),
                                    title: state
                                                .wallet
                                                .walletTransactions[index]
                                                .type ==
                                            "ORDER"
                                        ? Text(
                                            "ขายสินค้า",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          )
                                        : Text(
                                            (() {
                                              if (state
                                                      .wallet
                                                      .walletTransactions[index]
                                                      .status ==
                                                  "PENDING") {
                                                return "ถอนเงิน (รอดำเนินการ)";
                                              } else if (state
                                                      .wallet
                                                      .walletTransactions[index]
                                                      .status ==
                                                  "REJECTED") {
                                                return "ถอนเงิน (ไม่อนุมัติ)";
                                              }
                                              return "ถอนเงิน (สำเร็จ)";
                                            })(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                    subtitle: Text(
                                      intl.DateFormat('dd/MM/yyyy HH:mm')
                                          .format(state
                                              .wallet
                                              .walletTransactions[index]
                                              .createdAt
                                              .toLocal()),
                                    ),
                                    trailing: state
                                                .wallet
                                                .walletTransactions[index]
                                                .type ==
                                            "ORDER"
                                        ? Text(
                                            "+ ${intl.NumberFormat.currency(
                                              locale: 'th',
                                              symbol: '',
                                              decimalDigits: 0,
                                            ).format(state.wallet.walletTransactions[index].amountMoney)} บาท",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3!
                                                .copyWith(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          )
                                        : Text(
                                            "- ${intl.NumberFormat.currency(
                                              locale: 'th',
                                              symbol: '',
                                              decimalDigits: 0,
                                            ).format(state.wallet.walletTransactions[index].amountMoney)} บาท",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3!
                                                .copyWith(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          )),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
