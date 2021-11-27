
import 'package:equatable/equatable.dart';

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

class GetCompanyInfoEvent extends CompanyEvent {
  late final int id;
  GetCompanyInfoEvent({
    required this.id,
  });
}

class GetAllCompanies extends CompanyEvent {}

class FollowEvent extends CompanyEvent {
  late final int id;
  FollowEvent({
    required this.id,
  });
}

class UnFollowEvent extends CompanyEvent {
  late final int id;
  UnFollowEvent({
    required this.id,
  });
}

class UpdatePost extends CompanyEvent {
  late final int id;
  late final String body;
  late final String image;
  UpdatePost({
    required this.id,
    required this.body,
    required this.image,
  });
}

class DeletePost extends CompanyEvent {
  late final int id;

  DeletePost({
    required this.id,
  });
}