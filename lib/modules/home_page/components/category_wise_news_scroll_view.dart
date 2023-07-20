import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:news_app/modules/home_page/components/news_tile.dart';
import 'package:news_app/modules/home_page/home_store.dart';
import 'package:news_app/values/constants.dart';
import 'package:news_app/values/enumeration.dart';
import 'package:news_app/values/strings.dart';
import 'package:provider/provider.dart';

class CategoryWiseNewsScrollView extends StatelessWidget {
  const CategoryWiseNewsScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final homeStore = context.read<HomeStore>();
        final categoryNewsStore = homeStore.categoryWiseNewsPaginationStore;
        switch (categoryNewsStore.state) {
          case StoreState.initial:
            return const SizedBox();
          case StoreState.loading:
            if (categoryNewsStore.itemList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              itemCount: categoryNewsStore.itemList.length + 1,
              separatorBuilder: (_, __) => const SizedBox(
                height: 12,
              ),
              itemBuilder: (_, index) {
                if (index == categoryNewsStore.itemList.length &&
                    categoryNewsStore.hasMoreData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return NewsTile(
                  article: categoryNewsStore.itemList[index],
                );
              },
            );
          case StoreState.error:
            if (categoryNewsStore.itemList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      categoryNewsStore.errorMsg,
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      onPressed: () => categoryNewsStore
                          .fetchItems(homeStore.fetchCategoryWiseNews),
                      child: const Text(AppStrings.retry),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              itemCount: categoryNewsStore.itemList.length + 1,
              separatorBuilder: (_, __) => const SizedBox(
                height: 12,
              ),
              itemBuilder: (_, index) {
                if (index == categoryNewsStore.itemList.length) {
                  return Center(
                    child: IconButton(
                      onPressed: () => categoryNewsStore
                          .fetchItems(homeStore.fetchCategoryWiseNews),
                      icon: const Icon(Icons.refresh),
                    ),
                  );
                }
                return NewsTile(
                  article: categoryNewsStore.itemList[index],
                );
              },
            );

          case StoreState.success:
            if (categoryNewsStore.itemList.isEmpty &&
                categoryNewsStore.maxPages == 0) {
              return const Center(
                child: Text('No Data'),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              itemCount: categoryNewsStore.itemList.length + 1,
              separatorBuilder: (_, __) => const SizedBox(
                height: 12,
              ),
              itemBuilder: (_, index) {
                if (index == categoryNewsStore.itemList.length &&
                    categoryNewsStore.hasMoreData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (index == categoryNewsStore.itemList.length &&
                    !categoryNewsStore.hasMoreData) {
                  return const Center(child: Text('No more data.'));
                }
                return NewsTile(
                  article: categoryNewsStore.itemList[index],
                );
              },
            );
        }
      },
    );
  }
}
