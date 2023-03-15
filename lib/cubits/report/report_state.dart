part of 'report_cubit.dart';

abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {}

class ReportFailure extends ReportState {
  final String errorMessage;

  ReportFailure(this.errorMessage);
}
