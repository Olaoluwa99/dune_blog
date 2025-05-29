import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dune_blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:dune_blog/core/constants/constants.dart';
import 'package:dune_blog/core/theme/app_palette.dart';
import 'package:dune_blog/core/utils/pick_image.dart';
import 'package:dune_blog/core/utils/show_snackbar.dart';
import 'package:dune_blog/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:dune_blog/feature/blog/presentation/pages/blog_page.dart';
import 'package:dune_blog/feature/blog/presentation/widget/blog_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/widgets/loader.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      //showSnackBar(context, 'At the top');
      context.read<BlogBloc>().add(
        BlogUpload(
          posterId: posterId,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          image: image!,
          topics: selectedTopics,
        ),
      );
    } else {
      showSnackBar(context, 'A value is invalid');
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              uploadBlog();
            },
            icon: Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                          onTap: selectImage,
                          child: SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(image!, fit: BoxFit.cover),
                            ),
                          ),
                        )
                        : GestureDetector(
                          onTap: () {
                            selectImage();
                          },
                          child: DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              color: AppPalette.borderColor,
                              dashPattern: [10, 5],
                              strokeWidth: 2,
                              padding: EdgeInsets.all(0),
                              radius: Radius.circular(12),
                              strokeCap: StrokeCap.round,
                            ),
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.folder_open, size: 44),
                                  SizedBox(height: 15),
                                  Text(
                                    'Select your image',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            Constants.topics
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (selectedTopics.contains(e)) {
                                          selectedTopics.remove(e);
                                        } else {
                                          selectedTopics.add(e);
                                        }
                                        setState(() {});
                                      },
                                      child: Chip(
                                        color:
                                            selectedTopics.contains(e)
                                                ? WidgetStatePropertyAll(
                                                  AppPalette.gradient1,
                                                )
                                                : null,
                                        label: Text(e),
                                        side:
                                            selectedTopics.contains(e)
                                                ? null
                                                : BorderSide(
                                                  color: AppPalette.borderColor,
                                                ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    SizedBox(height: 10),
                    BlogEditor(
                      hintText: 'Blog title',
                      controller: titleController,
                    ),
                    SizedBox(height: 10),
                    BlogEditor(
                      hintText: 'Blog content',
                      controller: contentController,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
