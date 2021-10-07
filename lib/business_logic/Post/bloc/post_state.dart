part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostsLoadingError extends PostState {}

class PostsLoadedSuccess extends PostState {
  late final PostGet posts;
  PostsLoadedSuccess({
    required this.posts,
  });
}

//Get Post By City Name Start

class GetPostByCityNameLoading extends PostState {}

class GetPostByCityNameError extends PostState {}

class GetPostByCityNameLoaded extends PostState {
  late final PostGet posts;
  GetPostByCityNameLoaded({
    required this.posts,
  });
}

//Get Post By City Name End

class PostLoadingInProgress extends PostState {}

class AddPostSuccess extends PostState {}

//Edit Post Start

class EditPostLoading extends PostState {}

class EditPostError extends PostState {}

class EditPostLoaded extends PostState {
  late final String status;
  EditPostLoaded({
    required this.status,
  });
}

//Delete Post

class DeletePostLoading extends PostState {}

class DeletePostError extends PostState {}

class DeletePostLoaded extends PostState {
  late final String status;
  DeletePostLoaded({
    required this.status,
  });
}
