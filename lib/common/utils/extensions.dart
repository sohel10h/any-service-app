extension CapitalizeFirst on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension NullIfEmpty on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}
