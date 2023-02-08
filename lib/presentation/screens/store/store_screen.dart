import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/cubits/cubits.dart';

import '../../../configs/size_config.dart';
import '../../../routes/screens_routes.dart';
import '../../widgets/widgets.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title:
            Text("ร้านค้าของฉัน", style: Theme.of(context).textTheme.headline2),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoaded) {
              final user = state.user;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ImageCard(imageURL: user.picture ?? ""),
                          SizedBox(width: SizeConfig.screenWidth * 0.05),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name,
                                  style: Theme.of(context).textTheme.headline3),
                              SizedBox(height: SizeConfig.screenHeight * 0.005),
                              Text(
                                user.email,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.01,
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.2),
                        thickness: 0.5,
                        height: 20,
                      ),
                      _buildStoreCard(
                        context,
                        "สินค้าของฉัน",
                        () {
                          print("สินค้าของฉัน");
                        },
                      ),
                      _buildStoreCard(
                        context,
                        "โมเดล 3 มิติของฉัน",
                        () {
                          Navigator.pushNamed(context, storeModelRoute);
                        },
                      ),
                      _buildStoreCard(
                        context,
                        "รายรับของฉัน",
                        () {
                          print("รายการขายของฉัน");
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildStoreCard(
      BuildContext context, String title, void Function()? onTap) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: 4),
        onTap: onTap,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
          size: 20,
        ),
      ),
    );
  }
}
