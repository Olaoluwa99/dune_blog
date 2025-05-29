import 'package:dune_blog/core/error/failure.dart';
import 'package:dune_blog/core/usecases/usecase.dart';
import 'package:dune_blog/feature/blog/domain/entities/blog.dart';
import 'package:dune_blog/feature/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogs implements UserCase<List<Blog>, NoParams> {
  final BlogRepository blogRepository;
  GetAllBlogs(this.blogRepository);

  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    return await blogRepository.getAllBlogs();
  }
}
