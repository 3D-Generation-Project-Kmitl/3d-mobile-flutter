import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/cubits.dart';

class IdentityScreen extends StatefulWidget {
  const IdentityScreen({Key? key}) : super(key: key);

  @override
  State<IdentityScreen> createState() => _IdentityScreenState();
}

class _IdentityScreenState extends State<IdentityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text("ลงทะเบียนร้านค้า",
            style: Theme.of(context).textTheme.headline2),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocBuilder<IdentityCubit, IdentityState>(
          builder: (context, state) {
            if (state is IdentityLoaded) {
              final identity = state.identity;
              if (identity == null) {
                return Center(
                  child: Text(
                    "ไม่มีข้อมูล",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    identity.firstName,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
