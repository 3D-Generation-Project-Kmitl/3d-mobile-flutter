import 'package:marketplace/cubits/cubits.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/routes/screens_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/size_config.dart';

class CustomerModelScreen extends StatelessWidget {
  const CustomerModelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenWidth;
    return BlocProvider(
      create: (context) => ModelsCubit(),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 20,
          title: Text("โมเดล 3 มิติของฉัน",
              style: Theme.of(context).textTheme.headline2),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: BlocBuilder<ModelsCubit, ModelsState>(
            builder: (context, state) {
              if (state is ModelsInitial) {
                context.read<ModelsCubit>().getModelsCustomer();
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ModelsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ModelsLoaded) {
                if (state.models.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Text(
                        'ไม่มีโมเดล 3 มิติ',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: _modelList(state.models, width),
                  );
                }
              } else {
                return const Center(
                  child: Text('Error'),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _modelList(List<Model> models, double width) {
    return GridView.builder(
      itemCount: models.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 14,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final model = models[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, viewModelRoute, arguments: model);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image(
              image: NetworkImage(model.picture),
              fit: BoxFit.cover,
              height: width * 0.54,
              width: double.infinity,
            ),
          ),
        );
      },
    );
  }
}
