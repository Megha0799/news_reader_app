import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:news_reader_app/common/utils/colors.dart';
import 'package:news_reader_app/common/utils/screen_utils.dart';
import 'package:news_reader_app/common/widgets/common_appbar.dart';
import 'package:news_reader_app/common/widgets/common_style.dart';
import 'package:news_reader_app/screen/dashborad/data/model/news_model.dart';
import 'package:news_reader_app/screen/dashborad/data/provider/news_provider.dart';
import 'package:readmore/readmore.dart';

class ArticalDetail extends ConsumerWidget {
  final Article article;

  const ArticalDetail({super.key, required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the current article state
    final newsState = ref.watch(newsListProvider);
    final currentArticle = newsState.whenData((articles) {
      final index = articles.indexWhere((a) => a.title == article.title);
      return index != -1 ? articles[index] : article;
    }).value ?? article;

    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      appBar: CustomAppBar(
        title: 'Article Details',
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Container(
              width: double.infinity,
              height: ScreenUtils.getVerticalSize(context, 250),
              color: AppColor.fillColor,
              child: currentArticle.urlToImage != null && currentArticle.urlToImage!.isNotEmpty
                  ? Image.network(
                      currentArticle.urlToImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.image,
                        size: 80,
                        color: AppColor.coolGrayColor,
                      ),
                    )
                  : Icon(
                      Icons.image,
                      size: 80,
                      color: AppColor.coolGrayColor,
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(
                ScreenUtils.getHorizontalSize(context, ScreenUtils.paddingL),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ScreenUtils.getVerticalSize(context, ScreenUtils.heightM),
                  ),
                  // Title
                  Text(
                    currentArticle.title,
                    style: CustomStyles.boldTextStyle(
                      color: AppColor.textPrimaryColor,
                      fontSize: ScreenUtils.getFontSize(
                        context,
                        CustomStyles.size20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtils.getVerticalSize(context, ScreenUtils.heightM),
                  ),
                  // Source and Date
                  Row(
                    children: [
                      Icon(
                        Icons.source,
                        size: 16,
                        color: AppColor.textSecondaryColor,
                      ),
                      SizedBox(
                        width: ScreenUtils.getHorizontalSize(
                          context,
                          ScreenUtils.widthXS,
                        ),
                      ),
                      Text(
                        currentArticle.source.name ?? 'Unknown',
                        style: CustomStyles.mediumTextStyle(
                          color: AppColor.textSecondaryColor,
                          fontSize: ScreenUtils.getFontSize(
                            context,
                            CustomStyles.size14,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtils.getHorizontalSize(
                          context,
                          ScreenUtils.widthS,
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppColor.textSecondaryColor,
                      ),
                      SizedBox(
                        width: ScreenUtils.getHorizontalSize(
                          context,
                          ScreenUtils.widthXS,
                        ),
                      ),
                      Text(
                        currentArticle.publishedAt != null
                            ? DateFormat('dd MMM yyyy').format(
                                DateTime.parse(currentArticle.publishedAt!),
                              )
                            : 'Unknown',
                        style: CustomStyles.mediumTextStyle(
                          color: AppColor.textSecondaryColor,
                          fontSize: ScreenUtils.getFontSize(
                            context,
                            CustomStyles.size14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtils.getVerticalSize(context, ScreenUtils.heightM),
                  ),
                  // Author
                  if (currentArticle.author != null && currentArticle.author!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Author',
                          style: CustomStyles.semiboldTextStyle(
                            color: AppColor.textSecondaryColor,
                            fontSize: ScreenUtils.getFontSize(
                              context,
                              CustomStyles.size12,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtils.getVerticalSize(context, ScreenUtils.heightXS),
                        ),
                        Text(
                          currentArticle.author!,
                          style: CustomStyles.regularTextStyle(
                            color: AppColor.textPrimaryColor,
                            fontSize: ScreenUtils.getFontSize(
                              context,
                              CustomStyles.size14,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtils.getVerticalSize(context, ScreenUtils.heightM),
                        ),
                      ],
                    ),
                  // Description
                  Text(
                    'Description',
                    style: CustomStyles.semiboldTextStyle(
                      color: AppColor.textSecondaryColor,
                      fontSize: ScreenUtils.getFontSize(
                        context,
                        CustomStyles.size12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtils.getVerticalSize(context, ScreenUtils.heightXS),
                  ),
                  Text(
                    currentArticle.description ?? 'No description available',
                    style: CustomStyles.regularTextStyle(
                      color: AppColor.textPrimaryColor,
                      fontSize: ScreenUtils.getFontSize(
                        context,
                        CustomStyles.size14,
                      ),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtils.getVerticalSize(context, ScreenUtils.heightL),
                  ),
                  // Content
                  if (currentArticle.content != null && currentArticle.content!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Content',
                          style: CustomStyles.semiboldTextStyle(
                            color: AppColor.textSecondaryColor,
                            fontSize: ScreenUtils.getFontSize(
                              context,
                              CustomStyles.size12,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtils.getVerticalSize(context, ScreenUtils.heightXS),
                        ),
                        ReadMoreText(
                          currentArticle.content!,
                          trimLines: 3,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Read more',
                          trimExpandedText: ' Show less',
                          moreStyle: CustomStyles.mediumTextStyle(
                            color: AppColor.primaryColor,
                            fontSize: ScreenUtils.getFontSize(
                              context,
                              CustomStyles.size14,
                            ),
                          ),
                          lessStyle: CustomStyles.mediumTextStyle(
                            color: AppColor.primaryColor,
                            fontSize: ScreenUtils.getFontSize(
                              context,
                              CustomStyles.size14,
                            ),
                          ),
                          style: CustomStyles.regularTextStyle(
                            color: AppColor.textPrimaryColor,
                            fontSize: ScreenUtils.getFontSize(
                              context,
                              CustomStyles.size14,
                            ),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtils.getVerticalSize(context, ScreenUtils.heightL),
                        ),
                      ],
                    ),
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Bookmark Button
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              currentArticle.isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: currentArticle.isBookmarked
                                  ? AppColor.primaryColor
                                  : AppColor.coolGrayColor,
                              size: 32,
                            ),
                            onPressed: () {
                              final articles = ref.read(newsListProvider);
                              if (articles.hasValue) {
                                final index = articles.value!.indexWhere((a) => a.title == currentArticle.title);
                                if (index != -1) {
                                  ref.read(newsListProvider.notifier).toggleBookmark(index);
                                }
                              }
                            },
                          ),
                         
                        ],
                      ),
                     ],
                  ),
                  SizedBox(
                    height: ScreenUtils.getVerticalSize(context, ScreenUtils.heightXL),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}