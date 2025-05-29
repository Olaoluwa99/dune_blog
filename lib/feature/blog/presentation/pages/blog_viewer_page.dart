import 'package:dune_blog/core/theme/app_palette.dart';
import 'package:dune_blog/core/utils/calculate_reading_time.dart';
import 'package:dune_blog/core/utils/format_date.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/blog.dart';

class BlogViewerPage extends StatelessWidget {
  static route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog));
  final Blog blog;
  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  'By ${blog.posterName}',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  '${formatDateBydMMMYYYY(blog.updatedAt)}  •  ${calculateReadingTime(blog.content)} min',
                  style: TextStyle(color: AppPalette.greyColor, fontSize: 16),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(blog.imageUrl, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 20),
                Text(blog.content, style: TextStyle(fontSize: 16, height: 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
