extension ExtendedList<T> on List<T> {
  /// Adds an element between every element in the List.
  List<T> addElementBetweenElements(var elementToAdd) {
    List<T> newList = [];
    for (int i = 0; i < length; i++) {
      // Add element from old list to newList
      newList.add(this[i]);
      if (i == length - 1) {
        continue;
      }
      // Add elementToAdd to newList
      newList.add(elementToAdd);
    }
    return newList;
  }
}

extension NullableExtendedList<T> on List<T>? {
  /// Check if a nullable list is null or empty
  bool get isEmptyOrNull {
    if (this == null) {
      return true;
    }

    if (this!.isEmpty) {
      return true;
    }

    return false;
  }
}
