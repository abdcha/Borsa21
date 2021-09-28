part of 'company_bloc.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();

  @override
  List<Object> get props => [];
}

class InitialCompanyEvent extends CompanyEvent {}

class GetAllCompanyInformationsEvent extends CompanyEvent {
  late final int id;
  late final int pageSize;
  late final String date;
  late final int page;

  GetAllCompanyInformationsEvent({
    required this.id,
    required this.pageSize,
    required this.date,
    required this.page,
  });
}

class FollowEvent extends CompanyEvent {
  late final int id;
  FollowEvent({
    required this.id,
  });
}
