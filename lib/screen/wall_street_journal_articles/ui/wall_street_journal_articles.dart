import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:news_reader_app/common/utils/colors.dart';
import 'package:news_reader_app/common/utils/screen_utils.dart';
import 'package:news_reader_app/common/widgets/common_appbar.dart';
import 'package:news_reader_app/common/widgets/common_style.dart';
import 'package:news_reader_app/screen/dashborad/data/model/news_model.dart';
import 'package:news_reader_app/screen/wall_street_journal_articles/data/provider/wsj_articles_provider.dart';
import 'package:readmore/readmore.dart';

class WallStreetJournalArticles extends ConsumerWidget {
  const WallStreetJournalArticles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wsjArticlesState = ref.watch(wsjArticlesProvider);

    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      appBar: CustomAppBar(
        title: 'Wall Street Journal',
        showBackArrow: true,
      ),
      body: wsjArticlesState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColor.primaryColor),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(wsjArticlesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (wsjArticles) {
          final now = DateTime.now();
          final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);

          // 1. Filter articles within the last 6 months
          final recentArticles = wsjArticles.where((article) {
            if (article.publishedAt == null) return false;
            final articleDate = DateTime.tryParse(article.publishedAt!);
            if (articleDate == null) return false;
            return articleDate.isAfter(sixMonthsAgo);
          }).toList();

          // 2. Explicitly sort the list (Newest first)
          recentArticles.sort((a, b) {
            final dateA = DateTime.parse(a.publishedAt!);
            final dateB = DateTime.parse(b.publishedAt!);
            return dateB.compareTo(dateA); 
          });

          if (recentArticles.isEmpty) {
            return _buildEmptyState(context);
          }



          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(wsjArticlesProvider);
              ref.read(wsjArticlesProvider);
            },
            color: AppColor.primaryColor,
            child: ListView.builder(
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
              itemCount: recentArticles.length,
              itemBuilder: (context, index) {
                return _buildArticleCard(
                  context,
                  ref,
                  recentArticles[index],
                  index,
                );
              },
            ),
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
            Icons.article_outlined,
            size: ScreenUtils.getHorizontalSize(context, 80),
            color: AppColor.coolGrayColor,
          ),
          SizedBox(
            height: ScreenUtils.getVerticalSize(context, ScreenUtils.heightM),
          ),
          Text(
            'No WSJ Articles',
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
            'No Wall Street Journal articles found in the last 6 months',
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
    int index,
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
            // Hero Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  ScreenUtils.getHorizontalSize(context, ScreenUtils.radiusM),
                ),
              ),
              child: Container(
                height: ScreenUtils.getVerticalSize(context, 200),
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
                  // Full Title
                  Text(
                    article.title,
                    style: CustomStyles.boldTextStyle(
                      color: AppColor.textPrimaryColor,
                      fontSize: ScreenUtils.getFontSize(
                        context,
                        CustomStyles.size18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtils.getVerticalSize(
                      context,
                      ScreenUtils.heightS,
                    ),
                  ),
                  // Description
                  if (article.description != null && article.description!.isNotEmpty)
                    Text(
                      article.description!,
                      style: CustomStyles.regularTextStyle(
                        color: AppColor.textSecondaryColor,
                        fontSize: ScreenUtils.getFontSize(
                          context,
                          CustomStyles.size14,
                        ),
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(
                    height: ScreenUtils.getVerticalSize(
                      context,
                      ScreenUtils.heightM,
                    ),
                  ),
                  
                  // Content
                  if (article.content != null && article.content!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        
                        ReadMoreText(
                          article.content!,
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
                 
                  // Source and Date
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
                            ? DateFormat('dd MMM yyyy').format(
                                DateTime.parse(article.publishedAt!),
                              )
                            : 'Unknown',
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
                  // Action buttons
                 
                
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
