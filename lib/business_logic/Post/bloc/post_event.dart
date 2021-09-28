part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class InitialPostEvent extends PostEvent {}

class AddNewPost extends PostEvent {
  late final String body;
  late final String? image;
  AddNewPost({
    required this.body,
    required this.image,
  });
}

class UpdatePost extends PostEvent {
  late final int id;
  late final String body;
  late final String image;
  UpdatePost({
    required this.id,
    required this.body,
    required this.image,
  });
}

class DeletePost extends PostEvent {
  late final int id;
  DeletePost({
    required this.id,
  });
}

class GetAllPost extends PostEvent {
  late final int page;
  late final int CountItemPerpage;
  GetAllPost({
    required this.page,
    required this.CountItemPerpage,
  });
}
