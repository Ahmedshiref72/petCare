import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/app_scaffold.dart';
import 'package:pawlly/components/html_widget.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/utils/common_base.dart';
import '../../../components/cached_image_widget.dart';
import 'blog_detail_controller.dart';
import '../../../utils/colors.dart';

class BlogDetailScreen extends StatelessWidget {
  BlogDetailScreen({Key? key}) : super(key: key);
  final BlogDetailController blogDetailController = Get.put(BlogDetailController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.blogDetail,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 16, bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blogDetailController.blogDetailFromArg.value.tags,
                  style: secondaryTextStyle(color: primaryColor, fontStyle: FontStyle.italic, fontFamily: fontFamilyFontWeight600),
                ),
                8.height,
                Text(blogDetailController.blogDetailFromArg.value.name, style: primaryTextStyle(size: 18)),
                8.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blogDetailController.blogDetailFromArg.value.createdAt.dateInMMMMDyyyyFormat,
                      style: primaryTextStyle(color: secondaryTextColor, size: 12),
                    ),
                    Spacer(),
                    Text("${locale.value.readTime} : ${blogDetailController.blogDetailFromArg.value.description.calculateReadTime().minutes.inMinutes} ${locale.value.min}", style: primaryTextStyle(color: secondaryTextColor)),
                  ],
                ),
                16.height,
              ],
            ).paddingSymmetric(horizontal: 16),
            Hero(
              tag: "${blogDetailController.blogDetailFromArg.value.blogImage}${blogDetailController.blogDetailFromArg.value.id}",
              child: CachedImageWidget(url: blogDetailController.blogDetailFromArg.value.blogImage, width: Get.width, fit: BoxFit.fitWidth),
            ),
            16.height,
            HtmlWidget(
              content: blogDetailController.blogDetailFromArg.value.description,
            ).paddingSymmetric(horizontal: 8),
          ],
        ),
      ),
    );
  }
}
