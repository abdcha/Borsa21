import 'package:central_borssa/business_logic/Company/bloc/company_state.dart';
import 'package:central_borssa/business_logic/Company/bloc/company_event.dart';
import 'package:central_borssa/data/repositroy/CompanyRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      yield GetAllInformationLoading();
      var getAllCompanyInformationsResponse = await companyRepository
          .getAllCompanypost(event.id, event.pageSize, event.date, event.page);
      yield* getAllCompanyInformationsResponse.fold((l) async* {
        yield GetAllInformationError();
      }, (r) async* {
        yield GetAllInformationLoaded(data: r);
      });
    } else if (event is GetAllCompanies) {
      yield CompanyNameIsLodaing();
      var getAllCompanyInformationsResponse =
          await companyRepository.getAllCompanyName();
      yield* getAllCompanyInformationsResponse.fold((l) async* {
        yield CompanyNameError();
      }, (r) async* {
        yield CompanyNameIsLoaded(companies: r);
      });
    } else if (event is FollowEvent) {
      yield FollowIsLoading();
      var getAllCompanyInformationsResponse =
          await companyRepository.follow(event.id);
      yield* getAllCompanyInformationsResponse.fold((l) async* {
        yield FollowError();
      }, (r) async* {
        yield FollowIsLoaded(status: r);
      });
    } else if (event is UnFollowEvent) {
      yield UnFollowIsLoading();
      var getAllCompanyInformationsResponse =
          await companyRepository.unFollow(event.id);
      yield* getAllCompanyInformationsResponse.fold((l) async* {
        yield UnFollowError();
      }, (r) async* {
        yield UnFollowIsLoaded(status: r);
      });
    } else if (event is UpdatePost) {
      yield EditPostLoading();
      var updatePostResponse =
          await companyRepository.editPost(event.body, event.image, event.id);
      yield* updatePostResponse.fold((l) async* {
        yield EditPostError();
      }, (r) async* {
        yield EditPostLoaded(status: r);
      });
    } else if (event is DeletePost) {
      yield DeletePostLoading();
      var deletePostResponse = await companyRepository.deletePost(event.id);
      yield* deletePostResponse.fold((l) async* {
        yield DeletePostError();
      }, (r) async* {
        yield DeletePostLoaded(status: r);
      });
    } else if (event is GetCompanyInfoEvent) {
      yield GetCompanyInfoLoading();
      var deletePostResponse = await companyRepository.getCompanyInfo(event.id);
      yield* deletePostResponse.fold((l) async* {
        yield GetCompanyInfoError();
      }, (r) async* {
        print('test');
        yield GetCompanyInfoLoaded(data: r);
      });
    }
  }
}
