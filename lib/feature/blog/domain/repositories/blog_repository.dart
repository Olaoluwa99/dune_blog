import 'dart:io';

import 'package:dune_blog/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/blog.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });

  Future<Either<Failure, List<Blog>>> getAllBlogs();
}
