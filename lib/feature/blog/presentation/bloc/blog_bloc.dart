import 'dart:io';

import 'package:dune_blog/core/usecases/usecase.dart';
import 'package:dune_blog/feature/blog/domain/useCases/get_all_blogs.dart';
import 'package:dune_blog/feature/blog/domain/useCases/upload_blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({required UploadBlog uploadBlog, required GetAllBlogs getAllBlogs})
    : _uploadBlog = uploadBlog,
      _getAllBlogs = getAllBlogs,
      super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlocGetAllBlogs>(_onGetAllBlogs);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final response = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );
    response.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _onGetAllBlogs(BlocGetAllBlogs event, Emitter<BlogState> emit) async {
    final response = await _getAllBlogs(NoParams());
    response.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogRetrieveSuccess(r)),
    );
  }
}
