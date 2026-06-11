import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:news_reader_app/common/utils/colors.dart';
import 'package:news_reader_app/common/utils/screen_utils.dart';
import 'package:news_reader_app/common/widgets/common_appbar.dart';
import 'package:news_reader_app/common/widgets/common_button.dart';
import 'package:news_reader_app/common/widgets/common_style.dart';
import 'package:news_reader_app/screen/bookmark/data/provider/bookmark_provider.dart';
import 'package:news_reader_app/screen/dashborad/data/model/news_model.dart';

class BookMarkScreen extends ConsumerWidget {
  const BookMarkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarkProvider);

    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      appBar: CustomAppBar(
        title: 'Bookmarks',
        showBackArrow: true,
      ),
      body: bookmarks.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.getHorizontalSize(
                  context,
                  ScreenUtils.paddingM,
                ),
                vertical: ScreenUtils.getVerticalSize(
                  context,
                  ScreenUtils.paddingM,
                ),
              ),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                return _buildArticleCard(
                  context,
                  ref,
                  bookmarks[index],
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: ScreenUtils.getHorizontalSize(context, 80),
            color: AppColor.coolGrayColor,
          ),
          SizedBox(
            height: ScreenUtils.getVerticalSize(context, ScreenUtils.heightM),
          ),
          Text(
            'No Bookmarks Yet',
            style: CustomStyles.boldTextStyle(
              color: AppColor.textPrimaryColor,
              fontSize: ScreenUtils.getFontSize(
                context,
                CustomStyles.size18,
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtils.getVerticalSize(context, ScreenUtils.heightS),
          ),
          Text(
            'Start bookmarking articles to read them later',
            style: CustomStyles.regularTextStyle(
              color: AppColor.textSecondaryColor,
              fontSize: ScreenUtils.getFontSize(
                context,
                CustomStyles.size14,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(
    BuildContext context,
    WidgetRef ref,
    Article article,
  ) {
    return Card(
      margin: EdgeInsets.only(
        bottom: ScreenUtils.getVerticalSize(context, ScreenUtils.heightM),
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ScreenUtils.getHorizontalSize(context, ScreenUtils.radiusM),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.backgroundColor,
          borderRadius: BorderRadius.circular(
            ScreenUtils.getHorizontalSize(context, ScreenUtils.radiusM),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  ScreenUtils.getHorizontalSize(context, ScreenUtils.radiusM),
                ),
              ),
              child: Container(
                height: ScreenUtils.getVerticalSize(context, 150),
                width: double.infinity,
                color: AppColor.fillColor,
                child: article.urlToImage != null && article.urlToImage!.isNotEmpty
                    ? Image.network(
                        article.urlToImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.image,
                          size: 50,
                          color: AppColor.coolGrayColor,
                        ),
                      )
                    : Icon(
                        Icons.image,
                        size: 50,
                        color: AppColor.coolGrayColor,
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(
                ScreenUtils.getHorizontalSize(context, ScreenUtils.paddingM),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: CustomStyles.boldTextStyle(
                      color: AppColor.textPrimaryColor,
                      fontSize: ScreenUtils.getFontSize(
                        context,
                        CustomStyles.size16,
                      ),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: ScreenUtils.getVerticalSize(
                      context,
                      ScreenUtils.heightS,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.source,
                        size: 14,
                        color: AppColor.textSecondaryColor,
                      ),
                      SizedBox(
                        width: ScreenUtils.getHorizontalSize(
                          context,
                          ScreenUtils.widthXS,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          article.source.name.toString(),
                          style: CustomStyles.regularTextStyle(
                            color: AppColor.textSecondaryColor,
                            fontSize: ScreenUtils.getFontSize(
                              context,
                              CustomStyles.size12,
                            ),
                          ),
                          overflow: TextOverflow.ellipsis,
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
                        size: 14,
                        color: AppColor.textSecondaryColor,
                      ),
                      SizedBox(
                        width: ScreenUtils.getHorizontalSize(
                          context,
                          ScreenUtils.widthXS,
                        ),
                      ),
                      Text(
                        article.publishedAt != null
                            ? DateFormat('dd-MM-yyyy').format(
                                DateTime.parse(article.publishedAt!),
                              )
                            : '',
                        style: CustomStyles.regularTextStyle(
                          color: AppColor.textSecondaryColor,
                          fontSize: ScreenUtils.getFontSize(
                            context,
                            CustomStyles.size12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtils.getVerticalSize(
                      context,
                      ScreenUtils.heightM,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.bookmark_remove,
                          color: AppColor.redColor,
                        ),
                        onPressed: () {
                          ref.read(bookmarkProvider.notifier).removeBookmark(article);
                        },
                      ),
                      CustomButton(
                        text: 'View',
                        buttonColor: AppColor.primaryColor,
                        textColor: AppColor.backgroundColor,
                        fontSize: ScreenUtils.getFontSize(
                          context,
                          CustomStyles.size12,
                        ),
                        height: ScreenUtils.getVerticalSize(context, 35),
                        width: ScreenUtils.getHorizontalSize(context, 80),
                        onPressed: () {
                          context.push('/article-detail', extra: article);
                        },
                      ),
                    ],
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