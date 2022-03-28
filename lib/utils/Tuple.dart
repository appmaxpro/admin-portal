class Tuple {
  final List<dynamic> items;

  @override
  final int hashCode;

  Tuple(this.items) : hashCode = items.hashCode;

  dynamic operator [](int index) => items[index];

  @override
  bool operator ==(dynamic other) {
    if(other is! Tuple) return false;
    return Set<dynamic>.of(other.items) == Set<dynamic>.of(items);
    //return IterableEquality().equals(this.items, other.items);
  }
}