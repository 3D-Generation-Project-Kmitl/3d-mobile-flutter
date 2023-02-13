import 'package:flutter/material.dart';

import '../../../configs/size_config.dart';

class StoreProductScreen extends StatelessWidget {
  const StoreProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 20,
          title: Text("สินค้าของฉัน",
              style: Theme.of(context).textTheme.headline2),
          bottom: TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Theme.of(context).primaryColor,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: Theme.of(context).textTheme.bodyText1,
            tabs: const [
              Tab(text: "ขายอยู่"),
              Tab(text: "ไม่แสดง"),
              Tab(text: "ละเมิด"),
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: const SafeArea(
          child: TabBarView(
            children: [
              Center(child: Text("ขายอยู่")),
              Center(child: Text("ไม่แสดง")),
              Center(child: Text("ละเมิด")),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: getProportionateScreenHeight(50),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("เพิ่มสินค้า"),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProductCard() {
    return Row(
      children: [],
    );
  }
}
