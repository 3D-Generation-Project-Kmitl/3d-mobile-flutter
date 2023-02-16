import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'my_store_product_state.dart';

class MyStoreProductCubit extends Cubit<MyStoreProductState> {
  MyStoreProductCubit() : super(MyStoreProductInitial());

  final ProductRepository productRepository = ProductRepository();
  final ModelRepository modelRepository = ModelRepository();

  Future<void> getMyProducts() async {
    try {
      emit(MyStoreProductLoading());
      final products = await productRepository.getMyProducts();
      emit(MyStoreProductLoaded(products));
    } on String catch (e) {
      emit(MyStoreProductFailure(e));
    }
  }

  List<Product> getProductByStatus(String status) {
    List<Product> products = [];
    if (state is MyStoreProductLoaded) {
      products = (state as MyStoreProductLoaded).products;
      products = products.where((element) => element.status == status).toList();
    }
    return products;
  }

  Future<void> addProductToStore({
    required String name,
    required String details,
    required int price,
    required int categoryId,
    required int modelId,
  }) async {
    try {
      late List<Product> products;
      if (state is MyStoreProductLoaded) {
        products = (state as MyStoreProductLoaded).products;
      } else {
        products = await productRepository.getMyProducts();
      }
      emit(MyStoreProductLoading());
      final product = await productRepository.createProduct(
          name: name,
          details: details,
          price: price,
          categoryId: categoryId,
          modelId: modelId);
      products.insert(0, product);
      emit(MyStoreProductLoaded(products));
    } on String catch (e) {
      emit(MyStoreProductFailure(e));
    }
  }

  Future<void> updateStatusProduct(int productId, String status) async {
    try {
      List<Product> products = [];
      if (state is MyStoreProductLoaded) {
        products = (state as MyStoreProductLoaded).products;
      }
      emit(MyStoreProductLoading());
      final product = await productRepository.updateStatusProduct(
          id: productId, status: status);
      products.firstWhere((element) => element.productId == productId).status =
          product.status;
      emit(MyStoreProductLoaded(products));
    } on String catch (e) {
      emit(MyStoreProductFailure(e));
    }
  }

  Future<void> updateProduct({
    required int productId,
    required String name,
    required String details,
    required int price,
    required int categoryId,
    required int modelId,
    File? file,
  }) async {
    try {
      List<Product> products = [];
      if (state is MyStoreProductLoaded) {
        products = (state as MyStoreProductLoaded).products;
      }
      emit(MyStoreProductLoading());
      if (file != null) {
        final formData = FormData.fromMap({
          'picture': await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last),
        });
        await modelRepository.updateModel(modelId, formData);
      }
      final product = await productRepository.updateProduct(
        id: productId,
        name: name,
        details: details,
        price: price,
        categoryId: categoryId,
      );
      int idx = products.indexOf(products.firstWhere(
        (element) => element.productId == productId,
      ));
      products[idx] = product;
      emit(MyStoreProductLoaded(products));
    } on String catch (e) {
      emit(MyStoreProductFailure(e));
    }
  }
}
