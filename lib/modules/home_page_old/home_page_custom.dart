import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:news_app/modules/home_page_old/components/category_menu/category_menu.dart';
import 'package:news_app/modules/home_page_old/components/latest_article_tile.dart';
import 'package:news_app/modules/home_page_old/components/news_tile.dart';
import 'package:news_app/modules/home_page_old/stores/category_store.dart';
import 'package:news_app/modules/home_page_old/stores/latest_article_store.dart';
import 'package:news_app/values/constants.dart';
import 'package:news_app/values/enumeration.dart';
import 'package:news_app/values/strings.dart';
import 'package:provider/provider.dart';

class HomePageCustom extends StatelessWidget {
  const HomePageCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => LatestArticleStore(),
          dispose: (_, store) => store.dispose(),
        ),
        Provider(
          create: (_) => CategoryStore(),
          dispose: (_, store) => store.dispose(),
        ),
      ],
      builder: (context, child) {
        final latestArticleStore = context.read<LatestArticleStore>();
        final categoryStore = context.read<CategoryStore>();
        return Scaffold(
          body: CustomScrollView(
              controller: categoryStore.scrollController,
              scrollBehavior:
                  const ScrollBehavior().copyWith(overscroll: false),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SearchDelegate(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: kToolbarHeight,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.defaultPadding,
                          ),
                          child: Text(
                            'Discover',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.defaultPadding,
                          ),
                          child: Text(
                            'News from all over the world.',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.defaultPadding,
                            vertical: 12,
                          ),
                          child: TextField(
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Latest News. Put 5-10 articles with Horizontal ListView.
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.defaultPadding,
                        ),
                        child: Text(
                          'Latest News',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),

                      SizedBox(
                        height: 280,
                        child: Observer(
                          builder: (_) {
                            switch (latestArticleStore.state) {
                              case StoreState.initial:
                                return const SizedBox();
                              case StoreState.loading:
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              case StoreState.error:
                                return Center(
                                  child: Text(
                                    latestArticleStore.errorMsg,
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              case StoreState.success:
                                return ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppConstants.defaultPadding,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    if (index ==
                                            latestArticleStore
                                                .articleList.length &&
                                        latestArticleStore.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (index ==
                                            latestArticleStore
                                                .articleList.length &&
                                        !latestArticleStore.hasData) {
                                      return const SizedBox();
                                    }
                                    return LatestArticleTile(
                                      article:
                                          latestArticleStore.articleList[index],
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    width: 8,
                                  ),
                                  itemCount:
                                      latestArticleStore.articleList.length + 1,
                                );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: FollowSpaceDelegate(
                    context: context,
                    child: const NACategoryMenu(
                      categories: AppStrings.categoryList,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.defaultPadding,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Observer(
                    builder: (context) {
                      switch (categoryStore.state) {
                        case StoreState.initial:
                          return const SizedBox();
                        case StoreState.loading:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        case StoreState.error:
                          return Center(
                            child: Text(
                              categoryStore.errorMsg,
                              textAlign: TextAlign.center,
                            ),
                          );
                        case StoreState.success:
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.defaultPadding,
                            ),
                            // primary: true,
                            itemCount: categoryStore.articleList.length + 1,
                            separatorBuilder: (_, __) => const SizedBox(
                              height: 12,
                            ),
                            itemBuilder: (_, index) {
                              if (index == categoryStore.articleList.length &&
                                  categoryStore.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (index == categoryStore.articleList.length &&
                                  !categoryStore.hasData) {
                                return const SizedBox();
                              }
                              return NewsTile(
                                article: categoryStore.articleList[index],
                              );
                            },
                          );
                      }
                    },
                  ),
                )
              ]),
        );
      },
    );
  }
}

class SearchDelegate extends SliverPersistentHeaderDelegate {
  SearchDelegate({required this.child});

  final Widget child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      alignment: Alignment.topCenter,
      // padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
      color: Colors.white,
      child: child,
    );
  }

  @override
  double get maxExtent => 115 + 24 + kToolbarHeight;

  @override
  double get minExtent => 115 + 24 + kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class FollowSpaceDelegate extends SliverPersistentHeaderDelegate {
  FollowSpaceDelegate({required this.child, required this.context});

  final Widget child;
  final BuildContext context;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      color: Colors.white,
      child: child,
    );
  }

  @override
  double get maxExtent => 40 + 24;

  @override
  double get minExtent => 40 + 24;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
