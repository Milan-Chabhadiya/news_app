import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:news_app/apibase/base_model.dart';
import 'package:news_app/apibase/repository.dart';
import 'package:news_app/models/response/article/article.dart';
import 'package:news_app/modules/home_page/pagination_store.dart';
import 'package:news_app/utils/debouncer.dart';
import 'package:news_app/utils/extensions.dart';
import 'package:news_app/values/strings.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  _HomeStore() {
    onInit();
  }

  List<ReactionDisposer> disposers = [];

  final Repository repository = Repository();

  PaginationStore<Article> latestNewsPaginationStore =
      PaginationStore<Article>(pageSize: 5);

  PaginationStore<Article> categoryWiseNewsPaginationStore =
      PaginationStore<Article>(pageSize: 20);

  PaginationStore<Article> searchedNewsPaginationStore =
      PaginationStore<Article>(pageSize: 20);

  TextEditingController searchController = TextEditingController();

  @observable
  String searchText = '';

  final debouncer = Debouncer(500.ms);

  // this index is for Catagory Menu
  @observable
  int currentIndex = 0;

  @observable
  List<String> categoryList = AppStrings.categoryList;

  // if this bool is true then show searchedNewsList else
  // show other two list on screen
  @observable
  bool isSearchOn = false;

  void onInit() {
    latestNewsPaginationStore.fetchItems(fetchLatestNews);
    categoryWiseNewsPaginationStore.fetchItems(fetchCategoryWiseNews);
    final reactionDisposer = reaction((_) => currentIndex, (_) {
      categoryWiseNewsPaginationStore
        ..reset()
        ..fetchItems(fetchCategoryWiseNews);
    });
    disposers.add(reactionDisposer);
    latestNewsPaginationStore.addListener(40, fetchLatestNews);
    categoryWiseNewsPaginationStore.addListener(40, fetchCategoryWiseNews);

    final searchReactionDisposer = reaction((_) => searchText, (_) {
      searchedNewsPaginationStore
        ..reset()
        ..fetchItems(fetchSearchedNews);
    });
    disposers.add(searchReactionDisposer);
  }

  Future<BaseModel<List<Article>>> fetchLatestNews(
    int page,
    int pageSize,
  ) async {
    return repository.getLatestArticles(
      page: page,
      pageSize: pageSize,
    );
  }

  Future<BaseModel<List<Article>>> fetchCategoryWiseNews(
    int page,
    int pageSize,
  ) async {
    return repository.getTopicWiseArticles(
      topic: categoryList[currentIndex].toLowerCase(),
      page: page,
      pageSize: pageSize,
    );
  }

  Future<BaseModel<List<Article>>> fetchSearchedNews(
    int page,
    int pageSize,
  ) async {
    final completer = Completer<BaseModel<List<Article>>>();
    final searchKeyword = searchText.trim();
    if (searchKeyword.isNotEmpty) {
      isSearchOn = true;
      debouncer.call(() {
        completer.complete(
          repository.getSearchedArticles(
            query: searchKeyword,
            page: page,
            pageSize: pageSize,
          ),
        );
      });
    } else {
      completer.complete(Future.value(BaseModel(data: [])));
      isSearchOn = false;
    }
    return completer.future;
  }

  void clearTextField() {
    searchController.clear();
    searchText = '';
  }

  void dispose() {
    latestNewsPaginationStore.dispose();
    categoryWiseNewsPaginationStore.dispose();
    searchedNewsPaginationStore.dispose();
    searchController.dispose();
    for (final disposer in disposers) {
      disposer.call();
    }
  }
}
