import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/repository.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportInitial());

  final ReportRepository reportRepository = ReportRepository();

  Future<void> createReportProduct(int productId, String detail) async {
    try {
      emit(ReportLoading());
      await reportRepository.createReportProduct(productId, detail);
      emit(ReportLoaded());
    } on Exception catch (e) {
      emit(ReportFailure(e.toString()));
    }
  }
}
