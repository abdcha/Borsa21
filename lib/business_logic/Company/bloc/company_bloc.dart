import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:central_borssa/data/model/Post/Cities.dart';
import 'package:central_borssa/data/model/Post/CompanyPost.dart';
import 'package:central_borssa/data/repositroy/CompanyRepository.dart';
import 'package:equatable/equatable.dart';

part 'company_event.dart';
part 'company_state.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  CompanyRepository companyRepository;
  CompanyBloc(
    CompanyInitial companyInitial,
    this.companyRepository,
  ) : super(CompanyInitial());

  @override
  Stream<CompanyState> mapEventToState(
    CompanyEvent event,
  ) async* {
    if (event is InitialCompanyEvent) {
      yield CompanyInitial();
    } else if (event is GetAllCompanyInformationsEvent) {
      var getAllCompanyInformationsResponse = await companyRepository
          .getAllCompanypost(event.id, event.pageSize, event.date, event.page);
      yield* getAllCompanyInformationsResponse.fold((l) async* {
        yield GetAllInformationError();
      }, (r) async* {
        print('we are here');
        yield GetAllInformationLoading();
        yield GetAllInformationLoaded(data: r);
      });
    } else if (event is GetAllCompanies) {
      var getAllCompanyInformationsResponse =
          await companyRepository.getAllCompanyName();
      yield* getAllCompanyInformationsResponse.fold((l) async* {
        yield CompanyNameError();
      }, (r) async* {
        print('we are here');
        yield CompanyNameIsLodaing();
        yield CompanyNameIsLoaded(companies: r);
      });
    } else if (event is FollowEvent) {
      var getAllCompanyInformationsResponse =
          await companyRepository.Follow(event.id);
      yield* getAllCompanyInformationsResponse.fold((l) async* {
        yield FollowError();
      }, (r) async* {
        print('we are here');
        yield FollowIsLoading();
        yield FollowIsLoaded(status: r);
      });
    } else if (event is UnFollowEvent) {
      var getAllCompanyInformationsResponse =
          await companyRepository.UnFollow(event.id);
      yield* getAllCompanyInformationsResponse.fold((l) async* {
        yield UnFollowError();
      }, (r) async* {
        print('we are here');
        yield UnFollowIsLoading();
        yield UnFollowIsLoaded(status: r);
      });
    }
  }
}
