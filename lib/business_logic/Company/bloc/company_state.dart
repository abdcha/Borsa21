part of 'company_bloc.dart';

abstract class CompanyState extends Equatable {
  const CompanyState();

  @override
  List<Object> get props => [];
}

class CompanyInitial extends CompanyState {}

class GetAllInformationLoading extends CompanyState {}

class GetAllInformationError extends CompanyState {}

class GetAllInformationLoaded extends CompanyState {
  late final Data data;
  GetAllInformationLoaded({
    required this.data,
  });
}

//Companies All
class CompanyNameIsLodaing extends CompanyState {}

class CompanyNameError extends CompanyState {}

class CompanyNameIsLoaded extends CompanyState {
  late final List<list> companies;
  CompanyNameIsLoaded({
    required this.companies,
  });
}

class FollowInProgress extends CompanyState {}

class FollowError extends CompanyState {}

class FollowIsDone extends CompanyState {}
