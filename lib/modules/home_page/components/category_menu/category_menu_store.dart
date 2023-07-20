import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:news_app/utils/extensions.dart';

part 'category_menu_store.g.dart';

class CategoryMenuStore = _CategoryMenuStore with _$CategoryMenuStore;

abstract class _CategoryMenuStore with Store {
  _CategoryMenuStore(this.currentIndex);
  @observable
  int currentIndex;

  void onIndexChanged(
    int index,
    BuildContext context,
    ValueChanged<int>? onTap,
  ) {
    Scrollable.ensureVisible(
      context,
      alignment: 0.5,
      duration: 500.ms,
    );
    currentIndex = index;
    onTap?.call(index);
  }
}
