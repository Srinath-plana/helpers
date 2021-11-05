import 'package:helpers/helpers/extensions/string.dart';

extension ListListMerging<T> on List<List<T>> {
  ///Do that:
  ///```dart
  /// //Input
  /// final output = [
  ///   [elementT, elementT],
  ///   [elementT, elementT, elementT, elementT],
  ///   [elementT, elementT, elementT],
  /// ].merge();
  ///
  ///
  /// //Printing result
  /// print(output);
  ///
  /// [
  ///   elementT,
  ///   elementT,
  ///   elementT,
  ///   elementT,
  ///   elementT,
  ///   elementT,
  ///   elementT,
  ///   elementT,
  ///   elementT,
  /// ]
  ///```
  List<T> merge() {
    return fold<List<T>>(
      [],
      (prev, element) => prev..addAll(element),
    );
  }

  ///Do that:
  ///```dart
  /// //Input
  /// final List<Widget> children = [
  ///   [SideBarMenuItem(), SideBarMenuItem, SideBarMenuItem()]
  ///   [SideBarMenuItem(), SideBarMenuItem()]
  /// ].fuse<Widget>(
  ///     (item) => SideBarMenuTile(item),
  ///     sepatarorBetweenItems: const Spacer(),
  ///     separatorBetweenLists: const BigSpacer()
  ///   );
  ///
  ///
  /// //Printing result
  /// print(children);
  ///
  /// [
  ///   SideBarMenuItem(),
  ///   const Spacer(),
  ///   SideBarMenuItem(),
  ///   const Spacer(),
  ///   SideBarMenuItem(),
  ///   const BigSpacer(),
  ///   SideBarMenuItem(),
  ///   const Spacer(),
  ///   SideBarMenuItem(),
  /// ]
  ///```
  List<E> fuse<E>(
    E Function(T e) element, {
    E? sepatarorBetweenItems,
    E? separatorBetweenLists,
  }) {
    final List<E> items = [];
    for (int i = 0; i < length; i++) {
      items.addAll([
        ...this[i].fuse((index, e) => element(e), sepatarorBetweenItems),
        if (i != length - 1 && separatorBetweenLists != null)
          separatorBetweenLists
      ]);
    }
    return items;
  }
}

extension IterableMerging<T> on Iterable<T> {
  T? getFirst(bool Function(T e) test) {
    for (final item in this) {
      if (test(item)) return item;
    }
  }
}

extension ListMerging<T> on List<T> {
  void replaceWhere(bool Function(T e) validator, T Function(T e) newValue) {
    for (int i = 0; i < length; i++) {
      final item = elementAt(i);
      if (validator(item)) this[i] = newValue(item);
    }
  }

  Map<K, V> toMap<K, V>(MapEntry<K, V> Function(int index, T e) test) {
    final Map<K, V> map = {};
    for (var i = 0; i < length; i++) {
      final item = this[i];
      final entry = test(i, item);
      map[entry.key] = entry.value;
    }
    return map;
  }

  List<T> textSearch(String query, List<String> Function(T e) test) {
    final List<T> items = [];
    final String queryLowerCase = query.toLowerCase();
    for (final T item in this) {
      for (final String text in test(item)) {
        final String lowercase = text.toLowerCase();
        if (lowercase.contains(queryLowerCase) ||
            lowercase.removeDiacriticalMarks().contains(queryLowerCase)) {
          items.add(item);
          break;
        }
      }
    }
    return items;
  }

  List<T> repeat(int times) {
    final List<T> items = [];
    for (int i = 0; i < times; i++) {
      items.addAll(this);
    }
    return items;
  }

  ///Do that:
  ///```dart
  /// if (!contains(element)) add(element);
  ///```
  void addIfNotContains(T element) {
    if (!contains(element)) add(element);
  }

  ///Do that:
  ///```dart
  /// //Input
  /// final List<Widget> children = [
  ///   ProductModel(),
  ///   ProductModel(),
  ///   ProductModel(),
  ///   ProductModel(),
  /// ].fuse<Widget>((index, product) {
  ///   return ProductTile(product);
  /// }, const Spacer());
  ///
  ///
  /// //Printing result
  /// print(children);
  ///
  /// [
  ///   ProductTile(),
  ///   const Spacer(),
  ///   ProductTile(),
  ///   const Spacer(),
  ///   ProductTile(),
  ///   const Spacer(),
  ///   ProductTile(),
  /// ]
  ///```
  List<E> fuse<E>(E Function(int index, T e) element, [E? separator]) {
    final List<E> items = [];
    for (int i = 0; i < length; i++) {
      items.addAll([
        element(i, this[i]),
        if (i != length - 1 && separator != null) separator
      ]);
    }
    return items;
  }

  List<E> removeMapDuplicates<E>(E Function(T e) f) {
    return map(f).toSet().toList();
  }

  List<T> removeDuplicates<E>() {
    return toSet().toList();
  }

  List<E> mapIndexed<E>(E Function(int index, T e) f) {
    return conditionalMapIndexed(f);
  }

  List<E> conditionalMap<E>(E? Function(T e) f) {
    return conditionalMapIndexed((_, e) => f(e));
  }

  List<E> conditionalMapIndexed<E>(E? Function(int index, T e) f) {
    final List<E> items = [];
    for (int i = 0; i < length; i++) {
      final value = f(i, this[i]);
      if (value != null) items.add(value);
    }
    return items;
  }

  ///Do that:
  ///```dart
  /// //Input
  /// final output = [
  ///   ProductTile(),
  ///   ProductTile(),
  ///   ProductTile(),
  ///   ProductTile(),
  /// ].separete(const Spacer());
  ///
  ///
  /// //Printing result
  /// print(output);
  ///
  /// [
  ///   ProductTile(),
  ///   const Spacer(),
  ///   ProductTile(),
  ///   const Spacer(),
  ///   ProductTile(),
  ///   const Spacer(),
  ///   ProductTile(),
  /// ]
  ///```
  List<T> separete(T separator) {
    final List<T> items = [];
    for (int i = 0; i < length; i++) {
      items.addAll([this[i], if (i != length - 1) separator]);
    }
    return items;
  }
}
