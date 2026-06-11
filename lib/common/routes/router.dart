import 'package:go_router/go_router.dart';
import 'package:news_reader_app/screen/artical_detail/ui/artical_detail.dart';
import 'package:news_reader_app/screen/auth/login/ui/loginscreen.dart';
import 'package:news_reader_app/screen/bookmark/ui/bookmark.dart';
import 'package:news_reader_app/screen/dashborad/data/model/news_model.dart';
import 'package:news_reader_app/screen/dashborad/ui/homescreen.dart';




final router = GoRouter(
  
    routes: [
      // GoRoute(
      //   path: '/',
      //   builder: (context, state) => const Loginscreen(),
      // ),
      GoRoute(
        path: '/',
        builder: (context, state) =>  HomeScreen(),
      ),
      GoRoute(
        path: '/article-detail',
        builder: (context, state) {
          final article = state.extra as Article;
          return ArticalDetail(article: article);
        },
      ),
      GoRoute(
        path: '/bookmark',
        builder: (context, state) => const BookMarkScreen(),
      ),


    ]);

    


    
