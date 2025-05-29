import 'package:dune_blog/core/common/widgets/loader.dart';
import 'package:dune_blog/core/theme/app_palette.dart';
import 'package:dune_blog/core/utils/show_snackbar.dart';
import 'package:dune_blog/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:dune_blog/feature/blog/presentation/pages/add_new_blog_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/blog_card.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());

  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlocGetAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dune blog'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
            icon: Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }

          if (state is BlogRetrieveSuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogCard(
                  blog: blog,
                  color:
                      index % 3 == 0
                          ? AppPalette.gradient1
                          : index % 3 == 1
                          ? AppPalette.gradient2
                          : AppPalette.gradient3,
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
