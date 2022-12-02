import 'package:flutter/material.dart';
import 'package:e_commerce/data/models/models.dart';
import '../../configs/size_config.dart';
import '../../constants/api.dart';
import '../widgets/widgets.dart';
import 'package:babylonjs_viewer/babylonjs_viewer.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    String modelURL = baseUrlStatic + product.model.model.replaceAll('\\', '/');
    modelURL = 'https://modelviewer.dev/shared-assets/models/Astronaut.glb';
    if (product.name == "Boom Box") {
      modelURL = 'https://models.babylonjs.com/boombox.glb';
    }

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        actions: const [
          CartButton(),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: SizeConfig.screenHeight * 0.45,
              width: double.infinity,
              child: BabylonJSViewer(
                src: modelURL,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Text(
                    "฿ ${product.price}",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const Divider(
                    color: Colors.black12,
                    height: 25,
                  ),
                  Text(
                    "รายละเอียดสินค้า",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.005),
                  Text(
                    product.details,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
                    onPressed: () {},
                    child: const Text(
                      "เพิ่มลงตะกร้า",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
