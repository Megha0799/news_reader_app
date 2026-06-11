import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_reader_app/common/widgets/common_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackArrow;
  final String? title;
  final bool showMenuIcon;
  final bool menuicon;
  final void Function()? onPressed;
  final List<Widget>? actions;

  @override
  final Size preferredSize;

  const CustomAppBar({
    this.onPressed,
    super.key,
    this.showBackArrow = false,
    this.title,
    this.showMenuIcon = false,
    this.menuicon=false,
    this.actions,
  })  : preferredSize = const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
 return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: showBackArrow
    ? IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          context.pop();
        },
      )
    : Row(
       mainAxisAlignment: MainAxisAlignment.spaceAround,
      // mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(width: 8),
      //  showMenuIcon
      //     ? Image.asset(
      //     AppImages.appLogo,
      //     height: 30,
      //     width: 30,
          
      //     fit: BoxFit.contain,
      //   ) : const SizedBox(),
        menuicon
        ?IconButton(
          icon: Icon(Icons.menu, color: Colors.lightBlue, size: 20),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed:onPressed
        ) : const SizedBox(),
      ],
    ),
      title: title != null
          ? Text(
              title!,
              style: CustomStyles.semiboldTextStyle(
                color: Colors.black,
                fontSize: CustomStyles.size25,
              ),
            )
          : null,
      centerTitle: true,
      actions: actions ?? [],
    );
  }
}



// // Default (logo + menu)
// CustomAppBar()

// // With back arrow
// CustomAppBar(showBackArrow: true)

// // With title
// CustomAppBar(title: 'Workshop')

// // With back arrow and title
// CustomAppBar(showBackArrow: true, title: 'Details')