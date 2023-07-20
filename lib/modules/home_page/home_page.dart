import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:news_app/modules/home_page/components/category_menu/category_menu.dart';
import 'package:news_app/modules/home_page/components/category_wise_news_scroll_view.dart';
import 'package:news_app/modules/home_page/components/latest_news_scrollview.dart';
import 'package:news_app/modules/home_page/components/searched_news_list.dart';
import 'package:news_app/modules/home_page/home_store.dart';
import 'package:news_app/values/constants.dart';
import 'package:news_app/values/strings.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => HomeStore(),
      dispose: (_, store) => store.dispose(),
      builder: (context, _) {
        final homeStore = context.read<HomeStore>();
        return Scaffold(
          body: CustomScrollView(
            controller:
                homeStore.categoryWiseNewsPaginationStore.scrollController,
            scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: AppBarWithSearchDelegate(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: kToolbarHeight,
                        ),
                        Text(
                          AppStrings.discover,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          AppStrings.newsFromAllOverTheWorld,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          child: TextField(
                            controller: homeStore.searchController,
                            textInputAction: TextInputAction.search,
                            onChanged: (value) => homeStore.searchText = value,
                            onTapOutside: (_) =>
                                FocusScope.of(context).unfocus(),
                            decoration: InputDecoration(
                              hintText: AppStrings.searchNewsHintText,
                              suffixIcon: Observer(
                                builder: (_) {
                                  return Visibility(
                                    visible: homeStore.isSearchOn,
                                    child: IconButton(
                                      onPressed: homeStore.clearTextField,
                                      icon: const Icon(Icons.clear),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Observer(
                builder: (context) => SliverVisibility(
                  visible: homeStore.isSearchOn,
                  sliver: const SearchedNewsList(),
                ),
              ),
              Observer(
                builder: (context) => SliverVisibility(
                  visible: !homeStore.isSearchOn,
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.defaultPadding,
                          ),
                          child: Text(
                            AppStrings.latestNews,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(
                          height: 280,
                          child: LatestNewsScrollView(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Observer(
                builder: (_) => SliverVisibility(
                  visible: !homeStore.isSearchOn,
                  sliver: SliverPersistentHeader(
                    pinned: true,
                    delegate: CategoryMenuDelegate(
                      child: NACategoryMenu(
                        categories: homeStore.categoryList,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.defaultPadding,
                        ),
                        onTap: (index) => homeStore.currentIndex = index,
                      ),
                    ),
                  ),
                ),
              ),
              Observer(
                builder: (_) => SliverVisibility(
                  visible: !homeStore.isSearchOn,
                  sliver: const SliverToBoxAdapter(
                    child: CategoryWiseNewsScrollView(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AppBarWithSearchDelegate extends SliverPersistentHeaderDelegate {
  AppBarWithSearchDelegate({required this.child});

  final Widget child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(color: Colors.white, child: child);
  }

  @override
  double get maxExtent => 138 + kToolbarHeight;

  @override
  double get minExtent => 138 + kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class CategoryMenuDelegate extends SliverPersistentHeaderDelegate {
  CategoryMenuDelegate({required this.child});

  final Widget child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: child,
    );
  }

  @override
  double get maxExtent => 64;

  @override
  double get minExtent => 64;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
