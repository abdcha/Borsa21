import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:central_borssa/data/model/Post/GetPost.dart';
import 'package:central_borssa/data/repositroy/PostRepository.dart';
import 'package:central_borssa/presentation/Home/All_post.dart';
import 'package:equatable/equatable.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostRepository postRepository;
  PostBloc(PostInitial postInitial, this.postRepository) : super(PostInitial());

  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    if (event is InitialPostEvent) {
      yield PostInitial();
    } else if (event is AddNewPost) {
      yield PostLoadingInProgress();
      var addNewPostResponse =
          await postRepository.addNewPost(event.body, event.image);
      yield* addNewPostResponse.fold((l) async* {
        yield PostsLoadingError();
      }, (r) async* {
        yield AddPostSuccess();
      });
    } else if (event is GetAllPost) {
      print('from bloc');
      yield PostLoadingInProgress();
      var getAllPostResponse =
          await postRepository.getAllPost(event.page, event.countItemPerpage);
      yield* getAllPostResponse.fold((l) async* {
        yield PostsLoadingError();
      }, (r) async* {
        yield PostsLoadedSuccess(posts: r);
      });
    } else if (event is GetPostByCityName) {
      yield GetPostByCityNameLoading();
      var getAllPostResponse = await postRepository.getAllPostByCityName(
          event.postscityId, event.sortby, event.page, event.countItemPerpage);

      yield* getAllPostResponse.fold((l) async* {
        yield GetPostByCityNameError();
      }, (r) async* {
        yield GetPostByCityNameLoaded(posts: r);
      });
    }
  }
}
