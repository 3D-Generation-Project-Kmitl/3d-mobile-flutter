import 'package:dio/dio.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/dio_client.dart';

class WalletRepository {
  Future<Wallet> getWallet() async {
    try {
      final response = await DioClient().dio.get('/wallet');
      final data = BaseResponse.fromJson(response.data).data;
      final wallet = Wallet.fromJson(data);
      return wallet;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<WalletTransaction> withdraw({required int amount}) async {
    try {
      final response = await DioClient().dio.post('/wallet/withdraw', data: {
        'amount': amount,
      });
      final data = BaseResponse.fromJson(response.data).data;
      final walletTransaction = WalletTransaction.fromJson(data);
      return walletTransaction;
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
