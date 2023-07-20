import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:news_app/modules/home_page/components/latest_article_tile.dart';
import 'package:news_app/modules/home_page/home_store.dart';
import 'package:news_app/values/constants.dart';
import 'package:news_app/values/enumeration.dart';
import 'package:news_app/values/strings.dart';
import 'package:provider/provider.dart';

class LatestNewsScrollView extends StatelessWidget {
  const LatestNewsScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeStore = context.read<HomeStore>();
    return Observer(
      builder: (_) {
        final latestNewsStore = homeStore.latestNewsPaginationStore;
        switch (latestNewsStore.state) {
          case StoreState.initial:
            return const SizedBox();
          case StoreState.loading:
            if (latestNewsStore.itemList.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.separated(
              controller: latestNewsStore.scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == latestNewsStore.itemList.length &&
                    latestNewsStore.hasMoreData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return LatestArticleTile(
                  article: latestNewsStore.itemList[index],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                width: 8,
              ),
              itemCount: latestNewsStore.itemList.length + 1,
            );

          case StoreState.error:
            if (latestNewsStore.itemList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      latestNewsStore.errorMsg,
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          latestNewsStore.fetchItems(homeStore.fetchLatestNews),
                      child: const Text(AppStrings.retry),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              controller: latestNewsStore.scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == latestNewsStore.itemList.length) {
                  return Center(
                    child: IconButton(
                      onPressed: () =>
                          latestNewsStore.fetchItems(homeStore.fetchLatestNews),
                      icon: const Icon(Icons.refresh),
                    ),
                  );
                }
                return LatestArticleTile(
                  article: latestNewsStore.itemList[index],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                width: 8,
              ),
              itemCount: latestNewsStore.itemList.length + 1,
            );

          case StoreState.success:
            if (latestNewsStore.itemList.isEmpty &&
                latestNewsStore.maxPages == 0) {
              return const Center(
                child: Text('No Data'),
              );
            }
            return ListView.separated(
              controller: latestNewsStore.scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == latestNewsStore.itemList.length &&
                    latestNewsStore.hasMoreData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (index == latestNewsStore.itemList.length &&
                    !latestNewsStore.hasMoreData) {
                  return const Text('No More Data Found.');
                }
                return LatestArticleTile(
                  article: latestNewsStore.itemList[index],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                width: 8,
              ),
              itemCount: latestNewsStore.itemList.length + 1,
            );
        }
      },
    );
  }
}
