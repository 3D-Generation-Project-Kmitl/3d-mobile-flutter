import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/presentation/widgets/rounded_image_card_widget.dart';
import 'package:intl/intl.dart' as intl;
import '../../../configs/size_config.dart';
import '../../../cubits/cubits.dart';
import '../../helpers/helpers.dart';

class ReportScreen extends StatefulWidget {
  final ProductDetail product;
  const ReportScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late TextEditingController _descriptionController;
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
      create: (context) => ReportCubit(),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 20,
          title: Text("รายงานสินค้านี้",
              style: Theme.of(context).textTheme.headline2),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
          child: Form(
            key: _keyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(85),
                      width: getProportionateScreenWidth(85),
                      child: roundedImageCard(
                          imageURL: widget.product.model.picture),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          intl.NumberFormat.currency(
                            locale: 'th',
                            symbol: '฿',
                            decimalDigits: 0,
                          ).format(widget.product.price),
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  "รายละเอียดการรายงาน",
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 5),
                buildDescriptionFormField(),
              ],
            ),
          ),
        )),
        bottomNavigationBar: BlocBuilder<ReportCubit, ReportState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: getProportionateScreenHeight(50),
                child: ElevatedButton(
                  onPressed: () {
                    if (_keyForm.currentState!.validate()) {
                      context
                          .read<ReportCubit>()
                          .createReportProduct(widget.product.productId,
                              _descriptionController.text)
                          .then((value) => {
                                showInfoDialog(
                                  context,
                                  title: "รายงานสำเร็จ",
                                  delay: 1500,
                                ).then((value) => Navigator.pop(context))
                              });
                    }
                  },
                  child: const Text(
                    "รายงาน",
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildDescriptionFormField() {
    return TextFormField(
      controller: _descriptionController,
      validator: reportProblemValidator,
      keyboardType: TextInputType.name,
      style: Theme.of(context).textTheme.headline5,
      textAlignVertical: TextAlignVertical.bottom,
      minLines: 8,
      maxLines: 10,
    );
  }
}
