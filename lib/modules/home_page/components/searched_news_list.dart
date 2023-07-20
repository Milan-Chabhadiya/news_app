import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:news_app/modules/home_page/components/news_tile.dart';
import 'package:news_app/modules/home_page/home_store.dart';
import 'package:news_app/values/constants.dart';
import 'package:news_app/values/enumeration.dart';
import 'package:news_app/values/strings.dart';
import 'package:provider/provider.dart';

class SearchedNewsList extends StatelessWidget {
  const SearchedNewsList({super.key});

  @override
  Widget build(BuildContext context) {
    final homeStore = context.read<HomeStore>();
    return SliverToBoxAdapter(
      child: Observer(
        builder: (_) {
          final searchStore = homeStore.searchedNewsPaginationStore;
          switch (searchStore.state) {
            case StoreState.initial:
              return const SizedBox();
            case StoreState.loading:
              return const Center(child: CircularProgressIndicator());
            case StoreState.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(searchStore.errorMsg),
                    ElevatedButton(
                      onPressed: () => searchStore
                        ..reset()
                        ..fetchItems(homeStore.fetchSearchedNews),
                      child: const Text(AppStrings.retry),
                    )
                  ],
                ),
              );
            case StoreState.success:
              if (searchStore.maxPages == 0 && searchStore.itemList.isEmpty) {
                return const Center(child: Text(AppStrings.noSearchFound));
              }
              return ListView.separated(
                separatorBuilder: (_, __) => const SizedBox(
                  height: 12,
                ),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                  vertical: 8,
                ),
                controller: searchStore.scrollController,
                itemBuilder: (context, index) {
                  return NewsTile(
                    article: searchStore.itemList[index],
                  );
                },
                itemCount: searchStore.itemList.length,
              );
          }
        },
      ),
    );
  }
}
