import 'package:dune_blog/core/utils/calculate_reading_time.dart';
import 'package:dune_blog/feature/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/blog.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewerPage.route(blog));
      },
      child: Container(
        height: 200,
        margin: EdgeInsets.all(16).copyWith(bottom: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    blog.topics
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Chip(label: Text(e)),
                          ),
                        )
                        .toList(),
              ),
            ),
            Text(
              blog.title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Text('${calculateReadingTime(blog.content)} min'),
          ],
        ),
      ),
    );
  }
}
