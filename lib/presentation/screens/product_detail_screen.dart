import 'package:flutter/material.dart';
import 'package:e_commerce/data/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../configs/size_config.dart';
import '../../constants/api.dart';
import '../../cubits/cubits.dart';
import '../widgets/widgets.dart';
import 'package:babylonjs_viewer/babylonjs_viewer.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFullScreen = false;

  void _toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    SizeConfig().init(context);

    return BlocProvider(
      create: (context) => ProductDetailCubit(),
      child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          context
              .read<ProductDetailCubit>()
              .getProductById(widget.product.productId);
          final product = state.productDetail;

          if (product == null) {
            return Scaffold(
                appBar: AppBar(),
                body: const Center(child: CircularProgressIndicator()));
          }
          String modelURL =
              baseUrlStatic + product.model.model.replaceAll('\\', '/');
          modelURL =
              'https://modelviewer.dev/shared-assets/models/Astronaut.glb';
          if (product.name == "Boom Box") {
            modelURL = 'https://models.babylonjs.com/boombox.glb';
          }
          String profileURL = baseUrlStatic +
              (product.user.picture?.replaceAll('\\', '/') ?? '');
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: !isFullScreen
                ? AppBar(
                    leadingWidth: 50,
                    title: Text(
                      product.name,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    actions: const [
                      CartButton(),
                    ],
                  )
                : null,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: !isFullScreen
                              ? SizeConfig.screenHeight * 0.45
                              : SizeConfig.screenHeight,
                          width: double.infinity,
                          child: BabylonJSViewer(
                            src: modelURL,
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              onPressed: () {
                                _toggleFullScreen();
                              },
                              padding: EdgeInsets.zero,
                              iconSize: 27,
                              icon: !isFullScreen
                                  ? const Icon(Icons.fullscreen)
                                  : const Icon(Icons.fullscreen_exit),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  !isFullScreen
                      ? Expanded(
                          flex: 4,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        ?.copyWith(
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                  SizedBox(
                                      height: SizeConfig.screenHeight * 0.005),
                                  Text(
                                    "฿${product.price}",
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                  const Divider(
                                    color: Colors.black12,
                                  ),
                                  Row(
                                    children: [
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          minWidth: 46,
                                          minHeight: 46,
                                          maxWidth: 46,
                                          maxHeight: 46,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image(
                                            image: NetworkImage(profileURL),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              SizeConfig.screenWidth * 0.023),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.user.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                          SizedBox(
                                              height: SizeConfig.screenHeight *
                                                  0.005),
                                          Text(
                                            "ออนไลน์",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "ดูร้านค้า",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.black12,
                                  ),
                                  Text(
                                    "รายละเอียดสินค้า",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  SizedBox(
                                      height: SizeConfig.screenHeight * 0.005),
                                  Text(
                                    product.details,
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            bottomNavigationBar: !isFullScreen
                ? Container(
                    padding: const EdgeInsets.all(14),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            height: getProportionateScreenHeight(50),
                            width: getProportionateScreenWidth(50),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: const Icon(Icons.favorite_border),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: SizedBox(
                              height: getProportionateScreenHeight(50),
                              child: ElevatedButton(
                                onPressed: () {
                                  cartCubit.addToCart(
                                      productId: product.productId);
                                },
                                child: const Text(
                                  "เพิ่มลงตะกร้า",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}
