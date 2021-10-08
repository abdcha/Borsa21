import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:central_borssa/data/model/Post/Cities.dart';
import 'package:central_borssa/data/model/Post/GetPost.dart';
import 'package:central_borssa/data/repositroy/PostRepository.dart';
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
      var addNewPostResponse =
          await postRepository.addNewPost(event.body, event.image);
      yield* addNewPostResponse.fold((l) async* {
        print('from here');
        yield PostsLoadingError();
      }, (r) async* {
        yield PostLoadingInProgress();
        yield AddPostSuccess();
      });
    } else if (event is GetAllPost) {
      yield PostLoadingInProgress();

      var getAllPostResponse =
          await postRepository.getAllPost(event.page, event.countItemPerpage);
      yield* getAllPostResponse.fold((l) async* {
        yield PostsLoadingError();
      }, (r) async* {
        yield PostsLoadedSuccess(posts: r);
      });
    } else if (event is GetPostByCityName) {
      var getAllPostResponse = await postRepository.getAllPostByCityName(
          event.postscityName,
          event.sortby,
          event.page,
          event.countItemPerpage);
      yield* getAllPostResponse.fold((l) async* {
        yield GetPostByCityNameError();
      }, (r) async* {
        yield GetPostByCityNameLoading();
        yield GetPostByCityNameLoaded(posts: r);
      });
    } else if (event is UpdatePost) {
      var getAllPostResponse =
          await postRepository.editPost(event.body, event.image, event.id);
      yield* getAllPostResponse.fold((l) async* {
        yield EditPostError();
      }, (r) async* {
        yield EditPostLoading();
        yield EditPostLoaded(status: r);
      });
    } else if (event is DeletePost) {
      var getAllPostResponse = await postRepository.deletePost(event.id);

      yield* getAllPostResponse.fold((l) async* {
        yield DeletePostError();
      }, (r) async* {
        yield DeletePostLoading();
        yield DeletePostLoaded(status: r);
      });
    }
  }
}
