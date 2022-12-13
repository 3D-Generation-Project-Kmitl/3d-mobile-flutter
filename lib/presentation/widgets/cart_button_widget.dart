import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/colors.dart';
import '../../routes/screens_routes.dart';
import 'package:e_commerce/cubits/cubits.dart';

class CartButton extends StatelessWidget {
  const CartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            IconButton(
              onPressed: () {
                if (state.user != null) {
                  Navigator.pushNamed(context, cartRoute);
                } else {
                  Navigator.pushNamed(context, loginRoute);
                }
              },
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: primaryColor,
                size: 27,
              ),
            ),
          ],
        );
      },
    );
  }
}
