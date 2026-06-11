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
import 'package:news_reader_app/screen/dashborad/data/provider/news_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  // GlobalKey can be held securely inside a stateless widget instance variable
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Handler methods matching your original execution flows
  void _handleLogout(BuildContext context) {
    context.go('/');
  }

 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider state (handles loading, data, and error automatically)
    final newsState = ref.watch(newsListProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.bodyColor,
      appBar: CustomAppBar(
        title: 'DashBorad',
        menuicon: true,
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border, color: Colors.black),
            onPressed: () {
              context.push('/bookmark');
            },
          ),
        ],
      ),
      drawer: _buildDrawer(
        context,
      ), // Passed context if your drawer UI triggers logout
      body: newsState.when(
        // 1. Loading UI Block
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColor.primaryColor),
        ),

        // 2. Error Handling UI Block
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(newsListProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),

        // 3. Functional Data Render Block
        data: (articlesList) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(newsListProvider);
              ref.read(newsListProvider);
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
              itemCount: articlesList.length,
              itemBuilder: (context, index) {
                return _buildArticleCard(
                  context,
                  ref,
                  articlesList[index],
                  index,
                );
              },
            ),
          );
        },
      ),
   
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: FloatingActionButton.extended(
          onPressed:(){
            GoRouter.of(context).push('/wall-street-journal');
          },
          backgroundColor: AppColor.primaryColor,
          foregroundColor: AppColor.backgroundColor,
          elevation: 4,
          icon: const Icon(Icons.add),
          // isExtended: _isFabExtended,
          label: const Text('WSJournal'),
        ),
      ),
     );
  }

 

Widget _buildDrawer(BuildContext context) {
  // 1. Define a helper function to fetch your data map
  Future<Map<String, String>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('store_name') ?? 'Guest User',
      'email': prefs.getString('user_email') ?? 'guest@example.com',
    };
  }

  return Drawer(
    child: Container(
      color: AppColor.backgroundColor,
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          // Top content: Header
          SliverToBoxAdapter(
            // 2. Wrap your DrawerHeader content with a FutureBuilder
            child: FutureBuilder<Map<String, String>>(
              future: _getUserData(),
              builder: (context, snapshot) {
                // Fallback text while loading or if data is null
                final name = snapshot.data?['name'] ?? 'Loading...';
                final email = snapshot.data?['email'] ?? 'Loading...';

                return DrawerHeader(
                  decoration: BoxDecoration(color: AppColor.primaryColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColor.backgroundColor,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtils.getVerticalSize(
                          context,
                          ScreenUtils.heightM,
                        ),
                      ),
                      // 3. Display the dynamic store name
                      Text(
                        name,
                        style: CustomStyles.boldTextStyle(
                          color: AppColor.backgroundColor,
                          fontSize: ScreenUtils.getFontSize(
                            context,
                            CustomStyles.size18,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtils.getVerticalSize(
                          context,
                          ScreenUtils.heightXS,
                        ),
                      ),
                      // 4. Display the dynamic email address
                      Text(
                        email,
                        style: CustomStyles.regularTextStyle(
                          color: AppColor.backgroundColor,
                          fontSize: ScreenUtils.getFontSize(
                            context,
                            CustomStyles.size14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Divider(),
                ListTile(
                  leading: Icon(Icons.logout, color: AppColor.redColor),
                  title: Text(
                    'Logout',
                    style: CustomStyles.mediumTextStyle(
                      color: AppColor.redColor,
                      fontSize: ScreenUtils.getFontSize(
                        context,
                        CustomStyles.size16,
                      ),
                    ),
                  ),
                  onTap: () {
                    context.pop();
                    _handleLogout(context);
                  },
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildArticleCard(
    BuildContext context,
    WidgetRef ref,
    Article article,
    int index,
  ) {
    final bookmarkNotifier = ref.read(bookmarkProvider.notifier);
    final isBookmarked = bookmarkNotifier.isBookmarked(article);

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
            // Thumbnail Layer
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
                child:
                    article.urlToImage != null && article.urlToImage!.isNotEmpty
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
                  // Title Text
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
                  // Source and Date layout Metadata
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
                        DateFormat('dd-MM-yyyy').format(
                          DateTime.parse(article.date.toString()),
                        ),
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
                  // Action buttons panel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: isBookmarked
                              ? AppColor.primaryColor
                              : AppColor.coolGrayColor,
                        ),
                        onPressed: () {
                          bookmarkNotifier.toggleBookmark(article);
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














